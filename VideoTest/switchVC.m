//
//  switchVC.m
//  VideoTest
//
//  Created by YNZMK on 2019/4/13.
//  Copyright © 2019 YNZMK. All rights reserved.
//

#import "switchVC.h"
#import "LYSelectTabBar.h"
#import "downloadVideoVC.h"
#import "localVideoListVC.h"

@interface switchVC ()

@end

@implementation switchVC

+ (instancetype)new{
    return [self newWithSelectedIndex:0];
}

+ (instancetype)newWithSelectedIndex:(NSInteger)index{
    
    downloadVideoVC *vc1 = [downloadVideoVC new];
    localVideoListVC *vc2 = [localVideoListVC new];
    switchVC *v = [[switchVC alloc]initWithViewControllers:
                         @[vc1,vc2]
                                                             tabTitles:@[@"下载区",@"播放区"] selectedIndex:index];
    return v;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBarHeight = 94+IphoneXStateHeight;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self customtabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect frame = self.tabBar.frame;
    
    //    if([UIDevice isAppleIphone4Or5]){
    //        frame.origin.x = ScaleWidth(30);
    //        frame.size.width =  ScreenWidth - ScaleWidth(30*2);
    //    }else{
    frame.origin.x = (ScreenWidth - (2 * 100 + 71 - 28))/2;
    frame.size.width =  2 * 100 + 71 - 28;
    //    }
    self.tabBar.frame = frame;
}

- (BFTask *)refresh{
    HXBaseViewController *vc = self.viewControllers[self.pagerController.curIndex];
    return [vc refresh];
}

#pragma mark - getter and setter
- (TYTabPagerBarLayout *)tabBarLayout{
    TYTabPagerBarLayout *tabBarLayout = [super tabBarLayout];
    tabBarLayout.cellEdging = 0;
    tabBarLayout.cellSpacing = 71-38;
    tabBarLayout.normalTextColor = UIColorFromRGB(0x979797);
    tabBarLayout.selectedTextColor = HXFontColor;
    tabBarLayout.selectedTextFont = SFUITextMedium(18);
    tabBarLayout.normalTextFont = HXFont(18);
    tabBarLayout.progressColor = HXThemeColor;
    tabBarLayout.progressWidth = 28;
    tabBarLayout.progressHeight = 3;
    tabBarLayout.progressVerEdging = 15;
    //    if([UIDevice isAppleIphone4Or5]){
    //        return tabBarLayout;
    //    }
    tabBarLayout.cellWidth = 100;
    return tabBarLayout;
}

- (void)customtabBar{
    if([UIDevice isAppleIphone4Or5]){
        return ;
    }
    for(int i=0;i<self.tabTitles.count;i++){
        id<TYTabPagerBarCellProtocol> cell = [self.tabBar cellForIndex:i];
        if (i==self.tabTitles.count-1){
            cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        }else{
            cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
}

@end

