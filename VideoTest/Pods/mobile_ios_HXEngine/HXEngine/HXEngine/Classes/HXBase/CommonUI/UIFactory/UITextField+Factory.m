//
//  UITextField+phc_addition.m
//  p2p
//
//  Created by Philip on 9/6/15.
//  Copyright © 2015 PHSoft. All rights reserved.
//

#import "UITextField+Factory.h"
#import "HXUIDefines.h"

@implementation UITextField (Factory)

+ (instancetype)newWithFont:(UIFont *)font textColor:(UIColor *)color placeholderText:(NSString *)placeholder text:(NSString *)text {
    UITextField *textField = [[self alloc] init];
    textField.font = font;
    textField.textColor = color;
    textField.placeholder = placeholder;
    textField.text = text;
    textField.adjustsFontSizeToFitWidth = YES;
    return textField;
}

+ (instancetype)fc_defaultFieldWithPlaceholderText:(NSString *)placeholderText text:(NSString *)text {
    UITextField *textField = [self newWithFont:HXBoldFont(15) textColor:UIColorFromRGB(0x333333) placeholderText:placeholderText text:text];
    return textField;
}

@end
