//
//  HXBaseWebViewController.h
//  newHfax
//
//  Created by lly on 2017/6/29.
//  Copyright © 2017年 hfax. All rights reserved.
//

#if COCOAPODS_USE_FRAMEWORK
#import <AXWebViewController_lly/AXWebViewController.h>
#elif COCOAPODS
#import "AXWebViewController.h"
#else
#import <AXWebViewController/AXWebViewController.h>
#endif
#import "HXBaseNavigationBar.h"
#import "HXWebJSProtocol.h"
#import "NSMutableURLRequest+PostRequest.h"
@class HXBaseViewController;
@class WKWebViewJavascriptBridge;
@class BFTask;
@class WKWebView;
@class WKNavigation;

@interface HXBaseWebViewController : AXWebViewController <HXBaseNavigationDelegate,HXWebJSProtocol>

@property (nonatomic,assign) BOOL needHideNavigationBar;
@property (nonatomic,assign) BOOL hideNavDivider;
@property (nonatomic,strong) NSString *defaultTitle;
@property (nonatomic,strong) NSString *filterTitle;
@property (nonatomic,copy) NSDictionary *userInfo;

@property (nonatomic,weak) UIViewController<HXWebJSProtocol> *enteyWebViewController;

@property (nonatomic, strong, readonly) WKWebViewJavascriptBridge *bridge;

// 原生页面数据回传h5
@property (nonatomic,strong) NSDictionary *h5ParamsData;

- (instancetype)initWithURLString:(NSString *)URLString;
- (instancetype)initWithURLString:(NSString *)URL paramArray:(NSArray<NSString *> *)paramArray;

- (instancetype)initWithURLRequest:(NSURLRequest *)request;
- (instancetype)initWithURLPost:(NSString *)URLString  bodys:(NSDictionary *)bodys;
- (instancetype)initWithURLPost:(NSString *)URLString headers:(NSDictionary *)heders bodys:(NSDictionary *)bodys;

- (instancetype)initWithLoadLocalHTMLString:(NSString *)htmlString;

- (BFTask *)refresh;
- (NSString *)networkStatus;

- (NSString *)WebViewUserAgentString;
- (void)setCustomUserAgent:(NSString *)customUserAgent;

- (void)showNoNetworkOrError:(NSError *)error;
- (void)showNoNetworkOrError:(NSError *)error showDefaultNav:(BOOL)showDefaultNav;

- (void)navPushViewController:(UIViewController *)viewController animated:(BOOL)animated;//new

#pragma mark - loading
- (void)showLoading;
- (void)hideLoading;

#pragma mark - can be overwrite to be custom
- (WKWebViewConfiguration *)wkWebViewConfiguration;
- (void)registerCustomHander;
- (void)openPage_custom:(HXBaseViewController *)v router:(NSString *)router data:(NSDictionary *)data;
- (void)presentLoginVC:(HXBaseViewController *)loginVC tag:(NSInteger)tag backTohome:(BOOL)backToHome;
- (NSString *)formatUrlString:(NSString *)urlString ;
- (void)backButtonClick:(UIButton *)sender;
- (void)backCustomAction;
- (void)closePageHandleWithPara:(NSDictionary *)dic;
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
- (id)objectForWebURL:(NSString *)url withUserInfo:(NSDictionary *)userInfo;
@end
