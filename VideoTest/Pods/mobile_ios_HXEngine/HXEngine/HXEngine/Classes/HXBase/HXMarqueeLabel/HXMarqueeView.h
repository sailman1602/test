//
//  HXMarqueeView.h
//  newHfax
//
//  Created by lly on 2017/8/16.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class HXMarqueeView;

@protocol HXMarqueeViewDelegate <NSObject>

- (void)marqueeView:(HXMarqueeView *)marqueeView didStopped:(BOOL)isFinished;

@end

typedef NS_ENUM(NSInteger, HXMarqueeSpeedLevel) {
    HXMarqueeSpeedLevelFast       = 2,
    HXMarqueeSpeedLevelMediumFast = 4,
    HXMarqueeSpeedLevelMediumSlow = 6,
    HXMarqueeSpeedLevelSlow       = 8,
};

@interface HXMarqueeView : UIView

@property (nonatomic,copy  ) NSString             *msg;
@property (nonatomic,strong) UIColor              *bgColor;
@property (nonatomic,strong) UIColor              *txtColor;
@property (nonatomic,strong) UIFont               *marqueeLabelFont;

@property (nonatomic,assign) BOOL repeat;//是否重复滚动

@property (nonatomic,weak) id<HXMarqueeViewDelegate> delegate;
//@property (nonatomic,copy) void (^finishBlock)();
/**
 *  style is default, backgroundColor is white,textColor is black;
 *
 *  @param speed you can set 2,4,6,8.  smaller is faster
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame speed:(HXMarqueeSpeedLevel)speed Msg:(NSString *)msg ;

/**
 *  style is diy, backgroundColor and textColor can config
 *
 *  @param speed  you can set 2,4,6,8.  smaller is faster
 *  @param bgColor  backgroundColor
 *  @param txtColor textColor
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame speed:(HXMarqueeSpeedLevel)speed Msg:(NSString *)msg bgColor:(UIColor *)bgColor txtColor:(UIColor *)txtColor;

/**
 *  you can change the tapAction show or jump, without this method default is tap to stop
 *
 *  @param action tapAction block code
 */
- (void)changeTapMarqueeAction:(void(^)())action;

/**
 *  you can change marqueeLabel 's font before start
 *
 */
- (void)changeMarqueeLabelFont:(UIFont *)font;

/**
 *  when you set everything what you want,you can use this method to begin animate
 */
- (void)start;

/**
 *  pause
 */
- (void)stop;

/**
 *  will start with the point we stoped.
 */
- (void)restart;


@end
