//
//  UITabBarController+TabBar.h
//  newHfax
//
//  Created by lly on 2017/11/7.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (TabBar)

- (void)addTabBarMaskWithColor:(UIColor *)color alhpa:(CGFloat)alpha;
- (void)removeTabBarMask;
- (void)addTabBarRedPoint;
- (void)removeTabBarRedPoint;
@end
