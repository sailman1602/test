//
//  HXWebJSProtocol.h
//  newHfax
//
//  Created by lly on 2018/2/8.
//  Copyright © 2018年 hfax. All rights reserved.
//

#ifndef HXWebJSProtocol_h
#define HXWebJSProtocol_h

@class HXBaseWebViewController;
@protocol HXWebJSProtocol

@property (nonatomic,weak) UIViewController<HXWebJSProtocol> *enteyWebViewController;
@property (nonatomic,strong) NSDictionary *h5ParamsData;
- (void)onLastPageClosed:(NSDictionary *)data;

@end

#endif /* HXWebJSProtocol_h */
