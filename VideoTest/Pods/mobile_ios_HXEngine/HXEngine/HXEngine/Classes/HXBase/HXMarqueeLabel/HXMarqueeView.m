//
//  HXMarqueeView.m
//  newHfax
//
//  Created by lly on 2017/8/16.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXMarqueeView.h"
#import "HXUIDefines.h"

typedef void(^HXWonderfulAction)();

typedef NS_ENUM(NSInteger, HXMarqueeTapMode) {
    HXMarqueeTapForMove = 1,
    HXMarqueeTapForAction = 2
};

@interface HXMarqueeView ()<CAAnimationDelegate,NSCopying>

@property (nonatomic,strong) UIButton             *bgBtn;
@property (nonatomic,strong) UILabel              *marqueeLbl;
@property (nonatomic,strong) NSTimer              *timer;
@property (nonatomic,copy  ) HXWonderfulAction     tapAction;
//@property (nonatomic,strong) SXColorGradientView  *leftFade;
//@property (nonatomic,strong) SXColorGradientView  *rightFade;
@property (nonatomic,assign) HXMarqueeTapMode      tapMode;
@property (nonatomic,assign) HXMarqueeSpeedLevel   speedLevel;
@property (nonatomic,strong) UIView               *middleView;
@property (nonatomic,assign) CGFloat   textWidth;
@property (nonatomic,assign) BOOL   isPaused;

@end

@implementation HXMarqueeView

- (instancetype)initWithFrame:(CGRect)frame speed:(HXMarqueeSpeedLevel)speed Msg:(NSString *)msg bgColor:(UIColor *)bgColor txtColor:(UIColor *)txtColor{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 2;
        if(bgColor){
            self.bgColor = bgColor;
        }else{
            self.bgColor             = UIColorFromRGB(0xfafafa);
        }
        
        if (txtColor) {
            self.txtColor = txtColor;
        }else{
            self.txtColor = UIColorFromRGB(0x686868);
        }
        
        if (speed) {
            self.speedLevel = speed;
        }else{
            self.speedLevel = 3;
        }
        
        [self doSometingBeginning];
        self.msg = msg;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame speed:(HXMarqueeSpeedLevel)speed Msg:(NSString *)msg{
    if (self = [super initWithFrame:frame]) {
        if (speed) {
            self.speedLevel = speed;
        }else{
            self.speedLevel = 3;
        }
        self.bgColor             = [UIColor clearColor];
        self.txtColor = UIColorFromRGB(0x686868);
        [self doSometingBeginning];
        self.msg = msg;
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
//    CGFloat w = self.frame.size.width;
//    CGFloat h = self.frame.size.height;
//    self.leftFade.frame = CGRectMake(0, 0, h, h);
//    self.rightFade.frame = CGRectMake(w - h, 0, h, h);
}

- (void)doSometingBeginning{
    self.layer.masksToBounds = YES;
    self.backgroundColor = self.bgColor;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backAndRestart) name:@"UIApplicationDidBecomeActiveNotification" object:nil];
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.middleView = middleView;
    [_middleView addSubview:self.marqueeLbl];
    [self addSubview:_middleView];
    [self addLeftAndRightGradient];
}

- (void)changeTapMarqueeAction:(void(^)())action{
    [self addSubview:self.bgBtn];
    self.tapAction = action;
    self.tapMode = HXMarqueeTapForAction;
}

- (void)changeMarqueeLabelFont:(UIFont *)font{
    self.marqueeLbl.font = font;
    self.marqueeLabelFont = font;
    CGSize msgSize = [_marqueeLbl.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    if(msgSize.width>self.frame.size.width){
        CGRect fr = self.marqueeLbl.frame;
        fr.size.width = msgSize.width;
        self.marqueeLbl.frame = fr;
    }
    self.textWidth = msgSize.width;
}

- (UIButton *)bgBtn{
    if (!_bgBtn) {
        CGFloat w = self.frame.size.width;
        CGFloat h = self.frame.size.height;
        _bgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, w, h)];
        [_bgBtn addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}

- (UILabel *)marqueeLbl{
    if (!_marqueeLbl) {
        self.tapMode = HXMarqueeTapForMove;
//        CGFloat h = self.frame.size.height;
        _marqueeLbl = [[UILabel alloc]init];
        _marqueeLbl.text = self.msg;
        _marqueeLbl.textAlignment = NSTextAlignmentLeft;
        _marqueeLbl.userInteractionEnabled = NO;
        if (self.marqueeLabelFont != nil) {
            _marqueeLbl.font = self.marqueeLabelFont;
        }else{
            UIFont *fnt = HXFont(13.0f);
            _marqueeLbl.font = fnt;
        }
        CGSize msgSize = [_marqueeLbl.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_marqueeLbl.font,NSFontAttributeName, nil]];
        if(msgSize.width>self.frame.size.width){
            self.marqueeLbl.frame = CGRectMake(0, 0, msgSize.width, self.frame.size.height);
        }else{
            _marqueeLbl.frame = self.bounds;
        }
        self.textWidth = msgSize.width;
        _marqueeLbl.textColor = self.txtColor;
    }
    return _marqueeLbl;
}

