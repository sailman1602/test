//
//  UIView+Corner.h
//  瀑布流
//
//  Created by SongHe on 17/5/21.
//  Copyright © 2017年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Corner)
//圆角设置,默认四个角
- (void)setCornerWithRadius:(float)radius;
// 单独设置，比如UIRectCornerTopLeft
- (void)setCornerRadiusWith:(UIRectCorner)corner Radius:(float)radius;
- (void)setBorderColor:(UIColor *)color borderWidth:(CGFloat)width cornerRadius:(CGFloat)cornerRadius;
@end
