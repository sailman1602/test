//
//  HXTabPageController.m
//  newHfax
//
//  Created by lly on 2017/8/6.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXTabPageController.h"
#import "HXUIDefines.h"
#import "UIKitMacros.h"

@interface HXTabPageController ()<TYTabPagerControllerDataSource,TYTabPagerControllerDelegate>{
    BOOL _isShow;
}

@property (nonatomic,strong,readwrite) NSArray <NSString *> *tabTitles;
@end

@implementation HXTabPageController

- (instancetype)initWithViewControllers:(NSArray <HXBaseViewController *> *)vcs tabTitles:(NSArray<NSString *> *)tabTitles selectedIndex:(NSInteger)index{
    if(self = [super init]){
        _viewControllers = vcs;
        _tabTitles = tabTitles;
        self.tabBarHeight = 64+IphoneXStateHeight;
        _showIndex = MIN(index, vcs.count-1);
    }
    return self;
}
- (instancetype)initWithViewControllers:(NSArray <HXBaseViewController *> *)vcs tabTitles:(NSArray<NSString *> *)tabTitles{
    return [self initWithViewControllers:vcs tabTitles:tabTitles selectedIndex:0];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.layout = [self tabBarLayout];
    self.dataSource = self;
    self.delegate = self;
    self.tabBar.backgroundColor = HXThemeColor;
    self.tabBar.collectionView.scrollEnabled = NO;
    self.tabBar.contentInset = UIEdgeInsetsMake(20+IphoneXStateHeight, 0, 0, 0);
    self.pagerController.layout.prefetchItemCount = 0;
    [self reloadData];
    [self setSelectedIndex:_showIndex];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if(_showIndex !=self.tabBar.curIndex){
        [self setSelectedIndex:_showIndex];
    }
}

- (TYTabPagerBarLayout *)tabBarLayout{
    TYTabPagerBarLayout *tabBarLayout = [[TYTabPagerBarLayout alloc]initWithPagerTabBar:self.tabBar];
    tabBarLayout.barStyle = TYPagerBarStyleProgressView;
    tabBarLayout.progressColor = [UIColor whiteColor];
    tabBarLayout.normalTextFont = HXBoldFont(14);
    tabBarLayout.selectedTextFont = HXBoldFont(14);
    tabBarLayout.normalTextColor = UIColorFromRGB(0xFDD6D4);
    tabBarLayout.selectedTextColor = [UIColor whiteColor];
    tabBarLayout.cellWidth = ScreenWidth/self.tabTitles.count;
    tabBarLayout.cellEdging = 0;
    tabBarLayout.progressVerEdging = 3;
    tabBarLayout.animateDuration = 0.2;
    return tabBarLayout;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if(_isShow){
        [self.viewControllers[_showIndex] viewWillAppear:animated];
    }
    _isShow = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.viewControllers[_showIndex] viewWillDisappear:animated];
}


#pragma mark - getter and setter
- (void)setSelectedIndex:(NSInteger)showIndex{
    NSInteger realShowIndex = MIN(showIndex, self.viewControllers.count-1);
    [self.tabBar scrollToItemFromIndex:_showIndex toIndex:realShowIndex animate:YES];
    [self.pagerController scrollToControllerAtIndex:showIndex animate:YES];
    _showIndex = realShowIndex;
    HXLog(@"setSelectedIndex:%ld",showIndex);
}

#pragma mark - TYTabPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController {
    return self.viewControllers.count;
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching{
    return self.viewControllers[index];
}

- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController titleForIndex:(NSInteger)index {
    return self.tabTitles[index];
}

- (void)tabPagerControllerDidEndScrolling:(TYTabPagerController *)tabPagerController animate:(BOOL)animate{
    _showIndex = tabPagerController.pagerController.curIndex;
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    _showIndex = index;
    [self setSelectedIndex:index];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
