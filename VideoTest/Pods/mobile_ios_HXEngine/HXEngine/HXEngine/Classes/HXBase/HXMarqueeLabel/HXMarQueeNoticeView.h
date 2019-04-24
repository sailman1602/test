//
//  HXMarQueeNoticeView.h
//  newHfax
//
//  Created by lly on 2017/8/16.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HXMarQueeNoticeActionBlock)(NSInteger index);

@interface HXMarQueeNoticeView : UIView

/**
 *  input messages
 */
@property (nonatomic,strong) NSArray         *messageArray;
/**
 *  text color for message label
 */
@property (nonatomic,strong) UIColor         *textColor;
/**
 *  text font for message label
 */
@property (nonatomic,strong) UIFont          *textFont;
/**
 *  backgroundColor for headlineView
 */
@property (nonatomic,strong) UIColor         *bgColor;
/**
 *  set self.layer.cornerRadius
 */
@property (nonatomic,assign) CGFloat          cornerRadius;

/**
 *  the Animation duration for label scroll to nextLabel.
 */
@property (nonatomic,assign) NSTimeInterval   scrollDuration;
/**
 *  the duration for the label hold at a standstill
 */
@property (nonatomic,assign) NSTimeInterval   stayDuration;

- (instancetype)initWithFrame:(CGRect)frame messages:(NSArray <NSString *> *)messages;

/**
 *  you can set three property together.
 */
- (void)setBgColor:(UIColor *)bgColor textColor:(UIColor *)textColor textFont:(UIFont *)textFont;
/**
 *  you can set two timeInterval setting toghter.
 */
- (void)setScrollDuration:(NSTimeInterval)scrollDuration stayDuration:(NSTimeInterval)stayDuration;

/**
 *  you can change the tapAction show or jump, without this method default is tap to stop
 *
 *  @param action tapAction block code
 */
//- (void)changeTapMarqueeAction:(void(^)(NSInteger index))action;
- (void)changeTapMarqueeAction:(HXMarQueeNoticeActionBlock)action;

/**
 *  add the timer and start headline animation.
 */
- (void)start;
/**
 *  stop the timer.
 */
- (void)stop;
/**
 *  will start with the point we stoped.
 */
- (void)restart;

@end
