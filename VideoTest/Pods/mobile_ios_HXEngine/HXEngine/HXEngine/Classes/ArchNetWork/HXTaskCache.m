//
//  HXTaskCache.m
//  newHfax
//
//  Created by lly on 2017/7/11.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXTaskCache.h"
#import "YYCache+StorePath.h"
#import "UIKitMacros.h"

static NSString *const kPPNetworkResponseCache = @"kPPNetworkResponseCache";

@implementation HXTaskCache

+ (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(NSDictionary *)parameters {
    NSInteger errCode = [[httpData objectForKey:@"errCode"] integerValue];
    if(errCode){
        if(errCode == 10101){
            [self removeAllHttpCache];
        }
        return;
    }
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    //异步缓存,不会阻塞主线程
    [[self dataCache] setObject:httpData forKey:cacheKey withBlock:nil];
    HXLog(@"SET httpCache --- cacheKey:%@",cacheKey);
}

+ (id)httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    NSString *cacheKey = [self cacheKeyWithURL:URL parameters:parameters];
    HXLog(@"GET httpCache --- cacheKey:%@",cacheKey);
    return [[self dataCache] objectForKey:cacheKey];
}

+ (NSInteger)getAllHttpCacheSize {
    return [[self dataCache].diskCache totalCost];
}

+ (void)removeAllHttpCache {
    [[self dataCache].memoryCache removeAllObjects];
    [[self dataCache].diskCache removeAllObjects];
}

+ (YYCache *)dataCache {
    return [YYCache storeWithKey:kPPNetworkResponseCache];
}

+ (NSString *)cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    if(!parameters){return URL;};
    // 将参数字典转换成字符串
    NSData *stringData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    
    // 将URL与转换好的参数字符串拼接在一起,成为最终存储的KEY值
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",URL,paraString];
    
    return cacheKey;
}


@end
