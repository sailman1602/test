//
//  UILabel+phc_addition.h
//  p2p
//
//  Created by Philip on 9/8/15.
//  Copyright © 2015 PHSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Factory)

+ (instancetype)newWithFont:(UIFont *)font textColor:(UIColor *)textColor;

+ (instancetype)newWithFont:(UIFont *)font textColor:(UIColor *)textColor bgColor:(UIColor *)backgroundColor;

+ (instancetype)newWithFont:(UIFont *)font textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor numberOfLines:(NSUInteger)numberOfLines;

+ (instancetype)newWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor;

+ (instancetype)newWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor bgColor:(UIColor *)backgroundColor;


@end
