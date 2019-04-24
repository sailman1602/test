//
//  UIView+AddCorner.h
//  JRJInvestAdviser
//
//  Created by FarTeen on 12/17/14.
//  Copyright (c) 2014 jrj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AddCorner)
/**
 *  给一个视图根据corner枚举添加圆角
 *  默认corner的CGSize为{10,10}
 */
- (void)addCornerWithPosition:(UIRectCorner)corner;
/**
 *  给一个视图根据corner枚举添加圆角
 */
- (void)addCornerWithCorner:(UIRectCorner)corner radius:(CGSize)radius;
///添加border
- (void)addBorderWithCorder:(UIRectCorner)corner radius:(CGSize)radius borderColor:(UIColor *)borderColor;

@end
