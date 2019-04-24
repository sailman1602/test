//
//  HXBaseWebViewController.m
//  newHfax
//
//  Created by lly on 2017/6/29.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXBaseWebViewController.h"
#import "HXBaseViewController.h"
#import "UIViewController+HXNavigationBar.h"
#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>
#if COCOAPODS_USE_FRAMEWORK
#import <RTRootNavigationController_lly/RTRootNavigationController.h>
#import <RTRootNavigationController_lly/UIViewController+RTRootNavigationController.h>
#elif COCOAPODS
#import "RTRootNavigationController.h"
#import "UIViewController+RTRootNavigationController.h"
#else
#import <RTRootNavigationController/RTRootNavigationController.h>
#import <RTRootNavigationController/UIViewController+RTRootNavigationController.h>
#endif
#import <SDWebImage/UIButton+WebCache.h>
#import "UIButton+Block.h"
#import "NSString+Extension.h"
#import <Bolts/BFTask.h>
#import <Bolts/BFTaskCompletionSource.h>
#import "HXCookie.h"
#import "HXUIDefines.h"
#import "UIKitMacros.h"

//#import "HXAlertCustomView.h"
#import "HXCheckNumber.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "HXBaseNavigationBar.h"
#import "NSString+UrlEncode.h"
#import <YYModel/YYModel.h>
#import "HXTaskManager.h"
#import "HXSecurityPolicy.h"

@interface HXBackItemCustomView : UIView
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIButton *closeBtn;
@end

@class HXLoginViewController;
static NSString *defaultUserAgent;
@interface HXBaseWebViewController (){
    UIStatusBarStyle _previousStatusBarStyle;//当前statusBar样式
}

@property (nonatomic,strong) UIBarButtonItem *navRightBarImgItem;
@property (nonatomic,strong) UIBarButtonItem *navRightBarTitleItem;

@property (nonatomic,strong) UIView *statusBarView;
@property (nonatomic,strong) UIColor *statusbarColor;

@property (nonatomic,strong) CAGradientLayer *bgLayer;
@property (nonatomic,strong) CAGradientLayer *statusbarLayer;

@property (nonatomic, strong, readwrite) WKWebViewJavascriptBridge *bridge;

@property (nonatomic,strong) NSMutableDictionary<NSString *,NSNumber *> *urlSupportBackList;
@property (nonatomic,copy) NSString *loadingUrl;

@property (nonatomic,strong) HXBaseNavigationBar *defaultNavigationBar;

@property (nonatomic,strong) WKNavigation *backNavigation;
@property (nonatomic,assign) BOOL showClose;
@property (nonatomic,assign) BOOL thirdPart;
@property (nonatomic,strong) HXBackItemCustomView *letfNavigationCustomView;

@end

@implementation HXBaseWebViewController

- (instancetype)initWithURLString:(NSString *)URLString{
    NSURL *url = URL([[self formatUrlString:URLString] urlSafeEncode]);
    if(!url) url = [[NSURL alloc]init];
    if(self = [super initWithURL:url configuration:[self wkWebViewConfiguration]]){
        [self initDefault];
    }
    return self;
}

- (instancetype)initWithURLString:(NSString *)URL paramArray:(NSArray<NSString *> *)paramArray{
    NSString *urlStr= [self fullURLWthURL:URL paramArray:paramArray];
    NSURL *url = URL([[self formatUrlString:urlStr] urlSafeEncode]);
    if(!url) url = [[NSURL alloc]init];
    if(self = [super initWithURL:url configuration:[self wkWebViewConfiguration]]){
        [self initDefault];
    }
    return self;
}

- (instancetype)initWithURLRequest:(NSURLRequest *)request{
    if(self = [super initWithRequest:request configuration:[self wkWebViewConfiguration]]){
        [self initDefault];
    }
    return self;
}

- (instancetype)initWithURLPost:(NSString *)URLString  bodys:(NSDictionary *)bodys{
    if(self = [self initWithURLPost:URLString headers:nil bodys:bodys]){
        
    }
    return self;
}
- (instancetype)initWithURLPost:(NSString *)URLString headers:(NSDictionary *)heders bodys:(NSDictionary *)bodys{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithPostUrl:[self formatUrlString:URLString] Headers:heders params:bodys];
    if(self = [self initWithURLRequest:request]){
        
    }
    return self;
}

