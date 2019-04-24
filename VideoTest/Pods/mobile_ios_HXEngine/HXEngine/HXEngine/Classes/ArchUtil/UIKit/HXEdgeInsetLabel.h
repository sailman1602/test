//
//  HXEdgeInsetLabel.h
//  newHfax
//
//  Created by sh on 2017/10/18.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXEdgeInsetLabel : UILabel
@property (assign, nonatomic) UIEdgeInsets edgeInsets;

+ (instancetype)newWithFont:(UIFont *)font textColor:(UIColor *)textColor bgColor:(UIColor *)color ;
@end
