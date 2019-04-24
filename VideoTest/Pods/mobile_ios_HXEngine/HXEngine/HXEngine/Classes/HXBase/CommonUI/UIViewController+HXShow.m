//
//  UIViewController+HXShow.m
//  newHfax
//
//  Created by lly on 2017/7/2.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "UIViewController+HXShow.h"
#import "UIView+HXShow.h"
#import <Bolts/Bolts.h>
//#import "HXMineUserCase.h"
//#import "HXMineModel.h"
#import "HXCheckNumber.h"
//#import "HXUserModule.h"
#import "NSString+Extension.h"
#import "UIButton+Block.h"
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "HXBaseNavigationBar.h"
#import "HXUIDefines.h"



@implementation UIViewController (HXShow)

#pragma mark - getter and setter

- (BOOL)isShowingDefaultView{
    return [objc_getAssociatedObject(self, @selector(isShowingDefaultView)) boolValue];
}

- (void)setIsShowingDefaultView:(BOOL)isShowingDefaultView{
    objc_setAssociatedObject(self, @selector(isShowingDefaultView), @(isShowingDefaultView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setDefaultStatusbarStyle{
    if(!self.navigationController.navigationBarHidden||self.isShowingDefaultView)
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    else
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}

#pragma mark -
- (void)showNoNetworkOrError:(NSError *)error showDefaultNav:(BOOL)showDefaultNav navigationBar:(HXBaseNavigationBar *)navigationBar{
    if(!error){
        [self hideNoNetworkView];
        [self hideDataErrorView];
        if(showDefaultNav){
            if(!navigationBar.hidden){
                navigationBar.hidden = YES;
            }
            [self setDefaultStatusbarStyle];
            self.isShowingDefaultView = NO;
        }
        return;
    }
    NSString *defaultTitle = nil;
    [self setDefaultViewTop:showDefaultNav?(64+IphoneXStateHeight):0];
    if(error.code == -1009||error.code == -1001){
        defaultTitle = @"连接中断";
        [self showNoNetworkView];
    }else{
        defaultTitle = @"服务器异常";
        [self showDataErrorView];
    }
    if(showDefaultNav){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        navigationBar.hidden = NO;
        navigationBar.title = defaultTitle;
        self.isShowingDefaultView = YES;
    }
}


#pragma mark - loading
- (void)showLoadingView{
    [self.view hideLoadingView];
    [self.view showLoadingView];
}

- (void)showLoadingView:(NSString *)loadingMsg{
    [self.view hideLoadingView];
    [self.view showLoadingView:loadingMsg];
}

- (void)hideLoadingView{
    [self.view hideLoadingView];
}

#pragma mark - toast
- (void)showToast:(NSString *)info{
    [self.view showToast:info];
}

- (void)showToastOnWindow:(NSString *)info{
    [self.view showToastOnWindow:info];
}

- (void)showToast:(NSString *)info duration:(float)inDuration{
    [self.view showToast:info duration:inDuration];
}
- (void)showToastOnWindow:(NSString *)info duration:(float)inDuration{
    [self.view showToastOnWindow:info duration:inDuration];
}

#pragma mark - default no data
- (void)showNoDataView{
    [self.view showNoDataView];
}
- (void)hideNoDataView{
    [self.view hideNoDataView];
}

#pragma mark - default no netWork
- (void)showNoNetworkView{
    [self.view showNoNetworkView];
}
- (void)hideNoNetworkView{
    [self.view hideNoNetworkView];
}

#pragma mark - default data error
- (void)showDataErrorView{
    [self.view showDataErrorView];
}

- (void)hideDataErrorView{
    [self.view hideDataErrorView];
}

- (void)hideDefaultView{
    [self.view hideDefaultView];
}

- (void)setDefaultViewOffset:(CGFloat)offset{
    [self.view setDefaultViewOffset:offset];
}

- (void)setDefaultViewTop:(CGFloat)top{
    [self.view setDefaultViewTop:top];
}

- (BFTask *)warningWindowType:(UIAlertControllerStyle)alertControllerStyle title:(NSString *)title describe:(NSString *)describe okAction:(NSString *)okAction cancelAction:(NSString *)cancelAction
{
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:describe preferredStyle:alertControllerStyle];
    [alertController addAction:[UIAlertAction actionWithTitle:cancelAction style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [completionSource setResult:@NO];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:okAction style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [completionSource setResult:@YES];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    return completionSource.task;
}

- (BFTask *)okwarningTitle:(NSString *)title describe:(NSString *)describe;
{
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.tabBarController.view addSubview:blackView];
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [blackView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScaleHeight(240));
        make.left.mas_equalTo(ScaleWidth(30));
        make.right.mas_equalTo(-ScaleWidth(30));
        make.height.mas_equalTo(ScaleWidth(136));
    }];
    UILabel *titleLabel = [[UILabel alloc] init];
    if (title.length == 0) {
        title = @"";
    }
    if (describe.length == 0) {
        describe = @"";
    }
    titleLabel.text = [NSString stringWithFormat:@"%@\n%@",title,describe];
    titleLabel.font = HXBoldFont(14);
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = HXFontColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(whiteView.mas_top);
        make.left.mas_equalTo(whiteView.mas_left);
        make.right.mas_equalTo(whiteView.mas_right);
        make.height.mas_equalTo(ScaleHeight(85));
    }];
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = HXBGLineColor;
    [whiteView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(whiteView.mas_right);
        make.left.mas_equalTo(whiteView.mas_left);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(1);
    }];
    
        UIButton *ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    ensureButton.titleLabel.font = HXBoldFont(15);
    [ensureButton setTitleColor:HXThemeColor forState:UIControlStateNormal];
    [ensureButton addTouchUpInsideWithBlock:^{//确定
        if (blackView) {
            [blackView removeFromSuperview];
        }
        [completionSource setResult:@YES];
    }];
    [whiteView addSubview:ensureButton];
    [ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom);
        make.left.mas_equalTo(whiteView.mas_left);
        make.bottom.mas_equalTo(whiteView.mas_bottom);
        make.right.mas_equalTo(whiteView.mas_right);
    }];
    
    return completionSource.task;
}

- (void)telRightItem:(NSString *)tel
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",tel];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
- (void)telRightItem
{
    [self telRightItem:@"400-015-8800"];
}
- (void)jumpSettingsTouchID
{
//    [self jumpSettingsVC:[NSURL URLWithString:@"App-Prefs:root=TOUCHID_PASSCODE"]];
    [self jumpSettingsVC:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
- (void)jumpSettingsVC:(NSURL *)url
{
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}
@end
