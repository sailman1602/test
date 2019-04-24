//
//  UITextField+Border.h
//  JRJInvestAdviser
//
//  Created by songhe on 16/6/11.
//  Copyright © 2016年 jrj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Border)

+ (UITextField *)textFieldWithCornerFrame:(CGRect)frame title:(nullable NSString* )title CornerRadius:(float)radius borderWidth:(float)borderWidth borderColor:(UIColor *)borderColor font:(NSInteger)fontSize textColor:(UIColor*)textColor placeholder:(nullable NSString *)placeholder;

+ (UITextField *)textFieldWithFrame:(CGRect)frame title:(nullable NSString *)title font:(NSInteger)fontSize textColor:(UIColor *)textColor placeholder:(nullable NSString *)placeholder;

@end

NS_ASSUME_NONNULL_END