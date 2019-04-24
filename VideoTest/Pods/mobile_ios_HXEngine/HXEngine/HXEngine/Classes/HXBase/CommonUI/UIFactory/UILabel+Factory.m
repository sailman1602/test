//
//  UILabel+phc_addition.m
//  p2p
//
//  Created by Philip on 9/8/15.
//  Copyright © 2015 PHSoft. All rights reserved.
//

#import "UILabel+Factory.h"

@implementation UILabel (Factory)

+ (instancetype)newWithFont:(UIFont *)font textColor:(UIColor *)textColor{
    return [self newWithText:nil font:font textColor:textColor];
}

+ (instancetype)newWithFont:(UIFont *)font textColor:(UIColor *)textColor bgColor:(UIColor *)backgroundColor{
    UILabel *label = [UILabel new];
    label.font = font;
    label.textColor = textColor;
    label.layer.backgroundColor = (backgroundColor.CGColor) ? : [UIColor clearColor].CGColor;
    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    return label;
}


+ (instancetype)newWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor{
    UILabel *l = [self newWithFont:font textColor:textColor bgColor:nil];
    l.text = text;
    return l;
}

+ (instancetype)newWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor bgColor:(UIColor *)backgroundColor{
    UILabel *l = [self newWithFont:font textColor:textColor bgColor:backgroundColor];
    l.text = text;
    return l;
}


+ (instancetype)newWithFont:(UIFont *)font textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor numberOfLines:(NSUInteger)numberOfLines {
    UILabel *label = [UILabel new];
    label.font = font;
    label.textColor = textColor;
    label.layer.backgroundColor = (bgColor.CGColor) ? : [UIColor clearColor].CGColor;
    label.numberOfLines = numberOfLines;
    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    return label;
}

@end
