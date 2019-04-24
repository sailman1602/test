//
//  UIView+Corner.m
//  瀑布流
//
//  Created by SongHe on 17/5/21.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "UIView+Corner.h"

@implementation UIView (Corner)

//圆角设置
- (void)setCornerWithRadius:(float)radius{
    UIRectCorner corner = UIRectCornerTopRight | UIRectCornerBottomRight |UIRectCornerTopLeft | UIRectCornerBottomLeft;
    [self setCornerRadiusWith:corner Radius:radius];
}

- (void)setCornerRadiusWith:(UIRectCorner)corner Radius:(float)radius{
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    //CAShapeLayer: 通过给定的贝塞尔曲线UIBezierPath,在空间中作图
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = bezier.CGPath;
    self.layer.mask = maskLayer;
    self.clipsToBounds = YES;
}

- (void)setBorderColor:(UIColor *)color borderWidth:(CGFloat)width cornerRadius:(CGFloat)cornerRadius {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}




@end
