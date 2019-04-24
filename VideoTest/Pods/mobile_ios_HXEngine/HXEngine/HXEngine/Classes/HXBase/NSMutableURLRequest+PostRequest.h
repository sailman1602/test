//
//  NSMutableURLRequest+PostRequest.h
//  newHfax
//
//  Created by lly on 2018/3/5.
//  Copyright © 2018年 hfax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (PostRequest)

+ (NSMutableURLRequest *)requestWithPostUrl:(NSString *)url Headers:(NSDictionary *)heders params:(NSDictionary *)params;

@end