- (instancetype)initWithLoadLocalHTMLString:(NSString *)htmlString{
    if(self = [super init]){
        [self setValue:[NSURL URLWithString:@""] forKey:@"baseURL"];
        [self setValue:htmlString forKey:@"HTMLString"];
        
    }
    return self;
}
- (void)initDefault{
    self.hidesBottomBarWhenPushed = YES;
    self.showsBackgroundLabel = NO;
    self.loadingUrl = @"";
    
    self.securityPolicy = [HXSecurityPolicy policyWithPinningMode:AXSSLPinningModeNone];
    self.securityPolicy.validatesDomainName = NO;
#if !PRO
    self.securityPolicy.allowInvalidCertificates = YES;
#else
    self.securityPolicy.allowInvalidCertificates = NO;
#endif
    self.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    self.timeoutInternal = 30;
    
    NSString *newUserAgent = [self WebViewUserAgentString];
    [self setCustomUserAgent:newUserAgent];
    HXLog(@"进入H5页，URL:%@,UserAgent:%@",self.URL,newUserAgent);
}

- (NSString *)fullURLWthURL:(NSString *)URL paramArray:(NSArray<NSString *> *)paramArray{
    NSMutableString *fullUrl = [NSMutableString stringWithString:URL];
    for(NSString *param in paramArray){
        [fullUrl appendString:[NSString stringWithFormat:@"/%@",param]];
    }
    return fullUrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *showNav = HXDicGetSafeString(self.userInfo, @"showNav");
    if([showNav isEqualToString:@"false"]){
        self.needHideNavigationBar = YES;
    }
    NSString *showClose = HXDicGetSafeString(self.userInfo, @"showClose");
    if([showClose isEqualToString:@"true"]){
        self.showClose = YES;
    }
    NSString *type = HXDicGetSafeString(self.userInfo, @"type");
    if([type isEqualToString:@"thirdPart"]){
        self.thirdPart = YES;
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:HXFont(17.0f),NSForegroundColorAttributeName:[UIColor blackColor]}];
    _previousStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    if(self.hideNavDivider){
        [self hideNavDividerLine];
    }
    [self customStatusBar];
    // Do any additional setup after loading the view.
    self.showsToolBar = NO;
    self.navigationType = AXWebViewControllerNavigationBarItem;
    self.enabledWebViewUIDelegate = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.webView.allowsBackForwardNavigationGestures = NO;
    self.rt_disableInteractivePop = YES;
    self.webView.gestureRecognizers = nil;
    self.webView.scrollView.maximumZoomScale = 1;
    self.maxAllowedTitleLength = 15;
    
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    [_bridge disableJavscriptAlertBoxSafetyTimeout];
#if !PRO
    [WKWebViewJavascriptBridge enableLogging];
#endif
    [self registerHander];
}

- (void)customStatusBar{
    _statusBarView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    _statusbarLayer = [CAGradientLayer layer];
    _statusbarLayer.frame = _statusBarView.bounds;
    _statusbarLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [_statusBarView.layer insertSublayer:_statusbarLayer atIndex:0];
    _statusBarView.hidden = YES;
    [self.view addSubview:_statusBarView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    self.navigationController.navigationBarHidden = _needHideNavigationBar;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //恢复原来的导航栏时间条
    [UIApplication sharedApplication].statusBarStyle = _previousStatusBarStyle;
}

- (void)backToLastController:(UIButton *)sender{
    [self.rt_navigationController popViewControllerAnimated:YES];
}

#pragma mark -
- (void)updateNavigationItems
{
    if (!self.needHideNavigationBar ) {
        [self customNavigationLeftItems];
    }
}

- (void)customNavigationLeftItems{
    if(self.showClose){
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.letfNavigationCustomView];
        self.navigationItem.leftBarButtonItem = leftItem;
    }else{
        [self setNavigationBarBackItem:NO backSel:@selector(backButtonClick:)];
    }
}

