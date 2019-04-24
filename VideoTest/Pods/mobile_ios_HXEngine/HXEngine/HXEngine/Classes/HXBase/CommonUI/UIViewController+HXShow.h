//
//  UIViewController+HXShow.h
//  newHfax
//
//  Created by lly on 2017/7/2.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BFTask;
@class HXBaseNavigationBar;

@interface UIViewController (HXShow)<UITextFieldDelegate>

@property (nonatomic,assign) BOOL isShowingDefaultView;

#pragma mark - loading
- (void)showLoadingView;
- (void)showLoadingView:(NSString *)loadingMsg;

- (void)hideLoadingView;

#pragma mark - toast
- (void)showToast:(NSString *)info;
- (void)showToastOnWindow:(NSString *)info;
- (void)showToast:(NSString *)info duration:(float)inDuration;
- (void)showToastOnWindow:(NSString *)info duration:(float)inDuration;

//#pragma mark - default no data
//- (void)showNoDataView;
//- (void)hideNoDataView;
//
//#pragma mark - default no netWork
//- (void)showNoNetworkView;
//- (void)hideNoNetworkView;

- (void)setDefaultStatusbarStyle;
//reqest error must needed
//- (void)showNoNetworkOrError:(NSError *)error;
//- (void)showNoNetworkOrError:(NSError *)error showDefaultNav:(BOOL)showDefaultNav;
- (void)showNoNetworkOrError:(NSError *)error showDefaultNav:(BOOL)showDefaultNav navigationBar:(HXBaseNavigationBar *)navigationBar;

#pragma mark - default data error
- (void)showDataErrorView;
- (void)hideDataErrorView;

- (void)hideDefaultView;

- (void)setDefaultViewOffset:(CGFloat)offset;
- (void)setDefaultViewTop:(CGFloat)top;

#pragma mark - 提示框(暂用)

- (BFTask *)warningWindowType:(UIAlertControllerStyle)alertControllerStyle title:(NSString *)title describe:(NSString *)describe okAction:(NSString *)okAction cancelAction:(NSString *)cancelAction;
- (BFTask *)okwarningTitle:(NSString *)title describe:(NSString *)describe;

#pragma mark - 打电话
- (void)telRightItem:(NSString *)tel;
- (void)telRightItem;

#pragma mark - 跳转系统设置界面
- (void)jumpSettingsTouchID;
- (void)jumpSettingsVC:(NSURL *)url;
@end
