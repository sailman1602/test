//
//  UIButton+phc_addition.m
//  p2p
//
//  Created by Philip on 9/7/15.
//  Copyright © 2015 PHSoft. All rights reserved.
//

#import "UIButton+Factory.h"
#import "UIImage+Factory.h"
#import "HXUIDefines.h"
#import "UIKitMacros.h"
#define FCButtonDeaultSize 14

@implementation UIButton (Factory)

+ (instancetype)newWithFont:(UIFont*)font textColor:(UIColor *)color selectedTextColor:(UIColor *)selectedColor{
    UIButton *button = [[UIButton alloc]init];
    button.titleLabel.font = font;
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [button setContentEdgeInsets:UIEdgeInsetsMake(5.0f, 15.0f, 5.0f, 15.0f)];
    [button setTitleColor:color forState:UIControlStateNormal];
    
    return button;
}

+ (instancetype)newWithFont:(UIFont*)font title:(NSString *)title textColor:(UIColor *)color selectedTextColor:(UIColor *)selectedColor{
    
    UIButton *button = [[UIButton alloc]init];
    button.titleLabel.font = font;
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    
    return button;
}

+ (instancetype)newWithBgImage:(UIImage *)backgroundImage selectedBgImage:(UIImage *)selectedBackgroundImage{
    
    UIButton *button = [[UIButton alloc]init];
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [button setContentEdgeInsets:UIEdgeInsetsMake(5.0f, 15.0f, 5.0f, 15.0f)];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
    
    return button;

}

+ (instancetype)newWithFont:(UIFont*)font title:(NSString *)title textColor:(UIColor *)color bgImage:(UIImage *)bgImage selectedBgImage:(UIImage *)selectedBgImage{
    UIButton *button = [[UIButton alloc]init];
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [button setContentEdgeInsets:UIEdgeInsetsMake(5.0f, 15.0f, 5.0f, 15.0f)];
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    [button setBackgroundImage:selectedBgImage forState:UIControlStateSelected];
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    
    return button;
}

+ (instancetype)newWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage{
    
    UIButton *button = [[UIButton alloc]init];
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    
    return button;
    
}

+ (instancetype)newWithImageStr:(NSString *)imageStr selectedImageStr:(NSString *)selectedImageStr{
    return [self newWithImage:[UIImage imageNamed:imageStr] selectedImage:[UIImage imageNamed:selectedImageStr]];
}

+ (instancetype)newWithBgImageStr:(NSString *)bgImageStr selectedBgImageStr:(NSString *)selectedBgImageStr{
    return [self newWithBgImage:[UIImage imageNamed:bgImageStr] selectedBgImage:[UIImage imageNamed:selectedBgImageStr]];
}

+ (instancetype)newWithFont:(UIFont*)font title:(NSString *)title textColor:(UIColor *)color selectedTextColor:(UIColor *)selectedColor titleEdgeInsets:(UIEdgeInsets)insets{
    
    UIButton *button = [[UIButton alloc]init];
    button.titleLabel.font = font;
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [button setContentEdgeInsets:insets];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    
    return button;
}

+ (instancetype)newWithFont:(UIFont*)font title:(NSString *)title textColor:(UIColor *)color BgColor:(UIColor *)bgColor selectedBgColor:(UIColor *)selectedBgColor{
    
    UIButton *button = [[UIButton alloc]init];
    button.titleLabel.font = font;
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage newWithColor:bgColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage newWithColor:selectedBgColor] forState:UIControlStateHighlighted];
    
    return button;
}

+ (UIButton *)newWithCornerFrame:(CGRect)frame title:(nullable NSString*)title CornerRadius:(float)radius borderWidth:(float)borderWidth borderColor:(UIColor *)color font:(NSInteger)fontSize normal:(UIColor*)normalColor hightlightColor:(UIColor *)ligthColor {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBorderColor:color borderWidth:borderWidth cornerRadius:radius];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = HXFont(fontSize);
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:ligthColor forState:UIControlStateHighlighted];
    return button;
}

+ (UIButton *)newWithFrame:(CGRect)frame title:(nullable NSString*)title font:(NSInteger)fontSize  titleColor:(UIColor *)color {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitleColor:RGBCOLOR_HEX(0x000000) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = HXFont(fontSize);
    [button setTitleColor:color forState:UIControlStateNormal];
    [button.titleLabel sizeToFit];
    button.size = button.titleLabel.size;
    return button;
}

+ (instancetype)fc_defaultButtonWithTitle:(NSString *)title {
    UIButton *button = [self newWithFont:HXBoldFont(FCButtonDeaultSize) title:title textColor:HXFontColor BgColor:HXButtonBGColor selectedBgColor:nil];
    return button;
}

- (void)setBorderColor:(UIColor *)color borderWidth:(CGFloat)width cornerRadius:(CGFloat)cornerRadius{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

@end