- (void)setMsg:(NSString *)msg{
    _msg = msg;
    CGSize msgSize = [_msg sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.marqueeLbl.font,NSFontAttributeName, nil]];
    if(msgSize.width>self.frame.size.width){
        self.marqueeLbl.frame = CGRectMake(0, 0, msgSize.width, self.frame.size.height);
    }else{
        _marqueeLbl.frame = self.bounds;
    }
    self.textWidth = msgSize.width;
    self.marqueeLbl.text = msg;
    self.marqueeLbl.layer.frame = self.marqueeLbl.bounds;
    [self.marqueeLbl.layer removeAllAnimations];
    [self setNeedsDisplay];
}

- (void)setTxtColor:(UIColor *)txtColor{
    _txtColor = txtColor;
    _marqueeLbl.textColor = _txtColor;
}

- (void)addLeftAndRightGradient{
//    CGFloat w = self.frame.size.width;
//    CGFloat h = self.frame.size.height;
//    SXColorGradientView *leftFade = [SXColorGradientView createWithColor:self.bgColor frame:CGRectMake(0, 0, h, h) direction:SXGradientToRight];
//    self.leftFade = leftFade;
//    
//    SXColorGradientView *rightFade = [SXColorGradientView createWithColor:self.bgColor frame:CGRectMake(w - h, 0, h, h) direction:SXGradientToLeft];
//    self.rightFade = rightFade;
//    
//    [self addSubview:leftFade];
//    [self addSubview:rightFade];
}

- (void)bgButtonClick{
    if (self.tapAction) {
        self.tapAction();
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    if (self.tapMode == HXMarqueeTapForMove) {
//        [self stop];
//    }
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    if (self.tapMode == HXMarqueeTapForMove) {
//        [self restart];
//    }
//}

#pragma mark - 操作
- (void)start{
//    HXLog(@"marqueeLbl start frame:%@",NSStringFromCGRect(self.marqueeLbl.frame));
    [self moveAction];
}

- (void)backAndRestart{
    [self.marqueeLbl.layer removeAllAnimations];
    [self.marqueeLbl removeFromSuperview];
    self.marqueeLbl = nil;
    [self.middleView addSubview:self.marqueeLbl];
    [self moveAction];
}

- (void)stop{
    [self pauseLayer:self.marqueeLbl.layer];
}

- (void)restart{
//    if(!self.isPaused) {
        [self backAndRestart];
//    }else{
//        [self resumeLayer:self.marqueeLbl.layer];
//    }
}

- (void)moveAction
{
//    CGRect fr = self.marqueeLbl.frame;
//    fr.origin.x = self.frame.size.width;
//    self.marqueeLbl.frame = fr;
    
    if(self.textWidth>self.frame.size.width){
        //    CGPoint fromPoint = CGPointMake(self.frame.size.width + self.marqueeLbl.frame.size.width/2, self.frame.size.height/2);
        CGPoint fromPoint = self.marqueeLbl.center;//CGPointMake(self.frame.size.width/2 , self.frame.size.height/2);
        
        UIBezierPath *movePath = [UIBezierPath bezierPath];
        [movePath moveToPoint:fromPoint];
        //    [movePath addLineToPoint:CGPointMake(-self.marqueeLbl.frame.size.width/2, self.frame.size.height/2)];
        [movePath addLineToPoint:CGPointMake(self.frame.size.width/2 -((self.textWidth -self.frame.size.width)+20)/2 , self.frame.size.height/2)];
        
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = movePath.CGPath;
        moveAnim.removedOnCompletion = NO;
        moveAnim.fillMode = kCAFillModeForwards;
        
        moveAnim.duration = (self.marqueeLbl.frame.size.width - self.frame.size.width) * self.speedLevel * 0.01;
        [moveAnim setDelegate:self];
        
        [self.marqueeLbl.layer addAnimation:moveAnim forKey:nil];
    }else{
        if(self.delegate && [self.delegate respondsToSelector:@selector(marqueeView:didStopped:)]){
            [self.delegate marqueeView:self didStopped:YES];
        }
    }
}

-(void)pauseLayer:(CALayer*)layer
{
    self.isPaused = YES;
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    if(!self.isPaused) return;
    CFTimeInterval pausedTime = layer.timeOffset;
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
    self.isPaused = NO;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag&&self.repeat) {
        [self moveAction];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(marqueeView:didStopped:)]){
        [self.delegate marqueeView:self didStopped:flag];
    }
}


- (id)copyWithZone:(nullable NSZone *)zone{
    HXMarqueeView *v = [[HXMarqueeView alloc]initWithFrame:self.frame speed:self.speedLevel Msg:self.msg];
    return v;
}
@end
