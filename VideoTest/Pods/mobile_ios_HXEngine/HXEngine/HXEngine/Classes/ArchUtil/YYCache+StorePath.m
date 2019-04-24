//
//  YYCache+StorePath.m
//  mobile_ios_HXEngine
//
//  Created by lly on 2018/7/2.
//  Copyright © 2018年 hfax. All rights reserved.
//

#import "YYCache+StorePath.h"

@implementation YYCache (StorePath)

+(YYCache *)storeWithKey:(NSString *)key{
    return [YYCache cacheWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:key]];
}

@end
