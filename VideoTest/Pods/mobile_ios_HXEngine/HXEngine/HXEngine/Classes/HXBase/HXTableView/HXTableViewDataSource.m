//
//  HXTableViewDataSource.m
//  newHfax
//
//  Created by lly on 2017/7/2.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXTableViewDataSource.h"
#import "HXTableViewModel.h"
#import <Bolts/Bolts.h>
#import "UIView+HXShow.h"
#import "UITableViewCell+BindModel.h"

@interface HXTableViewDataSource() <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSOperationQueue *renderQueue;
@property (nonatomic, assign, getter=shouldShowIndexTitle) BOOL showIndexTitle;
@property (nonatomic, retain) NSMutableDictionary *classAction;

@end

@implementation HXTableViewDataSource

- (instancetype)initWithTableView:(UITableView *)tableView {
    return [self initWithTableView:tableView showIndexTitle:NO];
}

- (instancetype)initWithTableView:(UITableView *)tableView showIndexTitle:(BOOL)shouldShowIndexTitle {
    if (self = [super init]) {
        _classAction = [[NSMutableDictionary alloc] init];
        _showIndexTitle = shouldShowIndexTitle;
        _renderQueue = [NSOperationQueue new];
        _renderQueue.maxConcurrentOperationCount = 1;
        _tableView = tableView;
        _tableView.estimatedRowHeight = 65.0f;
        _tableView.dataSource = self;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
#ifdef __IPHONE_11_0
         if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
        }
#endif
        if(shouldShowIndexTitle){
            NSMutableArray *mutableSections = [NSMutableArray new];
            for (NSUInteger index = 0; index < [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count]; index ++) {
                [mutableSections addObject:[NSMutableArray new]];
            }
            _sections = [mutableSections copy];
        }else{
            _sections = [NSMutableArray array];
            [_sections addObject:[NSMutableArray array]];
        }
    }
    
    return self;
}

#pragma mark - items
- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;
    
    NSArray *sectionItems = self.sections[section];
    
    if (indexPath.row >= sectionItems.count) return nil;
    return sectionItems[indexPath.row];
}

- (void)addItems:(NSArray<HXTableViewModel *> *)items{
    [self addItems:items isReload:NO];
}
- (void)addItems:(NSArray<HXTableViewModel *> *)items isReload:(BOOL)isReload{
    typeof(self) __weak weakSelf = self;
    
    [[[BFTask taskFromExecutor:[BFExecutor executorWithOperationQueue:self.renderQueue] withBlock:^id{
        [NSThread sleepForTimeInterval:0.05f];
        return [BFTask taskWithResult:@YES];
    }] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        NSMutableArray *addedIndexPath = [NSMutableArray new];
        if(!weakSelf.sections.count){
            [weakSelf.sections addObject:[NSMutableArray array]];
        }else if (isReload){
            [weakSelf.sections removeAllObjects];
            [weakSelf.sections addObject:[NSMutableArray array]];
        }
        
        for (HXTableViewModel *item in items) {
            if(item.xibName.length){
                [weakSelf.tableView registerNib:[UINib nibWithNibName:item.xibName bundle:nil] forCellReuseIdentifier:NSStringFromClass(item.cellClass)];
            }else{
                [weakSelf.tableView registerClass:item.cellClass forCellReuseIdentifier:NSStringFromClass(item.cellClass)];
            }
            NSInteger sectionNumber = weakSelf.shouldShowIndexTitle ? [[UILocalizedIndexedCollation currentCollation] sectionForObject:item.item collationStringSelector:item.collationStringSelector] : 0;
            NSMutableArray *sectionItems = weakSelf.sections[sectionNumber];
            NSUInteger insertIndex = sectionItems.count;
            
            [sectionItems addObject:item];
            [addedIndexPath addObject:[NSIndexPath indexPathForRow:insertIndex inSection:sectionNumber]];
        }
        
        return [BFTask taskWithResult:addedIndexPath];
    }] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [weakSelf.tableView reloadData];
        [weakSelf showDefaultView];
        return nil;
    }];
}

