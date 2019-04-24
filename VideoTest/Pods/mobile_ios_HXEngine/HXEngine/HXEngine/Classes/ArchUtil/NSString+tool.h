//
//  NSString+tool.h
//  newHfax
//
//  Created by 张驰 on 2017/7/24.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (tool)
+(BOOL)isNullString:(NSString *)string;
+(NSString *)amountFormatString:(NSString *)string;
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString dateFormat:(NSString *)dateType;

//输入的字符串转成金额 单位分
- (long)amountCentValue;

/// 过滤空格
+ (NSString *)filterSpaseString:(NSString*)string ;
@end
