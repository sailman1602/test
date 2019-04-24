//
//  HXBaseNavigationBar.h
//  newHfax
//
//  Created by lly on 2017/9/27.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXBaseViewController.h"

@protocol HXBaseNavigationDelegate;

@interface HXBaseNavigationBar : UIView

@property (nonatomic,weak)  UIViewController<HXBaseNavigationDelegate> *vc;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,assign) BOOL showBackBtn;

@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic,strong) UILabel *unReadLabel;

@property (nonatomic,strong,readonly) UILabel *titleLabel;

@property (nonatomic,strong,readonly) UIView *bgView;

@property (nonatomic,assign) BOOL hideBottomLine;

- (instancetype)initWithHeight:(CGFloat)height viewController:(UIViewController *)vc;
- (void)setUnReadMsgCount:(NSInteger)unReadCount;
+ (instancetype)defaultNavigationBarWithHeight:(CGFloat)height viewController:(UIViewController<HXBaseNavigationDelegate> *)vc hideBottomLine:(BOOL)hide;
- (UIButton *)navigationButtonWithImageStr:(NSString *)imageStr tag:(NSInteger)tag;
- (UIButton *)navigationButtonWithBackImageString:(NSString *)imageStr title:(NSString *)title tag:(NSInteger)tag;

//msust over write
- (void)addUnreadLabel;
@end