#pragma mark - getter and setter
- (HXBackItemCustomView *)letfNavigationCustomView{
    if(!_letfNavigationCustomView){
        _letfNavigationCustomView = [[HXBackItemCustomView alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        [_letfNavigationCustomView.backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_letfNavigationCustomView.closeBtn addTarget:self action:@selector(closeCurrentPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _letfNavigationCustomView;
}

- (NSString *)WebViewUserAgentString{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        defaultUserAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    });
    NSString *publicParamString = [[self publicParams] yy_modelToJSONString];
    NSString *newUserAgent = [[defaultUserAgent stringByAppendingString:@"###hfax-app###"] stringByAppendingString:publicParamString];
    return newUserAgent;
}

- (void)setCustomUserAgent:(NSString *)customUserAgent{
    if([self.webView respondsToSelector:@selector(setCustomUserAgent:)]){
        self.webView.customUserAgent = customUserAgent;
    }else{
        // 设置global User-Agent
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:customUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            HXLog(@"IOS 8 customUserAgent%@", result);
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:customUserAgent, @"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        }];
    }
}

- (WKWebViewConfiguration *)wkWebViewConfiguration{
    WKUserContentController* userContentController = [WKUserContentController new];
    NSArray *cookies = [HXCookie cookies];
    NSMutableString *cookiesScript = [NSMutableString string];
    for(NSHTTPCookie *cookie in cookies){
        [cookiesScript appendString:[NSString stringWithFormat:@"document.cookie='%@=%@;path=/';",cookie.name,cookie.value]];
    }
    HXLog(@"inserted cookie into webView: %@", cookiesScript);
    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:cookiesScript injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    if([UIDevice currentDevice].systemVersion.doubleValue<9.0){
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[self WebViewUserAgentString], @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        
        WKUserScript * userAgentScript = [[WKUserScript alloc] initWithSource:@"navigator.userAgent" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentController addUserScript:userAgentScript];
        
    }
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new]; // 一下两个属性是允许H5视屏自动播放,并且全屏,可忽略
    configuration.allowsInlineMediaPlayback = YES;
    configuration.mediaPlaybackRequiresUserAction = NO; // 全局使用同一个processPool
    configuration.processPool = [[WKProcessPool alloc]init];
    configuration.userContentController = userContentController;
    return configuration;
}

- (UIBarButtonItem *)navRightBarTitleItem{
    if(!_navRightBarTitleItem){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 100, NavBarItem_Height);
        btn.titleLabel.font = HXFont(13.0);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _navRightBarTitleItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        if([self.URL.absoluteString hasSuffix:@"/h5/myaward.html#/person"]){
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    return _navRightBarTitleItem;
}

- (UIBarButtonItem *)navRightBarImgItem{
    if(!_navRightBarImgItem){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, NavBarItem_Width, NavBarItem_Width);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _navRightBarImgItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return _navRightBarImgItem;
}



- (UIColor *)statusbarColor{
    if(!_statusbarColor){
        _statusbarColor = [UIColor whiteColor];
    }
    return _statusbarColor;
}

- (CAGradientLayer *)bgLayer{
    if(!_bgLayer){
        _bgLayer = [CAGradientLayer layer];
        _bgLayer.frame = [UIScreen mainScreen].bounds;
        //        self.gradientLayer.locations = @[@(0.5f), @(1.0f)];
    }
    return _bgLayer;
}

- (NSMutableDictionary<NSString *,NSNumber *> *)urlSupportBackList{
    if(!_urlSupportBackList){
        _urlSupportBackList = [NSMutableDictionary dictionary];
    }
    return _urlSupportBackList;
}

- (BOOL)isSupportBack{
    return [[self.urlSupportBackList objectForKey:self.loadingUrl] boolValue];
}

#pragma mark - action
- (void)backButtonClick:(UIButton *)sender{
    [self backCustomAction];
    if(self.isSupportBack&&!self.needHideNavigationBar){
        WEAKSELF;
        [self.bridge callHandler:@"onNavBack" data:nil responseCallback:^(id responseData) {
            BOOL isHandled = HXDicGetSafeInteger(responseData, @"isHandled");
            if(!isHandled){
                [weakSelf goBackOrPopViewController];
            }
        }];
    }else{
        [self goBackOrPopViewController];
    }
    
}
- (void)backCustomAction{}
- (void)closePageHandleWithPara:(NSDictionary *)dic{
    NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithDictionary:self.enteyWebViewController.h5ParamsData];
    NSMutableDictionary *d2 = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([d2 objectForKey:@"tag"]) {
        [d2 removeObjectForKey:@"tag"];
    }
    [d1 addEntriesFromDictionary:d2];
    self.enteyWebViewController.h5ParamsData = d1;
    [self.enteyWebViewController onLastPageClosed:d1];
}

- (void)closeCurrentPage{
    if(self.rt_navigationController.rt_topViewController == self&&self.rt_navigationController.rt_viewControllers.count>1){
        [self.rt_navigationController popViewControllerAnimated:YES];
    }else{
        [self.rt_navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)goBackOrPopViewController{
    if([self.webView canGoBack]){
        self.backNavigation = [self.webView goBack];
        HXLog(@"webView title:%@",self.webView.title);
    }else{
        [self.enteyWebViewController onLastPageClosed: self.enteyWebViewController.h5ParamsData];
        if(self.rt_navigationController.rt_topViewController == self&&self.rt_navigationController.rt_viewControllers.count>1){
            [self.rt_navigationController popViewControllerAnimated:YES];
        }else{
            [self.rt_navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - WKWebView delegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:NULL];
        if (completionHandler != NULL) {
            completionHandler();
        }
    }];
    
    // Add actions.
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [self showLoading];
    [super webView:webView didStartProvisionalNavigation:navigation];
    self.loadingUrl = [webView.URL absoluteString];
    HXLog(@"didStart load URL:%@,title:%@",self.loadingUrl,self.webView.title);
    if(![self.urlSupportBackList objectForKey:self.loadingUrl])
        [self.urlSupportBackList setObject:@(0) forKey:self.loadingUrl];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [super webView:webView didFinishNavigation:navigation];
    HXLog(@"didFinishNavigation URL:%@,title:%@",self.loadingUrl,self.webView.title);
    if(self.webView.title.length && ![self.webView.title isEqualToString:self.filterTitle]){
        self.navigationItem.title = self.webView.title;
    }else if([self.title isEqualToString:self.defaultTitle]||[self.title isEqualToString:@"加载中..."]){
        self.navigationItem.title = @"";
    }
    if(self.backNavigation == navigation){
        [self.webView reload];
        self.backNavigation = nil;
    }
    if(self.showClose){
        self.letfNavigationCustomView.closeBtn.hidden = self.thirdPart ? (!self.thirdPart) : (!webView.canGoBack);
    }
    [self hideLoading];
}

- (void)_updateTitleOfWebVC {}

- (void)didStartLoad{
    NSString *title = self.navigationItem.title;
    [super didStartLoad];
    if(title.length&&self.navigationItem.title != title){
        self.navigationItem.title = title;
    }else if(self.defaultTitle.length){
        self.navigationItem.title = self.defaultTitle;
    }
}

#pragma mark - refresh
- (BFTask *)refresh{
    BFTaskCompletionSource *source = [BFTaskCompletionSource taskCompletionSource];
    [self showNoNetworkOrError:nil showDefaultNav:self.needHideNavigationBar];
    [self loadURL:[NSURL URLWithString:self.loadingUrl]];
    return source.task;
}

#pragma mark register hander
- (void)registerHander{
    
    [self registerHander_openPage];
    [self registerHander_closeCurrentPage];
    
#pragma mark - alert toast
    [self registerHander_showToast];
    [self registerHander_showAlert];
    [self registerHander_showLoading];
    
#pragma mark - navigation 按钮统一只能加在右边
    [self registerHander_showNavImgBtn];
    [self registerHander_showNavTxtBtn];
    [self registerHander_navBarCtl];
    [self registerHander_setBgGradientColor];
    [self registerHander_setSupportBack];
    
#pragma mark h5 func  protocol
    [self registerHander_dial];
    
    [self registerHander_postDataWithWebview];
    
    [self registerCustomHander];
    
}
- (void)registerCustomHander{
    //must be overWirte
    NSAssert(false, @"must be overWirte");
}
- (void)registerHander_openPage{
    WEAKSELF
    [self.bridge registerHandler:@"openPage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *router = HXDicGetSafeString(data, @"router");
        NSString *title = HXDicGetSafeString(data,@"title");
        HXBaseViewController *v = [weakSelf objectForWebURL:router withUserInfo:[data objectForKey:@"data"]];
        if(!v||![v isKindOfClass:[UIViewController class]]) return;
        if(title.length)
            v.title = title;
        if([v respondsToSelector:@selector(setNeedHideNavigationBar:)]){
            BOOL hideNav = HXDicGetSafeInteger(data, @"hideNav");
            v.needHideNavigationBar = hideNav;
        }
        if([v respondsToSelector:@selector(setEnteyWebViewController:)]){
            v.enteyWebViewController = weakSelf;
        }
        //        if([v respondsToSelector:@selector(setH5ParamsData:)]){
        //            NSInteger tag = HXDicGetSafeInteger(data, @"tag");
        //            v.h5ParamsData = @{@"tag":@(tag)};
        //        }
        NSInteger tag = HXDicGetSafeInteger(data, @"tag");
        weakSelf.h5ParamsData = @{@"tag":@(tag)};
        
        [weakSelf openPage_custom:v router:router data:data];
        if([v respondsToSelector:@selector(setHideNavDivider:)]){
            NSInteger hideNavDivider = HXDicGetSafeInteger(data, @"hideNavDivider");
            v.hideNavDivider = hideNavDivider;
        }
        if(responseCallback)
            responseCallback(nil);
    }];
}

- (id)objectForWebURL:(NSString *)url withUserInfo:(NSDictionary *)userInfo{
    NSAssert(false, @"must be overWrite!");
    return nil;
}
- (void)openPage_custom:(HXBaseViewController *)v router:(NSString *)router data:(NSDictionary *)data{
    
}

- (void)registerHander_closeCurrentPage{
    WEAKSELF
    [self.bridge registerHandler:@"closeCurrentPage" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf closePageHandleWithPara:data];
        [weakSelf closeCurrentPage];
        if(responseCallback)
            responseCallback(nil);
    }];
}

- (void)registerHander_showToast{
    WEAKSELF
    [self.bridge registerHandler:@"showToast" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *msg = HXDicGetSafeString(data,@"msg");
        CGFloat duration = HXDicGetSafeFloat(data, @"duration");
        [weakSelf showToastOnWindow:msg duration:duration];
        if(responseCallback)
            responseCallback(nil);
    }];
}
- (void)registerHander_showAlert{
    WEAKSELF
    [self.bridge registerHandler:@"showAlert" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *title = HXDicGetSafeString(data,@"title");
        NSString *msg = HXDicGetSafeString(data,@"msg");
        NSString *ok = HXDicGetSafeString(data,@"ok");
        NSString *cancel = HXDicGetSafeString(data,@"cancel");
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:ok.length?ok:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(responseCallback)
                responseCallback(@(1));
        }]];
        if(cancel.length){
            [alertController addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if(responseCallback)
                    responseCallback(@(0));
                
            }]];
        }
        
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }];
}
- (void)registerHander_showLoading{
    WEAKSELF
    [self.bridge registerHandler:@"showLoading" handler:^(id data, WVJBResponseCallback responseCallback) {
        BOOL show = HXDicGetSafeInteger(data, @"show");
        NSString *text = HXDicGetSafeString(data,@"text");
        if(show||![data objectForKey:@"show"]){
            [weakSelf showLoadingView:text];
        }else{
            [weakSelf hideLoadingView];
        }
        if(responseCallback)
            responseCallback(nil);
    }];
}
- (void)registerHander_showNavImgBtn{
    WEAKSELF
    [self.bridge registerHandler:@"showNavImgBtn" handler:^(id data, WVJBResponseCallback responseCallback) {
        BOOL show = HXDicGetSafeInteger(data, @"show");
        NSMutableArray *array =  [NSMutableArray arrayWithArray:weakSelf.navigationItem.rightBarButtonItems];
        if(show||![data objectForKey:@"show"]){
            NSString *imageUrl = HXDicGetSafeString(data,@"imgUrl");
            NSString *action = HXDicGetSafeString(data,@"action");
            if(![array containsObject:weakSelf.navRightBarImgItem]){
                UIButton *button = weakSelf.navRightBarImgItem.customView;
                [button sd_setImageWithURL:URL(imageUrl) forState:UIControlStateNormal];
                if(!button.actionBlock){
                    [button addTouchEvent:UIControlEventTouchUpInside withBlock:^{
                        [weakSelf.bridge callHandler:action];
                    }];
                }
                [array addObject:weakSelf.navRightBarImgItem];
                weakSelf.navigationItem.rightBarButtonItems = array;
            }
            
        }else{
            [array removeObject:weakSelf.navRightBarImgItem];
            weakSelf.navigationItem.rightBarButtonItems = array;
        }
        
        
        if(responseCallback)
            responseCallback(nil);
    }];
}
- (void)registerHander_showNavTxtBtn{
    WEAKSELF
    [self.bridge registerHandler:@"showNavTxtBtn" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        BOOL show = HXDicGetSafeInteger(data, @"show");
        NSMutableArray *array =  [NSMutableArray array];
        [array addObjectsFromArray:weakSelf.navigationItem.rightBarButtonItems];
        if(show||![data objectForKey:@"show"]){
            NSString *title = HXDicGetSafeString(data,@"text");
            NSString *action = HXDicGetSafeString(data,@"action");
            if(![array containsObject:weakSelf.navRightBarTitleItem]){
                UIButton *button = weakSelf.navRightBarTitleItem.customView;
                [button setTitle:title forState:UIControlStateNormal];
                if(!button.actionBlock)
                    [button addTouchEvent:UIControlEventTouchUpInside withBlock:^{
                        [weakSelf.bridge callHandler:action];
                    }];
                [array addObject:weakSelf.navRightBarTitleItem];
                weakSelf.navigationItem.rightBarButtonItems = array;
            }
            
        }else{
            [array removeObject:weakSelf.navRightBarTitleItem];
            weakSelf.navigationItem.rightBarButtonItems = array;
        }
        
        
        if(responseCallback)
            responseCallback(nil);
    }];
}

