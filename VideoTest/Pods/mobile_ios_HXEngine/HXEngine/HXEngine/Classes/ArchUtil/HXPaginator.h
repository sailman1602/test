//
//  HXPaginator.h
//  p2p
//
//  Created by Philip on 9/22/15.
//  Copyright © 2015 HXSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    分页控制用的模型
 */
@interface HXPaginator : NSObject

@property (nonatomic, assign, readonly) NSUInteger pageSize;
@property (nonatomic, assign, readonly) NSUInteger pageNumber;

/**
    @brief 返回一个实例
 
    @param pageSize 页面行数
    @param pageNumber 页数
    @return `HXPaginator` 实例
 */
+ (instancetype)paginatorWithPageSize:(NSUInteger)pageSize pageNumber:(NSUInteger)pageNumber;

/**
    @brief 返回下一页控制的实例
 */
- (instancetype)nextPage;

@end
