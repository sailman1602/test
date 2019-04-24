//
//  HXCookie.h
//  newHfax
//
//  Created by lly on 2017/7/13.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXCookie : NSObject

//保存cookie （登录成功）
+ (void)saveCookie:(NSArray <NSHTTPCookie *> *)cookies;
+ (NSArray <NSHTTPCookie *> *)cookies;

////应用cookie （程序启动）
+ (void)applyCookieFromCache;

//清除cookie（退出登录，切换用户）
+ (void)clearCookie;

@end
