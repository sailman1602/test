//
//  NSDictionary+JSONExtern.m
//  newHfax
//
//  Created by sh on 2017/7/26.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "NSDictionary+JSONExtern.h"

@implementation NSDictionary (JSONExtern)

- (NSString *)stringForKey:(id)key
{
    NSString * const kEmptyStrings = @"";
    NSString *result = [self objectForKey:key];
    if([result isKindOfClass:[NSString class]])
    {
        return result;
    }
    else if ([result isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%lf", [result doubleValue]];
    }
    return kEmptyStrings;
}

#pragma mark - double
- (NSString *)stringDoubleValueForKey:(id) key
{
    id result = [self objectForKey:key];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    if ([result isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%lf", [result doubleValue]];
    }
    return @"";
}

#pragma mark - intenger
- (NSString *)stringIntForKey:(id)key
{
    id result = [self objectForKey:key];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    if ([result isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%lld",[result longLongValue]];
    }
    return @"";
}
#pragma mark - float
- (NSString *)stringFloatForKey:(id)key
{
    id result = [self objectForKey:key];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    if ([result isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%.2f", [result floatValue]];
    }
    return @"";
}

- (NSDictionary *)dictionaryForKey:(id)key
{
    NSDictionary *result = [self objectForKey:key];
    if([result isKindOfClass:[NSDictionary class]])
    {
        return result;
    }
    
    return nil;
}

// jason: return nil if the object is null or not a NSArray.
- (NSArray *)arrayForKey:(id)key
{
    NSArray *result = [self objectForKey:key];
    if([result isKindOfClass:[NSArray class]])
    {
        return result;
    }
    return nil;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end

