//
//  HXUpdateCustomView.h
//  newHfax
//
//  Created by 张驰 on 2017/11/17.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXUpdateCustomView : UIView
@property (nonatomic,copy) void (^okAcionBlock)();
-(instancetype)initWithSubTitle:(NSString *)subTitle message:(NSString *)message isForceUpdate:(BOOL)isForceUpdate isBigVersionUpdate:(BOOL)isBigVersionUpdate;
@end
