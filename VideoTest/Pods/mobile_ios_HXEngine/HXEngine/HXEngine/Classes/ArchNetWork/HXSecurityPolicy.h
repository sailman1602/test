//
//  HXSecurityPolicy.h
//  mobile_ios_HXEngine
//
//  Created by lly on 2018/11/16.
//  Copyright © 2018 hfax. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXSecurityPolicy : AFSecurityPolicy

+ (NSString *)proxySecurityErrorMsg;
+ (BOOL)isProxyError;

@end

NS_ASSUME_NONNULL_END