#pragma mark - sections
- (void)addSections:(NSArray<NSArray *> *)sections{
    [self addSections:sections isReload:NO];
}
- (void)addSections:(NSArray<NSArray *> *)sections isReload:(BOOL)isReload{
    typeof(self) __weak weakSelf = self;
    
    [[[BFTask taskFromExecutor:[BFExecutor executorWithOperationQueue:self.renderQueue] withBlock:^id{
        [NSThread sleepForTimeInterval:0.05f];
        return [BFTask taskWithResult:@YES];
    }] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        if(isReload){
            [self.sections removeAllObjects];
        }
        for (NSArray *section in sections) {
            if(!section.count)
                continue;
            NSMutableArray *items = [NSMutableArray array];
            for(HXTableViewModel *item in section){
                if(item.xibName.length){
                    [weakSelf.tableView registerNib:[UINib nibWithNibName:item.xibName bundle:nil] forCellReuseIdentifier:NSStringFromClass(item.cellClass)];
                }else{
                    [weakSelf.tableView registerClass:item.cellClass forCellReuseIdentifier:NSStringFromClass(item.cellClass)];
                }
                [items addObject:item];
            }
            [self.sections addObject:items];
        }
        return [BFTask taskWithResult:nil];
        
    }] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [weakSelf.tableView reloadData];
        [weakSelf showDefaultView];
        return nil;
    }];
}

- (void)reloadWithItems:(NSArray<HXTableViewModel *> *)items{
    [self addItems:items isReload:YES];
}


- (void)reloadWithSections:(NSArray<NSArray *> *)sections{
    [self addSections:sections isReload:YES];
}

- (void)removeAllItems {
    typeof(self) __weak weakSelf = self;
//    
    [[BFTask taskFromExecutor:[BFExecutor executorWithOperationQueue:self.renderQueue] withBlock:^id{
        [NSThread sleepForTimeInterval:0.05f];
        return [BFTask taskWithResult:@YES];
    }] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {

        [weakSelf.sections removeAllObjects];
        [weakSelf.sections addObject:[NSMutableArray array]];
        [weakSelf.tableView reloadData];
        return nil;
    }];
}

- (void)reloadData {
    typeof(self) __weak weakSelf = self;
    
    [[BFTask taskFromExecutor:[BFExecutor executorWithOperationQueue:self.renderQueue] withBlock:^id{
        [NSThread sleepForTimeInterval:0.05f];
        return [BFTask taskWithResult:@YES];
    }] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [weakSelf.tableView reloadData];
        return nil;
    }];
}

- (void)reloadDataAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    typeof(self) __weak weakSelf = self;
    
    [[BFTask taskFromExecutor:[BFExecutor executorWithOperationQueue:self.renderQueue] withBlock:^id{
        [NSThread sleepForTimeInterval:0.05f];
        return [BFTask taskWithResult:@YES];
    }] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [weakSelf.tableView beginUpdates];
        [weakSelf.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf.tableView endUpdates];
        return nil;
    }];
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionItems = self.sections[section];
    return sectionItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;
    NSArray *sectionItems = self.sections[section];
    
    if (indexPath.row >= sectionItems.count) return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    
    HXTableViewModel *model = sectionItems[indexPath.row];
    HXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(model.cellClass) forIndexPath:indexPath];
    
    if (model.configurationBlock) {
        model.configurationBlock(cell, model.item);
    }else{
        [cell bindModel:model.item];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!self.shouldShowIndexTitle) return nil;
    
    NSArray *sectionItems = self.sections[section];
    
    return sectionItems.count ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : @"";
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (!self.shouldShowIndexTitle) return nil;
    
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (!self.shouldShowIndexTitle) return 0;
    
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}


- (void)clearRenderQueue {
    [self.renderQueue cancelAllOperations];
}


#pragma mark - getter and setter
- (NSMutableArray<NSMutableArray<HXTableViewModel *> *> *)sections{
    if(!_sections){
        _sections = [NSMutableArray array];
        [_sections addObject:[NSMutableArray array]];
    }
    return _sections;
}

#pragma mark - showDefaultView
- (void)showDefaultView{
    if(!_hideDefaultView){
        BOOL needShowNoData = NO;
        if(self.sections.count==1){
            if(self.sections[0].count==0)
                needShowNoData = YES;
        }else{
            needShowNoData = YES;
            for(NSMutableArray *section in self.sections){
                if(section.count>0){
                    needShowNoData = NO;
                    break;
                }
            }
        }
        if(needShowNoData){
            [self.tableView showNoDataView];
        }else{
            [self.tableView hideDefaultView];
        }
    }
    
}
@end
