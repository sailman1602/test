//
//  UIView+HXShow.m
//  newHfax
//
//  Created by lly on 2017/7/2.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "UIView+HXShow.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "HXToast.h"
#import "HXBaseViewController.h"
#if COCOAPODS_USE_FRAMEWORK
#import <RTRootNavigationController_lly/RTRootNavigationController.h>
#elif COCOAPODS
#import "RTRootNavigationController.h"
#else
#import <RTRootNavigationController/RTRootNavigationController.h>
#endif
#import <objc/runtime.h>
#import "HXUIDefines.h"
#import "UILabel+Factory.h"
#import "HXEngineConfiguration.h"

#define kTagOfNoDataView 8891
#define kTagOfNoNetworkView 8892
#define kTagOfErrorView 8893

@implementation UIView (HXShow)

#pragma mark -getter and setter
- (CGFloat)defaultViewOffset{
    return [objc_getAssociatedObject(self, @selector(defaultViewOffset)) floatValue];
}

- (void)setDefaultViewOffset:(CGFloat)defaultViewOffset{
    objc_setAssociatedObject(self, @selector(defaultViewOffset), @(defaultViewOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)defaultViewTop{
    return [objc_getAssociatedObject(self, @selector(defaultViewTop)) floatValue];
}

- (void)setDefaultViewTop:(CGFloat)defaultViewTop{
    objc_setAssociatedObject(self, @selector(defaultViewTop), @(defaultViewTop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)descMargin{
    return [objc_getAssociatedObject(self, @selector(descMargin)) floatValue];
}

- (void)setDescMargin:(CGFloat)descMargin{
    objc_setAssociatedObject(self, @selector(descMargin), @(descMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)noDataDesc{
    return objc_getAssociatedObject(self, @selector(noDataDesc));
}

- (void)setNoDataDesc:(NSString *)noDataDesc{
    objc_setAssociatedObject(self, @selector(noDataDesc), noDataDesc, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)noDataImage{
    return objc_getAssociatedObject(self, @selector(noDataImage));
}

- (void)setNoDataImage:(NSString *)noDataImage{
    objc_setAssociatedObject(self, @selector(noDataImage), noDataImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)noNetworkImage{
    return objc_getAssociatedObject(self, @selector(noNetworkImage));
}

- (void)setNoNetworkImage:(NSString *)noNetworkImage{
    objc_setAssociatedObject(self, @selector(noNetworkImage), noNetworkImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)dataErrorImage{
    return objc_getAssociatedObject(self, @selector(dataErrorImage));
}

- (void)setDataErrorImage:(NSString *)dataErrorImage{
    objc_setAssociatedObject(self, @selector(dataErrorImage), dataErrorImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - loading
- (void)showLoadingView:(NSString *)loadingMsg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [self updateWithHud:hud];
    hud.labelText = loadingMsg.length?loadingMsg:@"加载中...";
}
- (void)showLoadingView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [self updateWithHud:hud];
    hud.labelText = @"加载中...";
}

- (void)updateWithHud:(MBProgressHUD *)hud {
    HXEngineConfiguration *config = [HXEngineConfiguration sharedInstance];
    if (config && config.toastSetting) {
        
        hud.contentColor = config.contentColor;
        hud.bezelView.color = config.bgColor;
        hud.bezelView.alpha = config.alpha;

        hud.bezelView.layer.cornerRadius = config.cornerRadius;
        hud.bezelView.layer.masksToBounds = YES;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//
        hud.label.textColor = config.textColor;
        hud.label.font =
                [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    }

}

- (void)hideLoadingView{
    [MBProgressHUD hideAllHUDsForView:self animated:NO];
}

#pragma mark - toast
- (void)showToast:(NSString *)info duration:(float)inDuration{
    HXToast * tost = [[HXToast alloc] initWithView:self text:info duration:MAX(2, inDuration)];
    [tost show];
}

- (void)showToastOnWindow:(NSString *)info duration:(float)inDuration{
    HXToast * tost = [[HXToast alloc] initWithView:[UIApplication sharedApplication].keyWindow text:info duration:MAX(2, inDuration)];
    [tost show];
}

- (void)showToast:(NSString *)info{
    [self showToast:info duration:1.5];
}
- (void)showToastOnWindow:(NSString *)info{
    [self showToastOnWindow:info duration:1.5];
}


#pragma mark - default no data
- (void)showNoDataView{
    [self showNoDataView:self.noDataImage?self.noDataImage:@"default_no_data" descMargin:self.descMargin?self.descMargin:47];
}

- (void)showNoDataView:(NSString *)image descMargin:(CGFloat)descMargin{
    if([self viewWithTag:kTagOfNoDataView])
        return;
    [self hideDefaultView];
    UIView *defaultView = [self viewWithFrame:[self defaultViewFrame] image:image desc:self.noDataDesc?self.noDataDesc:@"暂无数据" descMargin:descMargin tag:kTagOfNoDataView];
    [self addSubview:defaultView];
    
    [self bringSubviewToFront:defaultView];
}
- (void)hideNoDataView{
    UIView *view = [self viewWithTag:kTagOfNoDataView];
    [view removeFromSuperview];
}


#pragma mark - default no netWork
- (void)showNoNetworkView{
    [self showNoNetworkView:self.noNetworkImage?self.noNetworkImage:@"default_no_network" descMargin:self.descMargin?self.descMargin:35];
}

- (void)showNoNetworkView:(NSString *)image descMargin:(CGFloat)descMargin{
    if([self viewWithTag:kTagOfNoNetworkView])
        return;
     [self hideDefaultView];
    UIView *noNetworkView = [self viewWithFrame:[self defaultViewFrame] image:image desc:@"咦？当前网络不给力~" descMargin:descMargin tag:kTagOfNoNetworkView];
    //    noNetworkView.frame = self.bounds;
    [self addSubview:noNetworkView];
    
    [self bringSubviewToFront:noNetworkView];
}

-(void)hideNoNetworkView{
    UIView *view = [self viewWithTag:kTagOfNoNetworkView];
    [view removeFromSuperview];
}
#pragma mark - default data error
- (void)showDataErrorView{
    [self showDataErrorView:self.dataErrorImage?self.dataErrorImage:@"default_no_network" descMargin:self.descMargin?self.descMargin:35];
}

- (void)showDataErrorView:(NSString *)image descMargin:(CGFloat)descMargin{
    if([self viewWithTag:kTagOfErrorView])
        return;
     [self hideDefaultView];
    UIView *errorView = [self viewWithFrame:[self defaultViewFrame] image:image desc:@"暂无信息展示" descMargin:descMargin tag:kTagOfErrorView];
    //    errorView.frame = self.bounds;
    [self addSubview:errorView];
    
    [self bringSubviewToFront:errorView];
}

- (CGRect)defaultViewFrame{
//    if([self isKindOfClass:[UITableView class]]){
//        CGFloat heraderHeight = ((UITableView *)self).tableHeaderView.height;
//        CGFloat footerHeight = ((UITableView *)self).tableFooterView.height;
//        CGRect frame = self.bounds;
//        frame.origin.y = heraderHeight;
//        frame.size.height = frame.size.height-(heraderHeight+footerHeight);
//        return frame;
//    }else{
        return self.bounds;
//    }
}

- (void)hideDataErrorView{
    UIView *view = [self viewWithTag:kTagOfErrorView];
    [view removeFromSuperview];
}

- (void)hideDefaultView{
    [self hideNoDataView];
    [self hideNoNetworkView];
    [self hideDataErrorView];
}

- (void)hideNoNetworkOrErrorView{
    [self hideNoNetworkView];
    [self hideDataErrorView];
}

#pragma mark - new view
- (UIView *)viewWithFrame:(CGRect)frame image:(NSString *)image desc:(NSString *)desc descMargin:(CGFloat)descMargin tag:(NSInteger)tag{
    if(self.defaultViewTop>0){
        CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y+self.defaultViewTop, frame.size.width, frame.size.height-self.defaultViewTop);
        frame = newFrame;
    }
    UIView *v = [[UIView alloc]initWithFrame:frame];
    v.backgroundColor = HXBGColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapAction:)];
    [v addGestureRecognizer:tap];
    v.tag = tag;
    
    UIImage *showImage = [UIImage imageNamed:image];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-showImage.size.width/2, MIN(frame.size.height/2-showImage.size.height/2 - descMargin/2+self.defaultViewOffset,ScaleHeight(109)), showImage.size.width, showImage.size.height)];
    imageView.image = showImage;
    imageView.userInteractionEnabled = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [v addSubview:imageView];
    
    UILabel *l = [UILabel newWithText:desc font:HXFont(13) textColor:HXFontAssistColor];
    l.textAlignment = NSTextAlignmentCenter;
    l.frame = CGRectMake(20, CGRectGetMaxY(imageView.frame)+descMargin, frame.size.width-40, 20);
    l.userInteractionEnabled = NO;
    [v addSubview:l];
    
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(65, 65));
//    }];
    
//    [l mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.top.equalTo(imageView.mas_bottom).offset(10);
//    }];
    
    return v;
}

- (void)viewTapAction:(UIGestureRecognizer *)r{
    if(r.state == UIGestureRecognizerStateRecognized){
        HXBaseViewController *vc = (HXBaseViewController *)[self hx_viewController];
        if([vc respondsToSelector:@selector(refresh)]){
            [vc refresh];
        }
    }
}

- (UIViewController*)hx_viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[RTContainerController class]]) {
            return ((RTContainerController*)nextResponder).contentViewController;
        }
    }
    return nil;
}

@end
