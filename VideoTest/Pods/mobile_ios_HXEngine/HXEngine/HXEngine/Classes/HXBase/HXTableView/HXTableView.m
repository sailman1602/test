//
//  HXtableView.m
//  newHfax
//
//  Created by lly on 2017/8/22.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXTableView.h"
#import "HXTableViewDataSource.h"

@interface HXTableView ()<UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataSourceArray;

@end

@implementation HXTableView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [self initWithFrame:frame style:UITableViewStylePlain]){
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if(self){
        self.delegate = self;
        _dataSourceArray = [NSMutableArray array];
        _hxDataSource = [[HXTableViewDataSource alloc] initWithTableView:self showIndexTitle:NO];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)clearDataSoure{
    [_dataSourceArray removeAllObjects];
}

- (NSInteger)dataSourceCount{
    return self.dataSourceArray.count;
}
- (void)addDataAndReload:(NSArray<HXTableViewModel *>*)dataArray{//追加数据,更新UI
    [_dataSourceArray addObjectsFromArray:dataArray];
    [self.hxDataSource reloadWithItems:self.dataSourceArray];
}
- (void)setDataAndReload:(NSArray<HXTableViewModel *>*)dataArray{//刷新数据,更新UI
    [_dataSourceArray removeAllObjects];
    [_dataSourceArray addObjectsFromArray:dataArray];
    [self.hxDataSource reloadWithItems:self.dataSourceArray];
}

#pragma mark --- scrollDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    if(_didScrollBlock)
        _didScrollBlock(y);
    if(!_couldScroll){
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.hxDelegate && [self.hxDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
        [self.hxDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.hxDelegate && [self.hxDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]){
        [self.hxDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.hxDelegate && [self.hxDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]){
        return [self.hxDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.hxDelegate && [self.hxDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]){
        return [self.hxDelegate tableView:tableView heightForHeaderInSection:section];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.hxDelegate && [self.hxDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]){
        return [self.hxDelegate tableView:tableView heightForFooterInSection:section];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.hxDelegate && [self.hxDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]){
        return [self.hxDelegate tableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(self.hxDelegate && [self.hxDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]){
        return [self.hxDelegate tableView:tableView viewForFooterInSection:section];
    }
    return nil;
}

@end
