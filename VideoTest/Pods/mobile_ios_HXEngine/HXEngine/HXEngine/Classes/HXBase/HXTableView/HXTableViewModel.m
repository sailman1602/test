//
//  HXTableViewModel.m
//  newHfax
//
//  Created by lly on 2017/7/2.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXTableViewModel.h"
#import "HXTableViewCell.h"

@interface HXTableViewModel()
@property (nonatomic, readwrite, strong) id item;
@property (nonatomic, readwrite, assign) SEL collationStringSelector;
@property (nonatomic, readwrite, copy) void (^configurationBlock)(HXTableViewCell *cell, __weak id item);
@end

@implementation HXTableViewModel

- (instancetype)initWithItem:(id)item cellClass:(Class)cellClass configurationBlock:(void(^)(HXTableViewCell *cell, __weak id item))configurationBlock{
    if (self = [super init]) {
        _item = item;
        _cellClass = cellClass;
        _configurationBlock = configurationBlock;
    }
    
    return self;
}

- (instancetype)initWithItem:(id)item xibName:(NSString *)xibName cellClass:(Class)cellClass configurationBlock:(void(^)(HXTableViewCell *cell, __weak id item))configurationBlock{
    if (self = [super init]) {
        _item = item;
        _xibName = [xibName copy];
        _cellClass = cellClass;
        _configurationBlock = configurationBlock;
    }
    return self;
}

- (instancetype)initWithItem:(id)item cellClass:(Class)cellClass{
    if (self = [super init]) {
        _item = item;
        _cellClass = cellClass;
    }
    
    return self;
}
- (instancetype)initWithItem:(id)item xibName:(NSString *)xibName cellClass:(Class)cellClass{
    if (self = [super init]) {
        _item = item;
        _xibName = [xibName copy];
        _cellClass = cellClass;
    }
    return self;
}

// static cell
+ (instancetype)newWithText:(NSString *)text{
    HXTableViewModel *model = [[HXTableViewModel alloc]initWithItem:text cellClass:HXTableViewCell.class];
    return model;
}

+ (instancetype)newWithText:(NSString *)text accessoryType:(UITableViewCellAccessoryType)accessoryType{
    HXTableViewModel *model = [[HXTableViewModel alloc]initWithItem:@{@"text":(text.length?text:@""),@"accessoryType":@(accessoryType)} cellClass:HXTableViewCell.class];
    return model;
}
+ (instancetype)newWithText:(NSString *)text detailText:(NSString *)detailText{
    HXTableViewModel *model = [[HXTableViewModel alloc]initWithItem:@{@"text":(text.length?text:@""),@"detailText":(detailText.length?detailText:@"")} cellClass:HXTableViewCell.class];
    return model;
}
+ (instancetype)newWithText:(NSString *)text detailText:(NSString *)detailText accessoryType:(UITableViewCellAccessoryType)accessoryType{
    HXTableViewModel *model = [[HXTableViewModel alloc]initWithItem:@{@"text":(text.length?text:@""),@"detailText":(detailText.length?detailText:@""),@"accessoryType":@(accessoryType)} cellClass:HXTableViewCell.class];
    return model;
}

@end
