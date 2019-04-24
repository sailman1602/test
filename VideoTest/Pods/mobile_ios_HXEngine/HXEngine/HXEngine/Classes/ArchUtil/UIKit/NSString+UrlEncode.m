//
//  NSString+UrlEncode.m
//  newHfax
//
//  Created by lly on 2018/1/31.
//  Copyright © 2018年 hfax. All rights reserved.
//

#import "NSString+UrlEncode.h"

@implementation NSString (UrlEncode)

-(NSString *) urlEncode
{
    NSString *s = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [s stringByReplacingOccurrencesOfString:@"%23/" withString:@"#/"];
//    if ([self isKindOfClass:[NSNull class]])
//    {
//        return @"";
//    }
//
//    NSString *result =
//    (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                          (CFStringRef)self,
//                                                                          NULL,
//                                                                          CFSTR("!*'();:@&=+$,/?%#[]"),
//                                                                          kCFStringEncodingUTF8));
//#if !__has_feature(objc_arc)
//    [result autorelease];
//#endif
//    return result;
    
}

-(NSString *) urlDecode
{
    NSString *result =(NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding
                                                    (kCFAllocatorDefault,
                                                     (CFStringRef)self,
                                                     CFSTR(""),
                                                     kCFStringEncodingUTF8));
#if !__has_feature(objc_arc)
    [result autorelease];
#endif
    return result;
    
}

-(BOOL)checkEncode
{
    if (self.length == 0) {
        return NO;
    }
    
    NSString *newUrl = [self urlDecode];
    if ([newUrl isEqualToString:self]) {
        return NO;
    }else {
        return YES;
    }
}

-(NSString *)urlSafeEncode
{
    if (self.length == 0) {
        return self;
    }
    
    BOOL hasEncode = [self checkEncode];
    if (hasEncode) {
        return self;
    }else {
        return [self urlEncode];
    }
}

@end
