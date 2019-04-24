//
//  NSDictionary+JSONExtern.h
//  newHfax
//  字典里的取值
//  Created by sh on 2017/7/26.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (JSONExtern)
/**
 *
 *  @param  DictionaryKey
 *
 *  @return return an empty string
 */
- (NSString *)stringForKey:(id)key;

- (NSString *)stringIntForKey:(id)key;

- (NSString *)stringDoubleValueForKey:(id) key;

- (NSString *)stringFloatForKey:(id)key;

// json: return nil if the object is NSNull or not a NSDictionary
- (NSDictionary *)dictionaryForKey:(id)key;

// json: return nil if the object is null or not a NSArray.
- (NSMutableArray *)arrayForKey:(id)key;
// 字符串 转换为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end

