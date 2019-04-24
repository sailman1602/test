//
//  ModalView.m
//  CYViews
//
//  Created by songhe on 6/17/15.
//  Copyright (c) 2015 Chunyu. All rights reserved.
//

#import "ModalView.h"
#import "UIView+BFExtension.h"

@implementation ModalView {
    ModalViewLevel _modalViewLevel;
}

- (instancetype)initWithFrame:(CGRect)frame level:(ModalViewLevel)level {
    self = [super initWithFrame:frame];
    if (self) {
        [self addBackView:level];
    }
    return self;
}

- (void)addBackView:(ModalViewLevel)level{
    _modalViewLevel = level;
    
    _backView = [[UIView alloc] initWithFrame:self.bounds];
    _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    _backView.userInteractionEnabled = YES;
    [_backView addGestureRecognizer:tap];
    
    self.dissmissOnBackgroundTap = YES;
    self.animationDuration = 0.3;
    self.showType = kModalViewShowFromCenter;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame level:kModalViewLevelNormal];
}

- (void)show {
    [ModalViewContainer willShowModalView:self level:_modalViewLevel];
}

- (void)dismiss {
    [self dismissWithResult:nil];
}

- (void)backgroundTapped:(UIGestureRecognizer *)gesture {
    if (self.dissmissOnBackgroundTap) {
        [self dismiss];
    }
}

- (void)dismissWithResult:(NSDictionary *)result {
    ModalView *retainSelf = self;
    
    // dismiss
    [self dismissAnimationCompletion:^{
        [_backView removeFromSuperview];
        [ModalViewContainer didHideModalView:self level:_modalViewLevel];
    }];
    
    // notify result
    if (retainSelf.resultBlock) {
        retainSelf.resultBlock(retainSelf, result);
    }
}

#pragma mark - private

- (void)showModalView {
    _backView.frame = self.superview.bounds;
    [self.superview insertSubview:_backView belowSubview:self];
    
    CGPoint finalPosition = CGPointMake(self.superview.width / 2, self.superview.height / 2);
    if (self.finalPosition.x != 0 && self.finalPosition.y != 0) {
        finalPosition = self.finalPosition;
    }
    
    if (self.showType == kModalViewShowFromBottom) {
        [self showModalViewFromBottom];
    }
    else if (self.showType == kModalViewShowNoAnimation) {
        self.center = finalPosition;
    }
    else {
        [self showFrom:finalPosition];
    }
}

- (void)showModalViewFromBottom {
    self.top = self.superview.height;
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.bottom = self.superview.height;
    } completion:^(BOOL finished) {
        
    }];
}

// show from pt, with scaling animations
- (void)showFrom:(CGPoint)pt {
    self.center = pt;
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
    }];
    
    //    _backView.alpha = 0;
    [UIView animateWithDuration:0.1 animations:^{
        //       _backView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

// dismiss
- (void)dismissAnimationCompletion:(void(^)())completion {
    if (self.showType == kModalViewShowFromBottom) {
        [self dismissModalViewToBottom:completion];
    }
    else {
        if (completion) completion();
    }
}

- (void)dismissModalViewToBottom:(void(^)())completion {
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.top = self.superview.height;
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

@end


@interface ModalViewWindow : UIWindow

@end

@implementation ModalViewWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc {
}

@end

@implementation ModalViewContainer {
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)dealloc {
}

+ (void)willShowModalView:(ModalView *)modalView level:(ModalViewLevel)level {
    [self updateSharedWindowWithModalView:modalView show:YES level:level];
}

+ (void)didHideModalView:(ModalView *)modalView level:(ModalViewLevel)level {
    [self updateSharedWindowWithModalView:modalView show:NO level:level];
}

#define kModalViewContainerTag 132123

+ (void)updateSharedWindowWithModalView:(ModalView *)modalView show:(BOOL)show level:(ModalViewLevel)level {
    @synchronized(self) {
        static NSMutableDictionary *containerDict;
        if (containerDict == nil) {
            containerDict = [NSMutableDictionary new];
        }
        
        ModalViewContainer *mvc = [self containerForLevel:level containerDict:containerDict];
        
        if (show) {
            modalView.hidden = YES;
            [mvc addSubview:modalView];
        }
        else {
            [modalView removeFromSuperview];
            if (mvc.subviews.count == 0) {
                [self releaseContainerForLevel:level containerDict:containerDict];
            }
        }
    }
}

+ (void)releaseContainerForLevel:(ModalViewLevel)level containerDict:(NSMutableDictionary *)containerDict {
    UIView *container = containerDict[@(level)];
    UIView *mvc = [container viewWithTag:kModalViewContainerTag];
    [mvc removeFromSuperview];
    [containerDict removeObjectForKey:@(level)];
}

+ (ModalViewContainer *)containerForLevel:(ModalViewLevel)level containerDict:(NSMutableDictionary *)containerDict {
    UIView *container = containerDict[@(level)];
    if (container == nil) {
        ModalViewContainer *mvc = [[ModalViewContainer alloc] initWithFrame:[UIScreen mainScreen].bounds];
        mvc.tag =kModalViewContainerTag;
        if (level == kModalViewLevelInView) {
            container = [[UIApplication sharedApplication].delegate window].rootViewController.view;
//            container = [AppDelegate appDelegate].TopVC.view;
        }
        else {
            container = [self windowForLevel:level];
        }
        [container addSubview:mvc];
        containerDict[@(level)] = container;
    }
    return (ModalViewContainer *)[container viewWithTag:kModalViewContainerTag];
}

+ (UIWindow *)windowForLevel:(ModalViewLevel)level {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.frame = [UIScreen mainScreen].bounds;
//    switch (level) {
//        case kModalViewLevelNormal: {
//            window.windowLevel = UIWindowLevelStatusBar;
//            break;
//        }
//        case kModalViewLevelAlert: {
//            window.windowLevel = UIWindowLevelAlert;
//            break;
//        }
//        case kModalViewLevelTopAlert: {
//            window.windowLevel = UIWindowLevelStatusBar;
//            break;
//        }
//        default: {
//            break;
//        }
//    }
    
    window.hidden = NO;
    
    return window;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self showModalView];
}

- (void)showModalView {
    for (NSInteger i = self.subviews.count - 1; i >= 0; --i) {
        UIView *v = self.subviews[i];
        if ([v isKindOfClass:[ModalView class]]) {
            ModalView *mv = (ModalView *)v;
            if (mv.hidden) {
                mv.hidden = NO;
                [mv showModalView];
            }
            break;
        }
    }
}

@end



