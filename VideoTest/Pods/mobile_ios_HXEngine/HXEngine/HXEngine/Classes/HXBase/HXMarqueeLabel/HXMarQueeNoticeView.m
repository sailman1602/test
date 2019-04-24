//
//  HXMarQueeNoticeView.m
//  newHfax
//
//  Created by lly on 2017/8/16.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXMarQueeNoticeView.h"
#import "HXMarqueeView.h"
#import "UIColor+Factory.h"
#import "HXUIDefines.h"
#import "UIKitMacros.h"
#define kSXHeadLineMargin 0

typedef NS_ENUM(NSInteger, SXMarqueeTapMode) {
    HXMarqueeTapForMove = 1,
    HXMarqueeTapForAction = 2
};

@interface HXMarQueeNoticeView ()<HXMarqueeViewDelegate>

@property (nonatomic,strong) HXMarqueeView              *label1;
@property (nonatomic,strong) HXMarqueeView              *label2;
@property (nonatomic,strong) HXMarqueeView              *showingLabel;
@property (nonatomic,assign) NSInteger             messageIndex;
@property (nonatomic,assign) CGFloat               h;
@property (nonatomic,assign) CGFloat               w;
@property (nonatomic,strong) NSTimer              *timer;
//@property (nonatomic,strong) SXColorGradientView  *viewTop;
//@property (nonatomic,strong) SXColorGradientView  *viewBottom;
@property (nonatomic,strong) UIButton             *bgBtn;
@property (nonatomic,copy  ) HXMarQueeNoticeActionBlock           tapAction;
@property (nonatomic,assign) SXMarqueeTapMode      tapMode;
@property (nonatomic,assign) BOOL couldScorll;

@end

@implementation HXMarQueeNoticeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.h                   = frame.size.height;
        self.w                   = frame.size.width;
        self.bgColor             = [UIColor clearColor];
        self.textColor           = [UIColor blackColor];
        self.scrollDuration      = 1.0f;
        self.stayDuration        = 4.0f;
        self.cornerRadius        = 2;
        self.textFont            = HXFont(13.0f);
        [self addCompoment];
        self.layer.cornerRadius  = self.cornerRadius;
        self.layer.masksToBounds = YES;
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(restart) name:@"UIApplicationDidBecomeActiveNotification" object:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame messages:(NSArray <NSString *> *)messages{
    if(self = [super initWithFrame:frame]){
        self.messageArray = messages;
        self.couldScorll = messages.count>1;
        self.h                   = frame.size.height;
        self.w                   = frame.size.width;
        self.bgColor             = [UIColor clearColor];
        self.textColor           = UIColorFromRGB(0x686868);
        self.scrollDuration      = 1.0f;
        self.stayDuration        = 4.0f;
        self.cornerRadius        = 2;
        self.textFont            = HXFont(13.0f);
        [self addCompoment];
        self.layer.cornerRadius  = self.cornerRadius;
        self.layer.masksToBounds = YES;
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(restart) name:@"UIApplicationDidBecomeActiveNotification" object:nil];
    }
    return self;
}

- (void)addCompoment{
    HXMarqueeView *label1          = [[HXMarqueeView alloc]initWithFrame:CGRectMake(kSXHeadLineMargin, 0, _w, _h) speed:HXMarqueeSpeedLevelMediumFast Msg:self.messageArray.count>0?self.messageArray[0]:@""];
    HXMarqueeView *label2          = [[HXMarqueeView alloc]initWithFrame:CGRectMake(kSXHeadLineMargin, _h, _w, _h) speed:HXMarqueeSpeedLevelMediumFast Msg:self.messageArray.count>1?self.messageArray[1]:@""];
    label1.marqueeLabelFont              = label2.marqueeLabelFont = _textFont;
    label1.txtColor         = label2.txtColor = _textColor;
    self.label1              = label1;
    self.label1.delegate = self;
    self.label2              = label2;
    self.label2.delegate = self;
    [self addSubview:label1];
    [self addSubview:label2];
    [self addSubview:self.bgBtn];
    self.showingLabel = self.label1;
}

- (void)removeCompoment{
    [self.label1 removeFromSuperview];
    [self.label2 removeFromSuperview];
    [self.bgBtn removeFromSuperview];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self start];
}

#pragma mark -
#pragma mark - **************** animate
- (void)scrollAnimate
{
    if(!self.couldScorll){
        [self scrollAnimateFinished];
        return;
    }
    CGRect rect1 = self.label1.frame;
    CGRect rect2 = self.label2.frame;
    rect1.origin.y -= _h;
    rect2.origin.y -= _h;
    [UIView animateWithDuration:_scrollDuration animations:^{
        self.label1.frame = rect1;
        self.label2.frame = rect2;
    } completion:^(BOOL finished) {
        [self checkLabelFrameChange:self.label1];
        [self checkLabelFrameChange:self.label2];
        [self scrollAnimateFinished];
    }];
}

