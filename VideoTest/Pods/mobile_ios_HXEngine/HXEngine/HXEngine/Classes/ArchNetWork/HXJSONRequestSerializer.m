//
//  HXJSONRequestSerializer.m
//  newHfax
//
//  Created by lly on 2017/7/29.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXJSONRequestSerializer.h"
#import "UIKitMacros.h"
#import "HXCookie.h"
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>
#import "UIDevice+helpers.h"

@interface HXJSONRequestSerializer ()

@end

@implementation HXJSONRequestSerializer

+ (instancetype)serializer{
    
    HXJSONRequestSerializer *s = [super serializer];
    
#if DEBUG
    s.timeoutInterval = 5.0f;
#else
    s.timeoutInterval = 30.0f;
#endif
    
    //[s setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [s setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [s setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [s.publicParams enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        [s setValue:value forHTTPHeaderField:field];
    }];
    s.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    return s;
}

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError * __autoreleasing *)error
{
    NSMutableURLRequest* req = [[super requestBySerializingRequest:request withParameters:parameters error:error] mutableCopy];
    NSDictionary *dic = [self customPublicParams];
    HXLog(@"Serializing api Request Cookie:%@",dic[@"Cookie"]);
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [req setValue:obj forHTTPHeaderField:key];
    }];
    HXLog(@"API Requst Serializing -url:%@,header:%@,params:%@",req.URL,req.allHTTPHeaderFields,parameters);
    return req;
}


#pragma mark - params
/*
 |appVersion|应用版本号|
 |deviceId|手机唯一识别码|
 |network|手机当前网络|
 |os|系统 Android/iOS|
 |osVersion|系统版本号|
 |model|手机型号|
 |channel|渠道号|
 注：此公共参数每次请求都拼接到url后面
 */
- (NSMutableDictionary *)publicParams{
    NSMutableDictionary *publicParams = [NSMutableDictionary dictionary];
        [publicParams setObject:[UIDevice appCurVersion] forKey:@"appVersion"];
        [publicParams setObject:[UIDevice device] forKey:@"deviceId"];
        [publicParams setObject:@"IOS" forKey:@"os"];
        [publicParams setObject:[UIDevice versionCode] forKey:@"model"];
        [publicParams setObject:@"APS-IOS-001-00001" forKey:@"channel"];
        [publicParams setObject:[UIDevice dpi] forKey:@"dpi"];
    return publicParams;
}

-(NSMutableDictionary *)customPublicParams{
    NSMutableDictionary *d =  [NSMutableDictionary dictionary];
    NSString *statusString = [self networkStatus:[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus];
    [d setObject:statusString forKey:@"network"];
    [d setObject:[self getDeviceId] forKey:@"deviceId"];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:[HXCookie cookies]];
    NSString *Cookie = dictCookies[@"Cookie"];
    if(Cookie){
      [d setObject: [dictCookies objectForKey:@"Cookie"] forKey: @"Cookie"];
    }
    return d;
}
- (NSDictionary *)allPublicParams{
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:self.publicParams];
    [d addEntriesFromDictionary:self.customPublicParams];
    return d;
}

- (NSString *)networkStatus:(AFNetworkReachabilityStatus)status
{
    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
        return @"WiFi";
    } else if(status == AFNetworkReachabilityStatusReachableViaWWAN) {
        return @"4G";
    }
    return @"UNKONW";
}

#pragma mark - update public params
//- (void)updateAuthKey:(NSString *)authKey{
//    [self.publicParams setObject:ensureObject(authKey, @"") forKey:@"authKey"];
//    [self setValue:ensureObject(authKey, @"") forHTTPHeaderField:@"authKey"];
//}
//
//- (void)updateNetWotkStatus:(NSInteger)status{
//    NSString *statusString = [self networkStatus:[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus];
//    [self.publicParams setObject:statusString forKey:@"network"];
//    [self setValue:statusString forHTTPHeaderField:@"network"];
//}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                                  error:(NSError *__autoreleasing *)error
{
    NSMutableURLRequest *req = [super multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:error];
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if ([[parameters objectForKey:@"updateFile"] intValue] == 1) {
        HXLog(@"request allHTTPHeaderFields:%@",req.allHTTPHeaderFields);
        [para removeObjectForKey:@"updateFile"];
    } else {
        [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        req.HTTPBody = [[self formDataHttpBodyString:para] dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return  req;
}

- (NSString *)formDataHttpBodyString:(NSDictionary *)parameters{
    NSMutableString *httpBodyString = [NSMutableString string];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [httpBodyString appendString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
    }];
    return httpBodyString;
}

- (NSString *)getDeviceId{
    NSString*adid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adid?adid:@"";
}

@end
