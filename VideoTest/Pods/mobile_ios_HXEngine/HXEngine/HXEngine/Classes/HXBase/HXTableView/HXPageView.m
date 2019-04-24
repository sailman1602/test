//
//  HXPageView.m
//  newHfax
//
//  Created by lly on 2017/8/22.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXPageView.h"
#import <MJRefresh/MJRefresh.h>
#import "HXRefreshHeader.h"
#import "HXRefreshFooter.h"
#import "UIView+HXShow.h"
#import <Masonry/Masonry.h>
#import "HXUIDefines.h"

@interface HXPageView ()<UIScrollViewDelegate>

@property (nonatomic,strong,readwrite) NSArray<__kindof HXTableView *> *subViews;
@property (nonatomic,assign) NSInteger currentShowIndex;

@end

@implementation HXPageView

- (instancetype)initWithSubViews:(NSArray<__kindof HXTableView *> *)subViews{
    self = [super init];
    if(self){
        _subViews = subViews;
        for(int i = 0;i<_subViews.count;i++){
            HXTableView *view = _subViews[i];
            view.tag = i;
            [self addSubview:view];
        }
        self.delegate = self;
        self.pagingEnabled = YES;
        [self configureContraints];
    }
    return self;
}

- (void)configureContraints{
    for(int i=0;i<_subViews.count;i++){
        HXTableView *view = _subViews[i];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(self);
            make.width.mas_equalTo(ScreenWidth);
            make.left.mas_equalTo(ScreenWidth*i);
        }];
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentSize = CGSizeMake(ScreenWidth*_subViews.count, self.frame.size.height);
}

- (void)showSubView:(NSInteger)index{
    //主动切换
    _currentShowIndex = index;
    //todo
    CGPoint originOffset = self.contentOffset;
    self.contentOffset = CGPointMake(ScreenWidth*index, originOffset.y);
}

#pragma mark - getter and setter
- (void)setHxDelegate:(id<HXPageViewDelegate>)hxDelegate{
    _hxDelegate = hxDelegate;
    for(HXTableView *view in self.subViews){
        view.hxDelegate = hxDelegate;
    }
}
- (void)setCouldScroll:(BOOL)scrollEnabled;{
    _couldScroll = scrollEnabled;
    for(HXTableView *view in self.subViews){
        view.couldScroll = scrollEnabled;
    }
}

- (void)setDidScrollBlock:(void (^)(CGFloat))didScrollBlock{
    _didScrollBlock = didScrollBlock;
    for(HXTableView *view in _subViews){
        [view setDidScrollBlock:didScrollBlock];
    }
    
}

- (__kindof HXTableView *)currentSubTableView{
    return self.subViews[_currentShowIndex];
}
- (__kindof HXTableView *)subTableViewAtIndex:(NSInteger)index{
    return self.subViews[index];
}

#pragma mark --
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //判断tab切换
    int index = scrollView.contentOffset.x/ScreenWidth;
    if(_currentShowIndex!=index){
        _currentShowIndex = index;
        if(_didSelectSubViewBlock){
            _didSelectSubViewBlock(_currentShowIndex);
        }
        
    }
}

#pragma mark - refresh
- (void)initRefreshWithType:(HXRefreshType)refreshType{
    [self initRefreshWithType:refreshType WithUseNewTypeHeader:NO];
}

- (void)initRefreshWithType:(HXRefreshType)refreshType WithUseNewTypeHeader:(BOOL)useNewTypeHeader{
    if(refreshType==HXRefreshTypeOnlyHeader||refreshType==HXRefreshTypeHeaderFooter){
        [self addMJRefresh:YES WithUseNewTypeHeader:useNewTypeHeader];
    }
    if(refreshType==HXRefreshTypeOnlyFooter||refreshType==HXRefreshTypeHeaderFooter){
        [self addMJRefresh:NO WithUseNewTypeHeader:useNewTypeHeader];
    }
}

- (void)endRefreshAtIndex:(NSInteger)index{
    [self endHeaderRefershAtIndex:index];
    [self endFooterLoadMoreAtIndex:index];
}

- (void)endHeaderRefershAtIndex:(NSInteger)index{
    HXTableView *view = [self subTableViewAtIndex:index];
    HXRefreshHeader *headerView = (HXRefreshHeader *)view.mj_header;
    [headerView endHeaderRefresh];
}
- (void)endFooterLoadMoreAtIndex:(NSInteger)index{
    HXTableView *view = [self subTableViewAtIndex:index];
    [view.mj_footer endRefreshing];
}

- (void)endRefreshingWithNoMoreDataAtIndex:(NSInteger)index{
    HXTableView *view = [self subTableViewAtIndex:index];
    [view.mj_footer endRefreshingWithNoMoreData];
}
- (void)addMJRefresh:(BOOL)isHeader WithUseNewTypeHeader:(BOOL)useNewTypeHeader{
    for(HXTableView *view in self.subViews){
        if(isHeader){
            HXRefreshHeader *refreshHeader = [HXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(onHeaderRefresh)];
            refreshHeader.isNewRefreshHeaderType = useNewTypeHeader;
            view.mj_header = refreshHeader;
        }else{
            view.mj_footer = [HXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(onFooterLoadMore)];
        }
    }
}

- (void)onHeaderRefresh{
    if(self.hxDelegate && [self.hxDelegate respondsToSelector:@selector(onHeaderRefreshAtIndex:)]){
        [self.hxDelegate onHeaderRefreshAtIndex:self.currentShowIndex];
    }
}

- (void)onFooterLoadMore{
    if(self.hxDelegate && [self.hxDelegate respondsToSelector:@selector(onFooterLoadMoreAtIndex:)]){
        [self.hxDelegate onFooterLoadMoreAtIndex:self.currentShowIndex];
    }
}

- (void)clearDataSourceAtIndex:(NSInteger)index{
    HXTableView *tableView = [self subTableViewAtIndex:index];
    [tableView clearDataSoure];
}

- (NSInteger)dataSourceCountAtIndex:(NSInteger)index{
    HXTableView *tableView = [self subTableViewAtIndex:index];
    return [tableView dataSourceCount];
}

#pragma mark - default View
- (void)setDefualtViewOffset:(CGFloat)offset{
    for(HXTableView *view in _subViews){
        view.defaultViewOffset = offset;
    }
}
@end
