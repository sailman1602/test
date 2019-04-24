//
//  UIView+phc_addition.h
//  p2p
//
//  Created by Philip on 9/7/15.
//  Copyright © 2015 PHSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Factory)

- (UIView *)fc_configureBottomBorderWithHeight:(CGFloat)height color:(UIColor *)color;

- (UIView *)fc_configureTopBorderWithHeight:(CGFloat)height color:(UIColor *)color;

- (UIView *)fc_configureLeftBorderWithWidth:(CGFloat)width color:(UIColor *)color;

- (UIView *)fc_configureRightBorderWithWidth:(CGFloat)width color:(UIColor *)color;


+ (UIView *)fc_lineWithSize:(CGSize)size color:(UIColor *)color;

+ (instancetype )fc_viewWithFrame:(CGRect)frame backColor:(UIColor *)backColor;

+ (instancetype)fc_lineWithPattern:(NSString *)name width:(NSInteger)width height:(NSInteger)height;

+ (instancetype)fc_roundView:(CGFloat)radius;

+ (instancetype)fc_roundViewWithDiameter:(CGFloat)diameter;

- (void)fc_setBorderColor:(UIColor *)color;

@end
