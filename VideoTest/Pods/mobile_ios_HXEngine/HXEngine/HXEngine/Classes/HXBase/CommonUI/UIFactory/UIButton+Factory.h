//
//  UIButton+phc_addition.h
//  p2p
//
//  Created by Philip on 9/7/15.
//  Copyright © 2015 PHSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIButton (Factory)

+ (instancetype)newWithFont:(UIFont*)font textColor:(UIColor *)color selectedTextColor:(UIColor *)selectedColor;

+ (instancetype)newWithFont:(UIFont*)font title:(NSString *)title textColor:(UIColor *)color selectedTextColor:(UIColor *)selectedColor;

+ (instancetype)newWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage;

+ (instancetype)newWithImageStr:(NSString *)imageStr selectedImageStr:(NSString *)selectedImageStr;

+ (instancetype)newWithBgImage:(UIImage *)bgImage selectedBgImage:(UIImage *)selectedBgImage;

+ (instancetype)newWithFont:(UIFont*)font title:(NSString *)title textColor:(UIColor *)color bgImage:(UIImage *)bgImage selectedBgImage:(UIImage *)selectedBgImage;

+ (instancetype)newWithBgImageStr:(NSString *)bgImageStr selectedBgImageStr:(NSString *)selectedBgImageStr;

+ (instancetype)newWithFont:(UIFont*)font title:(NSString *)title textColor:(UIColor *)color BgColor:(UIColor *)bgColor selectedBgColor:(nullable UIColor *)selectedBgColor;

+ (instancetype)newWithFont:(UIFont*)font title:(NSString *)title textColor:(UIColor *)color selectedTextColor:(UIColor *)selectedColor titleEdgeInsets:(UIEdgeInsets)insets;

+ (UIButton *)newWithCornerFrame:(CGRect)frame title:(nullable NSString*)title CornerRadius:(float)radius borderWidth:(float)borderWidth borderColor:(UIColor *)color font:(NSInteger)fontSize normal:(UIColor*)normalColor hightlightColor:(UIColor *)ligthColor;

+ (UIButton *)newWithFrame:(CGRect)frame title:(nullable NSString*)title font:(NSInteger)fontSize  titleColor:(UIColor *)color;

+ (instancetype)fc_defaultButtonWithTitle:(NSString *)title;

- (void)setBorderColor:(UIColor *)color borderWidth:(CGFloat)width cornerRadius:(CGFloat)cornerRadius;

@end
NS_ASSUME_NONNULL_END