- (void)registerHander_navBarCtl{
    WEAKSELF
    [self.bridge registerHandler:@"navBarCtl" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        BOOL needHide = !HXDicGetSafeInteger(data, @"show");
        if(![data objectForKey:@"show"]){
            needHide = NO;
        }
        NSNumber *statusbarColor = [data objectForKey:@"statusColor"];
        NSNumber *statusbarColorEnd =@(statusbarColor.integerValue);
        NSNumber *statusbarColor2 = [data objectForKey:@"statusColor2"];//HXDicGetSafeInteger(data, @"statusColor2");
        if(statusbarColor2&&[statusbarColor2 isKindOfClass:NSNumber.class]){
            statusbarColorEnd = statusbarColor2;
        }
        if(statusbarColor&&[statusbarColor isKindOfClass:NSNumber.class]){
            [weakSelf gradientConfigureWithLayer:weakSelf.statusbarLayer direction:1 hexColors:@[statusbarColor,statusbarColorEnd]];
        }
        weakSelf.statusBarView.hidden = !needHide;
        weakSelf.needHideNavigationBar = needHide;
        [weakSelf.navigationController setNavigationBarHidden:needHide animated:FALSE];
        NSString *title = HXDicGetSafeString(data,@"text");
        if(title.length){
            weakSelf.navigationItem.title = title;
        }
        NSNumber *hideLine = [data objectForKey:@"hideBtmLine"];
        if(hideLine&&[hideLine boolValue]){
            weakSelf.hideNavDivider = YES;
            [weakSelf setHideNavDividerLine:YES];
        }else if(weakSelf.hideNavDivider){
            [weakSelf setHideNavDividerLine:NO];
            weakSelf.hideNavDivider = NO;
        }
        
        if(responseCallback)
            responseCallback(nil);
    }];
}

