//
//  NSString+Extension.m
//  newHfax
//
//  Created by sh on 2017/7/24.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>


static const char BASE64_CHAR_TABLE[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@implementation NSString (Extension)

+ (NSString*) base64StringFromData: (NSData*)data {
    if (data == nil)
        return nil;
    
    int length = (int)[data length];
    
    const unsigned char *bytes = [data bytes];
    NSMutableString *result = [NSMutableString stringWithCapacity:length];
    unsigned long ixtext = 0;
    long ctremaining = 0;
    unsigned char bufIn[3], bufOut[4];
    short i = 0;
    short charsonline = 0, ctcopy = 0;
    unsigned long ix = 0;
    while( YES ) {
        ctremaining = length - ixtext;
        if( ctremaining <= 0 ) break;
        for( i = 0; i < 3; i++ ) {
            ix = ixtext + i;
            if( ix < length ) bufIn[i] = bytes[ix];
            else bufIn [i] = 0;
        }
        bufOut [0] = (bufIn [0] & 0xFC) >> 2;
        bufOut [1] = ((bufIn [0] & 0x03) << 4) | ((bufIn [1] & 0xF0) >> 4);
        bufOut [2] = ((bufIn [1] & 0x0F) << 2) | ((bufIn [2] & 0xC0) >> 6);
        bufOut [3] = bufIn [2] & 0x3F;
        ctcopy = 4;
        switch( ctremaining ) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        for( i = 0; i < ctcopy; i++ )
            [result appendFormat:@"%c", BASE64_CHAR_TABLE[bufOut[i]]];
        for( i = ctcopy; i < 4; i++ )
            [result appendString:@"="];
        ixtext += 3;
        charsonline += 4;
    }
    return result;
}

+ (id)stringWithDate:(NSDate*)date format:(NSString *)format {
    assert(format != nil);
    if (date == nil)
        return nil;
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    NSString* result = [[NSString alloc] initWithFormat:@"%@", [df stringFromDate:date]];
    return result;
}

+ (id)stringWithtimeinterval:(NSTimeInterval)timeInterval
{

    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result = @"";
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"1分钟"];
    } else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟",temp];
    } else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时",temp];
    } else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天",temp];
    } else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月",temp];
    } else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年",temp];
    }
    
    return  result;
}

- (int) indexOf:(NSString*)str {
    NSRange range = [self rangeOfString:str];
    return (range.length > 0) ? (int)range.location : -1;
}

- (BOOL) equals:(NSString*)str {
    if (str == nil)
        return NO;
    return ([self compare:str] == NSOrderedSame);
}

- (NSString *)toMD5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)reverseString
{
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:self.length];
    
    [self enumerateSubstringsInRange:NSMakeRange(0,self.length)
                             options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              [reversedString appendString:substring];
                          }];
    return reversedString;
}

+ (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
//登录密码/交易密码等+key再MD5
- (NSString *)addKeyToMD5
{
    NSString *keyString = [NSString stringWithFormat:@"%@%@",self,@"TuD00Iqz4ge7gzIe2rmjSAFFKtaIBmnr8S"];
    return [keyString toMD5];
}

- (BOOL)isChinese{
    if(!self.length) return NO;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[\u4e00-\u9fa5]+"];
    return [pred evaluateWithObject:self];
}


- (NSString *)formatTwoDecimal{
    NSString *desString = [self copy];
    if ([desString containsString:@"."]) {
        NSArray *ary = [desString componentsSeparatedByString:@"."];
        if (ary.count == 2) {
            NSString *lastString = ary.lastObject;
            if (lastString.length > 2) {
                lastString = [lastString substringToIndex:2];
                desString = [NSString stringWithFormat:@"%@.%@",ary.firstObject,lastString];
            }
        }else {
            NSString *lastString = ary[1];
            if (lastString.length > 2) {
                lastString = [lastString substringToIndex:2];
            }else {
                lastString = [lastString substringToIndex:lastString.length];
            }
            desString = [NSString stringWithFormat:@"%@.%@",ary.firstObject,lastString];
        }
        
    };
    return desString;
}

@end
