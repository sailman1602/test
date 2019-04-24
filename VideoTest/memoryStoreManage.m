//
//  memoryStoreManage.m
//  VideoTest
//
//  Created by YNZMK on 2019/4/13.
//  Copyright © 2019 YNZMK. All rights reserved.
//

#import "memoryStoreManage.h"

#define MemoryStoreManageKey @"MemoryStoreManageKey"
@implementation memoryStoreManage

+ (void)storeVideoPath:(NSString *)path url:(NSString *)url{
    NSDictionary *storeDic = [HXUserDefaults objectForKey:MemoryStoreManageKey];
    if (storeDic.count) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:storeDic];
        [tempDic setValue:path forKey:url];
        [HXUserDefaults setObject:tempDic forKey:MemoryStoreManageKey];
        [HXUserDefaults synchronize];
    }else{
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        [tempDic setValue:path forKey:url];
        [HXUserDefaults setObject:tempDic forKey:MemoryStoreManageKey];
        [HXUserDefaults synchronize];
    }
}
+ (NSString *)getVideoPathFromUrl:(NSString *)url{
    NSDictionary *storeDic = [HXUserDefaults objectForKey:MemoryStoreManageKey];
    if (storeDic.count) {
        return [storeDic objectForKey:url];
    }else{
        return nil;
    }
}
+ (NSArray *)getStoreVideoList{
    NSDictionary *storeDic = [HXUserDefaults objectForKey:MemoryStoreManageKey];
    if (storeDic.count) {
        return storeDic.allKeys;
    }else{
        return nil;
    }
}

@end