- (void)registerHander_setBgGradientColor{
    WEAKSELF
    [self.bridge registerHandler:@"wbvBgc" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        BOOL show = HXDicGetSafeInteger(data, @"show");
        if(!show){
            [weakSelf setBgGradient:YES Colors:nil direction:0];
            return ;
        }
        NSInteger direction = HXDicGetSafeInteger(data, @"direction");
        NSInteger fromColor = HXDicGetSafeInteger(data, @"fromColor");
        NSInteger toColor = HXDicGetSafeInteger(data, @"toColor");
        [weakSelf setBgGradient:NO Colors:@[@(fromColor),@(toColor)] direction:direction];
        
        if(responseCallback)
            responseCallback(nil);
    }];
}

- (void)registerHander_setSupportBack{
    WEAKSELF
    [self.bridge registerHandler:@"setSupportBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        BOOL support = HXDicGetSafeInteger(data, @"support");
        //        weakSelf.isSupportBack = support;
        [weakSelf.urlSupportBackList setObject:@(support) forKey:weakSelf.loadingUrl];
        if(responseCallback)
            responseCallback(nil);
    }];
}

- (void)registerHander_dial{
    WEAKSELF;
    [self.bridge registerHandler:@"dial" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *tell = HXDicGetSafeString(data, @"tel");
        [weakSelf telRightItem:tell];
        if(responseCallback)
            responseCallback(nil);
    }];
}

