//
//  UITabBarController+TabBar.m
//  newHfax
//
//  Created by lly on 2017/11/7.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "UITabBarController+TabBar.h"

#define HXTabBarMaskTag 123123
#define HXRedPointTag 123124

@implementation UITabBarController (TabBar)

- (void)addTabBarMaskWithColor:(UIColor *)color alhpa:(CGFloat)alpha{
    UIView *v = [[UIView alloc]initWithFrame:self.tabBar.bounds];
    v.tag = HXTabBarMaskTag;
    v.backgroundColor = [color colorWithAlphaComponent:alpha];
    [self.tabBar addSubview:v];
}
- (void)removeTabBarMask{
    UIView *v = [self.tabBar viewWithTag:HXTabBarMaskTag];
    [v removeFromSuperview];
}

- (void)addTabBarRedPoint{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 5)];
    CGFloat perWidth = self.tabBar.frame.size.width/3.0;
    v.center = CGPointMake(2.5 * perWidth + 15 , self.tabBar.frame.size.height/2.0 - 16);
    v.layer.cornerRadius = 2.5;
    v.layer.masksToBounds = YES;
    v.tag = HXRedPointTag;
    v.backgroundColor = [UIColor colorWithRed:255/255.0 green:79/255.0 blue:79/255.0 alpha:1];
    [self.tabBar addSubview:v];
}
- (void)removeTabBarRedPoint{
    UIView *v = [self.tabBar viewWithTag:HXRedPointTag];
    [v removeFromSuperview];
}

@end
