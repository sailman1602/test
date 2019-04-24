//
//  HXTabPageController.h
//  newHfax
//
//  Created by lly on 2017/8/6.
//  Copyright © 2017年 hfax. All rights reserved.
//

#if COCOAPODS_USE_FRAMEWORK
#import <TYPagerController_lly/TYTabPagerController.h>
#elif COCOAPODS
#import "TYTabPagerController.h"
#else
#import <TYPagerController/TYTabPagerController.h>
#endif

#import "HXBaseViewController.h"

@interface HXTabPageController : TYTabPagerController

@property (nonatomic,weak) HXBaseWebViewController *enteyWebViewController;
@property (nonatomic,strong) NSDictionary *h5ParamsData;
@property (nonatomic,assign) BOOL needHideNavigationBar;
@property (nonatomic,assign) BOOL needHideNavigationBackBtn;

@property (nonatomic,strong,readonly) NSArray<HXBaseViewController *> *viewControllers;
@property (nonatomic,strong,readonly) NSArray <NSString *> *tabTitles;
- (instancetype)initWithViewControllers:(NSArray <HXBaseViewController *> *)vcs tabTitles:(NSArray<NSString *> *)tabTitles selectedIndex:(NSInteger)index;
- (instancetype)initWithViewControllers:(NSArray <HXBaseViewController *> *)vcs tabTitles:(NSArray<NSString *> *)tabTitles;
- (TYTabPagerBarLayout *)tabBarLayout;
@property (nonatomic,assign,setter=setSelectedIndex:) NSInteger showIndex;

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index;

@end
