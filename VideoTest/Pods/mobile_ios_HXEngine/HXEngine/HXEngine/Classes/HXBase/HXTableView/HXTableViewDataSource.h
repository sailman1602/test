//
//  HXTableViewDataSource.h
//  newHfax
//
//  Created by lly on 2017/7/2.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXTableViewModel;
@interface HXTableViewDataSource : NSObject

@property (nonatomic, strong) NSMutableArray<NSMutableArray<HXTableViewModel *> *> *sections;
@property (nonatomic, copy) NSArray *rows;
@property (nonatomic, assign) NSInteger sectionCount;

@property (nonatomic, assign) BOOL hideDefaultView;


- (instancetype)initWithTableView:(UITableView *)tableView;

- (instancetype)initWithTableView:(UITableView *)tableView showIndexTitle:(BOOL)shouldShowIndexTitle;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (void)addItems:(NSArray<HXTableViewModel *> *)items;

- (void)reloadWithItems:(NSArray<HXTableViewModel *> *)items;

- (void)addSections:(NSArray<NSArray *> *)sections;

- (void)reloadWithSections:(NSArray<NSArray *> *)sections;


- (void)reloadData;

- (void)reloadDataAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)clearRenderQueue;

@end
