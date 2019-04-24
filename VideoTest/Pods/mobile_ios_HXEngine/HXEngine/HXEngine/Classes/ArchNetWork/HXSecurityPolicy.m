//
//  HXSecurityPolicy.m
//  mobile_ios_HXEngine
//
//  Created by lly on 2018/11/16.
//  Copyright © 2018 hfax. All rights reserved.
//

#import "HXSecurityPolicy.h"

static BOOL _isProxyError = NO;

@implementation HXSecurityPolicy

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust forDomain:(NSString *)domain{
//#if !PRO
    return [super evaluateServerTrust:serverTrust forDomain:domain];
//#endif
//    NSDictionary *proxySettings =  (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
//    if(![domain hasPrefix:@"http"]) domain = [NSString stringWithFormat:@"https://%@",domain];
//    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:domain]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
//    NSDictionary *settings = [proxies objectAtIndex:0];
//    if (![[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
//        //设置代理了
//        [self.class setProxyError:YES];
//        return NO;
//    }else{
//        [self.class setProxyError:NO];
//    }
//    return [super evaluateServerTrust:serverTrust forDomain:domain];
}

+ (NSString *)proxySecurityErrorMsg{
    return @"请检查您的网络连接是否安全";
}

+ (BOOL)isProxyError{
        return _isProxyError;
}

+ (void)setProxyError:(BOOL)isError{
        _isProxyError = isError;
}

@end
