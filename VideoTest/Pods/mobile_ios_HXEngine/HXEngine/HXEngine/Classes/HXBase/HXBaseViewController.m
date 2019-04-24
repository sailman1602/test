//
//  HXBaseViewController.m
//  newHfax
//
//  Created by lly on 2017/6/29.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXBaseViewController.h"
#import "UIViewController+HXNavigationBar.h"
#if COCOAPODS_USE_FRAMEWORK
#import <RTRootNavigationController_lly/RTRootNavigationController.h>
#elif COCOAPODS
#import "RTRootNavigationController.h"
#else
#import <RTRootNavigationController/RTRootNavigationController.h>
#endif
#import "HXBaseWebViewController.h"
#import <Bolts/BFTask.h>
#import "UIView+HXShow.h"
#import "HXBaseNavigationBar.h"
#import "HXUIDefines.h"
#import "UILabel+Factory.h"
#import "UIView+BFExtension.h"
#import "UIKitMacros.h"

@interface HXBaseViewController (){
    BOOL _disablePushOrPresent;
}

@property (nonatomic,strong) HXBaseNavigationBar *defaultNavigationBar;
@property (nonatomic,strong,readwrite) UILabel *largeTitleLabel;

@end

@implementation HXBaseViewController

- (instancetype)init{
    if(self = [super init]){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstAppear = YES;
    if(self.hideNavDivider){
        [self hideNavDividerLine];
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setNavigationBar];
    [self addClientUserLoginSuccessRefresh];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    _disablePushOrPresent = NO;
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = _needHideNavigationBar;
     [self setDefaultStatusbarStyle];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.isVisible = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.isVisible = NO;
    _disablePushOrPresent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isFirstAppear = NO;
}

#pragma mark - getter and setter
- (HXBaseNavigationBar *)defaultNavigationBar{
    if(!_defaultNavigationBar){
        _defaultNavigationBar = [HXBaseNavigationBar defaultNavigationBarWithHeight:64+IphoneXStateHeight viewController:self hideBottomLine:NO];
        _defaultNavigationBar.showBackBtn = YES;
        [self.view addSubview:_defaultNavigationBar];
    }
    return _defaultNavigationBar;
}

- (UILabel *)largeTitleLabel{
    if(!_largeTitleLabel){
        _largeTitleLabel = [UILabel newWithFont:HXBoldFont(24) textColor:UIColorFromRGB(0x3d3d3d)];
        _largeTitleLabel.frame = CGRectMake(15, 0, ScreenWidth-30, 29);
//        [self.view addSubview:_largeTitleLabel];
    }
    return _largeTitleLabel;
}

- (void)setTitle:(NSString *)title{
    if(_largeTitleLabel){
        _largeTitleLabel.text = title;
    }else{
        [super setTitle:title];
    }
}

#pragma mark - largeTitle
- (void)addLargeTitle{
    [self.view addSubview:self.largeTitleLabel];
    [self setHideNavDividerLine:YES];
    self.needLargeTitleMargin = YES;
}

- (void)addLargeTitleOnScrollView:(UIScrollView *)scrollView{
    [scrollView addSubview:self.largeTitleLabel];
    [self setHideNavDividerLine:YES];
}

- (void)refreshTitleWithScrollViewOffset:(CGFloat)offset{
    if(offset>=_largeTitleLabel.height&&!super.title.length){//小标题
        super.title = _largeTitleLabel.text;
        _largeTitleLabel.text = nil;
        [self setHideNavDividerLine:NO];
    }else if(offset<_largeTitleLabel.height&&!_largeTitleLabel.text.length){//大标题
        _largeTitleLabel.text = super.title;
        super.title = nil;
        [self setHideNavDividerLine:YES];
    }
}

#pragma mark -
- (void)showNoNetworkOrError:(NSError *)error{
    [self showNoNetworkOrError:error showDefaultNav:NO];
}
- (void)showNoNetworkOrError:(NSError *)error showDefaultNav:(BOOL)showDefaultNav{
    [self showNoNetworkOrError:error showDefaultNav:showDefaultNav navigationBar:showDefaultNav?self.defaultNavigationBar:nil];
}

#pragma mark - refresh muset be overWrite
- (BFTask *)refresh{
    return nil;
}

#pragma mark -
- (void)addClientUserLoginSuccessRefresh{
}

- (void)addClientUserLoginoutSuccessRefresh{
}

#pragma mark - push/pop
- (void)navPushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if(self.rt_navigationController.rt_topViewController!=self) return;
    if(_disablePushOrPresent||!viewController)return;
    
    [self.rt_navigationController pushViewController:viewController animated:animated];
    _disablePushOrPresent = YES;
}
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
//    if([HXRouter visibleViewController]!=self) return;
     if(!viewControllerToPresent) return;
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

#pragma mark - navigationBar
- (void)setNavigationBar{
    if(!self.needHideNavigationBar&&!self.needHideNavigationBackBtn){
        [self setNavigationBarBackItem:NO backSel:@selector(backToLastController:)];
    }else{
        [self setNavigationBarBackItem:YES backSel:@selector(backToLastController:)];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:HXFont(17.0f),NSForegroundColorAttributeName:[UIColor blackColor]}];

}

- (void)backToLastController:(UIButton *)sender{
    
    [self.enteyWebViewController onLastPageClosed:self.enteyWebViewController.h5ParamsData];
    if(self.rt_navigationController.rt_topViewController == self&&self.rt_navigationController.rt_viewControllers.count>1){
        [self.rt_navigationController popViewControllerAnimated:YES];
    }else{
        [self.rt_navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - delloc
- (void)dealloc{
    HXLog(@"dealloc:%@",NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark protocol
- (void)onLastPageClosed:(NSDictionary *)data{
    HXLog(@"onLastPageClosed:%@",data);
    NSString *flag = data[@"data"][@"flag"];
    //    "flag": "0"(成功)，"1"(失败)，"2"(处理中)，"3"(待处理)
    //除了失败，都跳回上上页
    if (flag && flag.integerValue != 1) {
        if (self.rt_navigationController.rt_viewControllers.count>=3) {
            safe_block(self.successActionBlock);
            [self.rt_navigationController popToViewController:self.rt_navigationController.rt_viewControllers[self.rt_navigationController.rt_viewControllers.count-3] animated:NO complete:^(BOOL finished) {
            }];
        }
    }else{
        safe_block(self.failActionBlock);
    }
}
@end
