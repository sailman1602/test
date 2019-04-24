//
//  HXPageView.h
//  newHfax
//
//  Created by lly on 2017/8/22.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXTableView_public.h"
#import "HXTableView.h"

@protocol HXPageViewDelegate <HXTableViewDelegate>

@optional;
- (void)onHeaderRefreshAtIndex:(NSInteger)index;
- (void)onFooterLoadMoreAtIndex:(NSInteger)index;

@end

@interface HXPageView : UIScrollView

@property (nonatomic,strong,readonly) NSArray<__kindof HXTableView *> *subViews;

@property (nonatomic,assign) BOOL couldScroll;//是否能上下滑动

@property (nonatomic,copy) void (^didSelectSubViewBlock)(NSInteger index);

@property (nonatomic,copy) void (^didScrollBlock)(CGFloat offset);

@property (nonatomic,weak) id<HXPageViewDelegate> hxDelegate;

- (instancetype)initWithSubViews:(NSArray<__kindof HXTableView *> *)subViews;
- (void)showSubView:(NSInteger)index;

- (__kindof HXTableView *)currentSubTableView;
- (__kindof HXTableView *)subTableViewAtIndex:(NSInteger)index;

- (void)initRefreshWithType:(HXRefreshType)refreshType;
- (void)initRefreshWithType:(HXRefreshType)refreshType WithUseNewTypeHeader:(BOOL)useNewTypeHeader;

- (void)endRefreshAtIndex:(NSInteger)index;
- (void)endHeaderRefershAtIndex:(NSInteger)index;
- (void)endFooterLoadMoreAtIndex:(NSInteger)index;
- (void)endRefreshingWithNoMoreDataAtIndex:(NSInteger)index;

- (void)clearDataSourceAtIndex:(NSInteger)index;
- (NSInteger)dataSourceCountAtIndex:(NSInteger)index;

- (void)setDefualtViewOffset:(CGFloat)offset;

@end
