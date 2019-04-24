//
//  HXPaginator.m
//  p2p
//
//  Created by Philip on 9/22/15.
//  Copyright © 2015 HXSoft. All rights reserved.
//

#import "HXPaginator.h"

@interface HXPaginator()
@property (nonatomic, readwrite, assign) NSUInteger pageSize;
@property (nonatomic, readwrite, assign) NSUInteger pageNumber;
@end

@implementation HXPaginator

+ (instancetype)paginatorWithPageSize:(NSUInteger)pageSize pageNumber:(NSUInteger)pageNumber {
    HXPaginator *paginator = [self.class new];
    paginator.pageNumber = pageNumber;
    paginator.pageSize = pageSize;
    return paginator;
}

- (instancetype)nextPage {
    HXPaginator *paginator = [self.class new];
    paginator.pageNumber = self.pageNumber + 1;
    paginator.pageSize = self.pageSize;
    return paginator;
}

@end
