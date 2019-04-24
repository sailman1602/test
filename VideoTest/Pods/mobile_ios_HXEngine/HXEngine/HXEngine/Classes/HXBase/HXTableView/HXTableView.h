//
//  HXtableView.h
//  newHfax
//
//  Created by lly on 2017/8/22.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXTableViewModel;

@protocol HXTableViewDelegate <NSObject>

@optional;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

@end

@class HXTableViewDataSource;

@interface HXTableView : UITableView

@property (nonatomic,assign) BOOL couldScroll;//是否能上下滑动
@property (nonatomic,copy) void (^didScrollBlock)(CGFloat offset);

@property (nonatomic,strong) HXTableViewDataSource *hxDataSource;

@property (nonatomic,weak) id<HXTableViewDelegate> hxDelegate;

- (void)clearDataSoure;//只清空数据，不刷新UI;
- (NSInteger)dataSourceCount;
- (void)addDataAndReload:(NSArray<HXTableViewModel *>*)dataArray;//追加数据,更新UI
- (void)setDataAndReload:(NSArray<HXTableViewModel *>*)dataArray;//刷新数据,更新UI

@end
