//
//  UITextField+phc_addition.h
//  p2p
//
//  Created by Philip on 9/6/15.
//  Copyright © 2015 PHSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Factory)

+ (instancetype)newWithFont:(UIFont *)font textColor:(UIColor *)color placeholderText:(NSString *)placeholder text:(NSString *)text;

+ (instancetype)fc_defaultFieldWithPlaceholderText:(NSString *)placeholderText text:(NSString *)text;

@end
