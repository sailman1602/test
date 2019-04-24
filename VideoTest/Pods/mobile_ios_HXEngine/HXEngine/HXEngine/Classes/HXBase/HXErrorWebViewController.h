//
//  HXErrorWebViewController.h
//  newHfax
//
//  Created by lly on 2017/9/4.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXBaseWebViewController.h"

@interface HXErrorWebViewController : HXBaseWebViewController

//server down h5 page
+ (instancetype)instanceWithErrorUrl:(NSString *)errorUrl;
+ (BOOL)isError;

@end
