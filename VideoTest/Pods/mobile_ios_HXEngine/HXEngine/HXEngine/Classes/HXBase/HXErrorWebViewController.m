//
//  HXErrorWebViewController.m
//  newHfax
//
//  Created by lly on 2017/9/4.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXErrorWebViewController.h"
#import <WebKit/WebKit.h>
#import "NSString+UrlEncode.h"
#import "NSURL+OS.h"

static BOOL isShowingErrorVC = false;

@interface HXErrorWebViewController ()

@end

@implementation HXErrorWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)updateNavigationItems{
    //over write
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isShowingErrorVC = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    isShowingErrorVC = NO;
}

+ (instancetype)instanceWithErrorUrl:(NSString *)errorUrl{
    if(isShowingErrorVC)return nil;
    errorUrl = [errorUrl urlEncode];
    NSURL *url =[NSURL URLWithString:[errorUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    NSDictionary *Info = [url dictionaryFromQuery];
    HXErrorWebViewController *vc = [[self alloc]initWithErrorUrl:errorUrl];
    vc.userInfo = Info;
    isShowingErrorVC = YES;
    return vc;
}

+ (BOOL)isError{
    return isShowingErrorVC;
}

- (instancetype)initWithErrorUrl:(NSString *)errorUrl{
    if(self = [super initWithURL:[NSURL URLWithString:errorUrl]]){
        self.hidesBottomBarWhenPushed = YES;
        self.showsBackgroundLabel = NO;
    }
    return self;
}

- (void)registerCustomHander{}

- (void)dealloc {
    isShowingErrorVC = NO;
}

//- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//    [super webView:webView didFinishNavigation:navigation];
//    if(!self.webView.title.length){
//        self.title = @"系统维护中";
//    }
//}

//- (NSString *)title{
//    return @"系统维护中";
//}

@end
