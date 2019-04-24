//
//  UIViewController+HXNavigationBar.m
//  newHfax
//
//  Created by lly on 2017/8/11.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "UIViewController+HXNavigationBar.h"
#import "UIImage+Factory.h"
#import "HXUIDefines.h"
#if COCOAPODS_USE_FRAMEWORK
#import <RTRootNavigationController_lly/RTRootNavigationController.h>
#elif COCOAPODS
#import "RTRootNavigationController.h"
#else
#import <RTRootNavigationController/RTRootNavigationController.h>
#endif

#define NavBarItem_Width   32
#define NavBarItem_Height  22


@implementation UIViewController (HXNavigationBar)
#pragma mark - barItem
- (void)setNavigationBarBackItem:(BOOL)needHide backSel:(SEL)selector{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    if(!needHide){
        
        //        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        leftBtn.frame = CGRectMake(0, 0, NavBarItem_Width, NavBarItem_Width);
        //#ifdef __IPHONE_11_0
        //        if (@available(iOS 11.0, *)) {
        //            leftBtn.translatesAutoresizingMaskIntoConstraints = NO;
        //            [leftBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -2.5, 0, 5)];
        //        } else {
        //            leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        //        }
        //#endif
        //        [leftBtn setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
        //        [leftBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back_black"] style:UIBarButtonItemStylePlain target:self action:selector];
        self.navigationItem.leftBarButtonItems = @[leftItem];
    }else{
        self.navigationItem.leftBarButtonItems = @[negativeSpacer];
    }
}

- (void)hideNavDividerLine{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)setHideNavDividerLine:(BOOL)hideNavDivider{
    [self.navigationController.navigationBar setShadowImage:hideNavDivider?[UIImage new]:[UIImage newWithColor:UIColorFromRGB(0xc5c5c5) height:0.5]];
}

- (void)addNavigationRightBtnWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target sel:(SEL)sel{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, NavBarItem_Height);
    btn.titleLabel.font = HXFont(13.0);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navRightBarTitleItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems = @[navRightBarTitleItem];
}

#pragma mark -back
- (void)popViewContrller{
    [self.rt_navigationController popViewControllerAnimated:YES];
}

@end
