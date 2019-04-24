//
//  HXJSONRequestSerializer.h
//  newHfax
//
//  Created by lly on 2017/7/29.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface HXJSONRequestSerializer : AFJSONRequestSerializer

-(NSMutableDictionary *)publicParams;
-(NSMutableDictionary *)customPublicParams;
- (NSDictionary *)allPublicParams;

@end