- (void)checkLabelFrameChange:(HXMarqueeView *)label
{
    if (label.frame.origin.y < -10) {
        CGRect rect = label.frame;
        rect.origin.y = _h;
        label.frame = rect;
        if(self.messageIndex>=self.messageArray.count){
            label.msg = self.messageArray.lastObject;
        }else
            label.msg = self.messageArray[self.messageIndex];
        if (self.messageIndex == self.messageArray.count - 1) {
            self.messageIndex = 0;
        }else{
            self.messageIndex += 1;
        }
    }else if (label.frame.origin.y==0){
        self.showingLabel = label;
    }
}

#pragma mark - **************** opration
- (void)start{
    [self.timer invalidate];
    [self.showingLabel start];
}
- (void)stop{
    [self.showingLabel stop];
    [self.timer invalidate];
}

- (void)restart{
    [self.timer invalidate];
    [self.showingLabel restart];
}
//- (void)start{
//    if (self.messageArray.count < 2) {
//        return;
//    }
////    NSTimer *timer = [NSTimer timerWithTimeInterval:_stayDuration target:self selector:@selector(scrollAnimate) userInfo:nil repeats:NO];
////    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
////    self.timer = timer;
//}

//- (void)stop{
////    [self.timer invalidate];
//}

#pragma mark - **************** set
-(void)setMessageArray:(NSArray *)messageArray
{
    _messageArray = messageArray;
    if (self.messageArray.count == 1) {
        self.messageArray = @[self.messageArray[0],self.messageArray[0]];
    }
    
    if (self.messageArray.count > 2) {
        self.label1.msg = self.messageArray[0];
        self.label2.msg = self.messageArray[1];
        self.messageIndex = 2;
    }else if (self.messageArray.count == 2){
        self.label1.msg = self.messageArray[0];
        self.label2.msg = self.messageArray[1];
        self.messageIndex = 0;
    }
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.label1.txtColor = textColor;
    self.label2.txtColor = textColor;
}

- (void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    [self.label1 changeMarqueeLabelFont:textFont];
    [self.label2 changeMarqueeLabelFont:textFont];
}

- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
}

- (void)setScrollDuration:(NSTimeInterval)scrollDuration{
    _scrollDuration = scrollDuration;
}

- (void)setStayDuration:(NSTimeInterval)stayDuration{
    _stayDuration = stayDuration;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setHasGradient:(BOOL)hasGradient{
//    _hasGradient = hasGradient;
//    if (hasGradient) {
//        _viewTop = [SXColorGradientView createWithColor:self.bgColor frame:CGRectMake(0, 0, _w, _h * 0.2) direction:SXGradientToBottom];
//        _viewBottom = [SXColorGradientView createWithColor:self.bgColor frame:CGRectMake(0, _h * 0.8, _w, _h * 0.2) direction:SXGradientToTop];
//        [self addSubview:_viewTop];
//        [self addSubview:_viewBottom];
//    }else{
//        [_viewTop removeFromSuperview];
//        [_viewBottom removeFromSuperview];
//    }
}

- (void)setBgColor:(UIColor *)bgColor textColor:(UIColor *)textColor textFont:(UIFont *)textFont
{
    self.bgColor = bgColor;
    self.textColor = textColor;
    self.textFont = textFont;
}

- (void)setScrollDuration:(NSTimeInterval)scrollDuration stayDuration:(NSTimeInterval)stayDuration
{
    self.scrollDuration = scrollDuration;
    self.stayDuration = stayDuration;
}

- (void)changeTapMarqueeAction:(HXMarQueeNoticeActionBlock)action{
    
    self.tapAction = action;
    self.tapMode = HXMarqueeTapForAction;
}

//- (void)restart
//{
//    [self stop];
//    [self removeCompoment];
//    [self addCompoment];
//    [self setMessageArray:_messageArray];
//    [self start];
//}

- (UIButton *)bgBtn
{
    if (!_bgBtn) {
        CGFloat w = self.frame.size.width;
        CGFloat h = self.frame.size.height;
        _bgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, w, h)];
        [_bgBtn addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [_bgBtn addTarget:self action:@selector(bgButtonPress) forControlEvents:UIControlEventTouchDown];
        _bgBtn.backgroundColor = [UIColor clearColor];
    }
    return _bgBtn;
}

- (void)bgButtonClick
{
    if (self.messageArray.count == 0) return;
    if (self.tapAction)
    {
        HXLog(@"***** messageIndex : %ld", (self.messageIndex + self.messageArray.count - 2)%self.messageArray.count);
        self.tapAction((self.messageIndex + self.messageArray.count - 2)%self.messageArray.count);
    }else{
//        [self start];
    }
}

//- (void)bgButtonPress
//{
//    if (!self.tapAction) {
//        [self stop];
//    }
//}

#pragma mark - delegate
- (void)marqueeView:(HXMarqueeView *)marqueeView didStopped:(BOOL)isFinished{
//    if(marqueeView == self.label1){
//        [self start];
//    }
    if(!isFinished) return;
    [self.timer invalidate];
    self.timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(scrollAnimate) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)scrollAnimateFinished{
    [self.showingLabel start];
}
@end
