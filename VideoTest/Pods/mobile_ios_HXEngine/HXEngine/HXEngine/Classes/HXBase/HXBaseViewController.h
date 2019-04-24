//
//  HXBaseViewController.h
//  newHfax
//
//  Created by lly on 2017/6/29.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+HXShow.h"
#import "HXBaseNavigationBar.h"
#import "HXWebJSProtocol.h"

#define NavBarItem_Width   32
#define NavBarItem_Height  22

@class HXBaseWebViewController;

@protocol HXBaseNavigationDelegate

@required
@property (nonatomic,assign) BOOL needHideNavigationBar;
@property (nonatomic,assign) BOOL hideNavDivider;
@property (nonatomic,weak) UIViewController<HXWebJSProtocol> *enteyWebViewController;
@property (nonatomic,strong) NSDictionary *h5ParamsData;

- (void)backToLastController:(UIButton *)sender;
- (void)navPushViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end


@interface HXBaseViewController : UIViewController <HXBaseNavigationDelegate,HXWebJSProtocol>

@property (nonatomic,assign) BOOL needHideNavigationBar;
@property (nonatomic,assign) BOOL needHideNavigationBackBtn;
@property (nonatomic,assign) BOOL hideNavDivider;

@property (nonatomic,assign) BOOL isFirstAppear;//是否是第一次出现
@property (nonatomic,assign) BOOL isVisible; //是否可见
@property (nonatomic,assign) BOOL needLargeTitleMargin;

// 原生页面数据回传h5
@property (nonatomic,weak) UIViewController<HXWebJSProtocol> *enteyWebViewController;
@property (nonatomic,strong) NSDictionary *h5ParamsData;

@property (nonatomic,strong,readonly) UILabel *largeTitleLabel;//IOS11风格的大标题
- (void)addLargeTitle;//直接初始化largeTitleLabel，加在self.view
- (void)addLargeTitleOnScrollView:(UIScrollView *)scrollView;//直接初始化largeTitleLabel，加在scrollView
- (void)refreshTitleWithScrollViewOffset:(CGFloat)offset;//如果加在scrollView，scrollView did scroll的时候调用这个方法

//页面逻辑操作成功后的逻辑，成功后页面需要消失的时候,如果这个block不为nil，要调这个block
@property (nonatomic,copy) void (^successActionBlock)(void);
@property (nonatomic,copy) void (^failActionBlock)(void);

//refresh muset be overWrite
- (BFTask *)refresh;

////reqest error must needed
- (void)showNoNetworkOrError:(NSError *)error;
- (void)showNoNetworkOrError:(NSError *)error showDefaultNav:(BOOL)showDefaultNav;

// event when back is pressed
- (void)backToLastController:(UIButton *)sender;

#pragma mark - push/pop
- (void)navPushViewController:(UIViewController *)viewController animated:(BOOL)animated;//new
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;//overWrite

#pragma mark - can be overwrite to be custom
- (void)addClientUserLoginSuccessRefresh;
- (void)addClientUserLoginoutSuccessRefresh;

@end
