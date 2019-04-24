//
//  HXURLProtocol.h
//  newHfax
//
//  Created by lly on 2018/3/14.
//  Copyright © 2018年 hfax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXURLProtocol : NSURLProtocol


@end


@interface NSURLProtocol (wk)

+ (void)wk_registerScheme:(NSString*)scheme;

+ (void)wk_unregisterScheme:(NSString*)scheme;

@end
