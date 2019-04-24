//
//  UITextField+Border.m
//  JRJInvestAdviser
//
//  Created by songhe on 16/6/11.
//  Copyright © 2016年 jrj. All rights reserved.
//

#import "UITextField+Border.h"
#import "HXUIDefines.h"

@implementation UITextField (Border)

+ (UITextField *)textFieldWithCornerFrame:(CGRect)frame title:(NSString*)title CornerRadius:(float)radius borderWidth:(float)borderWidth borderColor:(UIColor *)borderColor font:(NSInteger)fontSize textColor:(UIColor*)textColor placeholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];// - STOCK_NAME_WIDTH - 10.0
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = textColor;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.font = [UIFont systemFontOfSize:fontSize];
    textField.placeholder = placeholder;
    textField.clearButtonMode = UITextFieldViewModeNever;
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = radius;
    textField.layer.borderWidth = borderWidth;
    textField.layer.borderColor = borderColor.CGColor;
    return textField;
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame title:(NSString *)title font:(NSInteger)fontSize textColor:(UIColor *)textColor placeholder:(NSString *)placeholder{
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = textColor;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.font = HXFont(fontSize);
    textField.placeholder = placeholder;
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    return textField;
}
@end
