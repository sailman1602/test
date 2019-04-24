//
//  HXTableViewController.h
//  newHfax
//
//  Created by lly on 2017/7/2.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+HXShow.h"
#import "HXBaseViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "HXTableView_public.h"

@interface HXTableViewController : HXBaseViewController <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) UITableViewStyle tableViewStyle; //默认为group，如果需要修改重写init方法，赋值

@property (nonatomic,assign,readonly) HXRefreshType refreshType;

- (void)initRefreshWithType:(HXRefreshType)refreshType;
- (void)initRefreshWithType:(HXRefreshType)refreshType WithUseNewTypeHeader:(BOOL)useNewTypeHeader;

- (void)onHeaderRefresh;
- (void)onFooterLoadMore;

- (void)endHeaderFooterRefresh;
- (void)endHeaderRefresh;
- (void)endFooterRefresh;

- (void)footerNoMoreData;

@end