- (void)registerHander_postDataWithWebview{
    WEAKSELF;
    [self.bridge registerHandler:@"postDataWithWebview" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *url = HXDicGetSafeString(data, @"url");
        NSDictionary *body = HXDicGetSafeDic(data, @"body");
        NSDictionary *headers = HXDicGetSafeDic(data, @"headers");
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithPostUrl:[weakSelf formatUrlString:url] Headers:headers params:body];
        SEL sel = NSSelectorFromString(@"loadURLRequest:");
        if([weakSelf respondsToSelector:sel]){
            [weakSelf performSelector:sel withObject:request afterDelay:0.0];
        }
        if(responseCallback)
            responseCallback(nil);
    }];
}


- (void)presentLoginVC:(HXLoginViewController *)loginVC tag:(NSInteger)tag backTohome:(BOOL)backToHome{
    
}


#pragma mark - func
- (NSString *)dicToJson:(NSDictionary *)dic{
    if(dic&&[dic isKindOfClass:[NSDictionary class]]){
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&parseError];
        if (parseError) {
#ifdef DEBUG
            HXLog(@"json序列化异常:\n%@",parseError);
#endif
            return @"{}";
        }
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    return @"{}";
    
}

- (void)setBgGradient:(BOOL)hidden Colors:(NSArray *)hexColors direction:(NSInteger)direction{
    [self.bgLayer removeFromSuperlayer];
    if(!hidden){
        [self.view.layer insertSublayer:self.bgLayer atIndex:0];
        [self gradientConfigureWithLayer:self.bgLayer direction:direction hexColors:hexColors];
    }
}

