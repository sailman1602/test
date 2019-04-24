//
//  HXTableViewModel.h
//  newHfax
//
//  Created by lly on 2017/7/2.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXTableViewCell.h"

@interface HXTableViewModel : NSObject

@property (nonatomic, readonly, strong) id item;
@property (nonatomic, readonly, copy) NSString *xibName;
@property (nonatomic, assign) Class cellClass;
@property (nonatomic, readonly, assign) SEL collationStringSelector;
@property (nonatomic, readonly, copy) void (^configurationBlock)(HXTableViewCell *cell, __weak id item);


- (instancetype)initWithItem:(id)item cellClass:(Class)cellClass configurationBlock:(void(^)(HXTableViewCell *cell, __weak id item))configurationBlock;

- (instancetype)initWithItem:(id)item xibName:(NSString *)xibName cellClass:(Class)cellClass configurationBlock:(void(^)(HXTableViewCell *cell, __weak id item))configurationBlock;

- (instancetype)initWithItem:(id)item cellClass:(Class)cellClass;
- (instancetype)initWithItem:(id)item xibName:(NSString *)xibName cellClass:(Class)cellClass;

// static cell
+ (instancetype)newWithText:(NSString *)text;
+ (instancetype)newWithText:(NSString *)text accessoryType:(UITableViewCellAccessoryType)accessoryType;
+ (instancetype)newWithText:(NSString *)text detailText:(NSString *)detailText;
+ (instancetype)newWithText:(NSString *)text detailText:(NSString *)detailText accessoryType:(UITableViewCellAccessoryType)accessoryType;

@end
