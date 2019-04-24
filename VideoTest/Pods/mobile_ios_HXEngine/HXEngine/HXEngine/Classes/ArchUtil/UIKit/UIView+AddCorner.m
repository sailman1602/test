//
//  UIView+AddCorner.m
//  JRJInvestAdviser
//
//  Created by FarTeen on 12/17/14.
//  Copyright (c) 2014 jrj. All rights reserved.
//

#import "UIView+AddCorner.h"

@implementation UIView (AddCorner)

- (void)addCornerWithPosition:(UIRectCorner)corner
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(10., 10.)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = maskPath.CGPath;
    self.layer.mask = shapeLayer;
}
- (void)addCornerWithCorner:(UIRectCorner)corner radius:(CGSize)radius
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:radius];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = maskPath.CGPath;
    self.layer.mask = shapeLayer;
}

- (void)addBorderWithCorder:(UIRectCorner)corner radius:(CGSize)radius borderColor:(UIColor *)borderColor
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:radius];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = maskPath.CGPath;
    self.layer.mask = shapeLayer;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1;///[UIScreen mainScreen].scale;
}

@end