- (void)gradientConfigureWithLayer:(CAGradientLayer *)layer direction:(NSInteger)direction hexColors:(NSArray *)hexColors{
    switch (direction) {
        case 0://从上到下
        {
            layer.startPoint = CGPointMake(0, 0);
            layer.endPoint = CGPointMake(0,1);
        }
            break;
        case 1://从左到右
        {
            layer.startPoint = CGPointMake(0, 0);
            layer.endPoint = CGPointMake(1, 0);
        }
            break;
        case 2://左上到右下
        {
            layer.startPoint = CGPointMake(0, 0);
            layer.endPoint = CGPointMake(1, 1);
        }
            break;
        case 3://右上到左下
        {
            layer.startPoint = CGPointMake(1, 0);
            layer.endPoint = CGPointMake(0, 1);
        }
            break;
        default:
            break;
    }
    
    NSMutableArray *colors = [NSMutableArray array];
    for(NSNumber *hexColor in hexColors){
        CGColorRef colorRef = UIColorFromRGB(hexColor.integerValue).CGColor;
        [colors addObject:(__bridge id)colorRef];
    }
    layer.colors = colors;
}

//打开新页面，将数据回传到H5
#pragma mark - h5 call back
- (void)sendH5OnNativeOpen:(NSDictionary *)data{
    NSDictionary *commonData = [self publicParams];
    
    NSDictionary *realData = data?data:@{};
    NSDictionary *d = [data objectForKey:data];
    if(d&&[d isKindOfClass:[NSDictionary class]]){
        realData = d;
    }
    
    [self.bridge callHandler:@"onNativeOpen" data:@{@"passData":realData,@"common":commonData}];
}

