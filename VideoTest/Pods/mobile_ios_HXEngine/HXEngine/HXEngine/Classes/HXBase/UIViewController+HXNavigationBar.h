//
//  UIViewController+HXNavigationBar.h
//  newHfax
//
//  Created by lly on 2017/8/11.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIViewController (HXNavigationBar)

- (void)hideNavDividerLine;
- (void)setHideNavDividerLine:(BOOL)hideNavDivider;
- (void)setNavigationBarBackItem:(BOOL)needHide backSel:(SEL)selector;
- (void)popViewContrller;

- (void)addNavigationRightBtnWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target sel:(SEL)sel;

@end
