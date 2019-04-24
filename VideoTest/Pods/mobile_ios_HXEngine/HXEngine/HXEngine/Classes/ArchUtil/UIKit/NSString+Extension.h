//
//  NSString+Extension.h
//  newHfax
//
//  Created by sh on 2017/7/24.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+ (NSString *) base64StringFromData:(NSData *)data;

+ (id)stringWithDate:(NSDate*)date format:(NSString *)format;

+ (id)stringWithtimeinterval:(NSTimeInterval)timeInterval;

- (int) indexOf:(NSString*)str;

- (BOOL) equals:(NSString*)str;

- (NSString *)toMD5;
- (NSString *)reverseString;
+ (NSString *)getIPAddress ;
- (NSString *)addKeyToMD5;

- (BOOL)isChinese;

- (NSString *)formatTwoDecimal;
@end