- (void)onLastPageClosed:(NSDictionary *)data{
    [self.bridge callHandler:@"onResult" data:data];
}

//- (void)sendH5Response:(NSDictionary *)response{
//    [self.bridge callHandler:@"onResult" data:response];
//}


#pragma mark -
- (NSString *)networkStatus
{
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
        return @"WiFi";
    } else if(status == AFNetworkReachabilityStatusReachableViaWWAN) {
        return @"4G";
    }
    return @"UNKONW";
}

- (void)dealloc{
    _bridge = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    HXLog(@"H5 页面:%@ delloc",self.URL);
}

#pragma mark -
- (HXBaseNavigationBar *)defaultNavigationBar{
    if(!_defaultNavigationBar){
        _defaultNavigationBar = [HXBaseNavigationBar defaultNavigationBarWithHeight:64+IphoneXStateHeight viewController:self hideBottomLine:NO];
        _defaultNavigationBar.showBackBtn = YES;
        [self.view addSubview:_defaultNavigationBar];
    }
    return _defaultNavigationBar;
}

- (void)showNoNetworkOrError:(NSError *)error{
    [self showNoNetworkOrError:error showDefaultNav:NO];
}
- (void)showNoNetworkOrError:(NSError *)error showDefaultNav:(BOOL)showDefaultNav{
    [self showNoNetworkOrError:error showDefaultNav:showDefaultNav navigationBar:showDefaultNav?self.defaultNavigationBar:nil];
}

#pragma mark - overWrite
- (UIProgressView *)progressView {
    return nil;
}
- (void)updateFrameOfProgressView {
}

- (void)didFailLoadWithError:(NSError *)error{
    [self showNoNetworkOrError:error showDefaultNav:self.needHideNavigationBar];
    if (error.code == NSURLErrorTimedOut||error.code == NSURLErrorCannotFindHost||error.code == NSURLErrorCannotConnectToHost||error.code == NSURLErrorNotConnectedToInternet||error.code == NSURLErrorNetworkConnectionLost) {
        
    }else if([HXSecurityPolicy isProxyError]){
        [self showToast:[HXSecurityPolicy proxySecurityErrorMsg]];
    }
    //    if (error.code == NSURLErrorTimedOut||error.code == NSURLErrorCannotFindHost||error.code == NSURLErrorCannotConnectToHost||error.code == NSURLErrorNotConnectedToInternet||error.code == NSURLErrorNetworkConnectionLost) {
    //        [self showNoNetworkOrError:error showDefaultNav:self.needHideNavigationBar];
    //    }else{
    //        [super didFailLoadWithError:error];
    //    }
}

- (NSDictionary *)publicParams{
    return [HXTaskManagerInstance allPublicParams];
}

- (NSString *)formatUrlString:(NSString *)urlString{
    return urlString;
}

#pragma mark -private
- (void)reInitWebViewController{
    HXBaseWebViewController *newWebVC = [[HXBaseWebViewController alloc]initWithURLString:self.URL.absoluteString];
    NSMutableArray *vcs = [self.rt_navigationController.rt_viewControllers mutableCopy];
    [vcs replaceObjectAtIndex:vcs.count-1 withObject:newWebVC];
    self.navigationController.viewControllers = vcs;
}

#pragma mark
- (void)navPushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.rt_navigationController pushViewController:viewController animated:animated];
}

#pragma mark - loading
- (void)showLoading{
    
}
- (void)hideLoading{
    
}
@end

@implementation HXBackItemCustomView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
        _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, 0, 30, 30)];
        _closeBtn.imageEdgeInsets = UIEdgeInsetsMake(1, -19, 0, 0);
        _closeBtn.hidden = YES;
        [_backBtn setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"webClose"] forState:UIControlStateNormal];
        [self addSubview:_backBtn];
        [self addSubview:_closeBtn];
        
    }
    return self;
}
@end
