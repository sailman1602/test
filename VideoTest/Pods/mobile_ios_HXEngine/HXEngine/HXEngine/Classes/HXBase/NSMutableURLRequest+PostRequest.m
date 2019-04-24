//
//  NSMutableURLRequest+PostRequest.m
//  newHfax
//
//  Created by lly on 2018/3/5.
//  Copyright © 2018年 hfax. All rights reserved.
//

#import "NSMutableURLRequest+PostRequest.h"
#import <YYModel/NSObject+YYModel.h>
#import "HXTaskManager.h"
#import "UIKitMacros.h"
#import "HXCookie.h"
#import "HXJSONRequestSerializer.h"

@implementation NSMutableURLRequest (PostRequest)

+ (NSMutableURLRequest *)requestWithPostUrl:(NSString *)url Headers:(NSDictionary *)heders params:(NSDictionary *)params{
    HXLog(@"requestWithPostUrl:%@  header:%@  params:%@",url,heders,params);
    if(![url hasPrefix:@"http"]){
//        url = [NSString stringWithFormat:@"%@%@",HXUserModuleInstance.APIHost,url];
    }
//    [url string]
    NSString * jsonParam = [params yy_modelToJSONString];
    NSMutableURLRequest * request = nil;
    if(jsonParam.length){
#if !PRO
        url = [url stringByReplacingOccurrencesOfString:@"http://" withString:@"hfaxpost://"];
#endif
        url = [url stringByReplacingOccurrencesOfString:@"https://" withString:@"hfaxpost://"];
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        NSMutableString *httpBodyString = [NSMutableString string];
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [httpBodyString appendString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
        }];
        
        [request setValue:httpBodyString forHTTPHeaderField:@"hfaxPostBody"];
    }else{
       request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    }
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html" forHTTPHeaderField:@"accept"];
    [request setHTTPMethod: @"POST"];

//    [request setHTTPBody: [jsonParam dataUsingEncoding: NSUTF8StringEncoding]];
    
    NSDictionary *publicParams = [HXTaskManagerInstance allPublicParams];
    [publicParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull field, id  _Nonnull value, BOOL * _Nonnull stop) {
        [request setValue:value forHTTPHeaderField:field];
    }];
    [heders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull field, id  _Nonnull value, BOOL * _Nonnull stop) {
        [request setValue:value forHTTPHeaderField:field];
    }];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:[HXCookie cookies]];
    [request setValue: [dictCookies objectForKey:@"Cookie"] forHTTPHeaderField: @"Cookie"];
    
    return request;
};

@end
