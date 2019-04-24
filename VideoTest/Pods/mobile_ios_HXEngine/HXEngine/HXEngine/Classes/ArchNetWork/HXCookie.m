//
//  HXCookie.m
//  newHfax
//
//  Created by lly on 2017/7/13.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXCookie.h"
#import <YYCache/YYCache.h>
#import "UIKitMacros.h"

static NSString *HXCookieKey = @"HXCookieKey";
#define HXCookieCache [YYCache cacheWithName:HXCookieKey]

@implementation HXCookie

//保存cookie （登录成功）
+ (void)saveCookie:(NSArray <NSHTTPCookie *> *)cookies{
    if(cookies.count == 0)return;
    NSData *cookieData = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [HXCookieCache setObject:cookieData forKey:HXCookieKey];
}

+ (NSArray <NSHTTPCookie *> *)cookies{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[HXCookieCache objectForKey:HXCookieKey]];
    return cookies;
}
//应用cookie （程序启动）
+ (void)applyCookieFromCache{
    NSArray *cookies = [self cookies];
    if (cookies) {
        HXLog(@"应用 cookie from Disk Cache");
        //设置cookie
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (id cookie in cookies) {
            [cookieStorage setCookie:(NSHTTPCookie *)cookie];
        }
    }
}

//清除cookie（退出登录，切换用户）
+ (void)clearCookie{
    [HXCookieCache removeAllObjects];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (id cookie in cookieStorage.cookies) {
        [cookieStorage deleteCookie:cookie];
    }
}

@end
