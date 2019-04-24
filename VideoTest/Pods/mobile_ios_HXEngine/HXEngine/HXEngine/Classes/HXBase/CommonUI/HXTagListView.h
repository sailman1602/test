//
//  HXTagListView.h
//  newHfax
//
//  Created by lly on 2017/12/5.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXTagListView : UIView

@property (nonatomic,assign) CGFloat maxWidth;

+(instancetype)newWithCount:(NSInteger)count space:(CGFloat)space font:(UIFont *)font textColor:(UIColor *)textColor;

+(instancetype)newWithCount:(NSInteger)count space:(CGFloat)space font:(UIFont *)font borderColor:(UIColor *)borderColor textColor:(UIColor *)textColor;

+(instancetype)newWithLabelCount:(NSInteger)labelCount space:(CGFloat)space font:(UIFont *)font textColor:(UIColor *)textColor imageCount:(NSInteger)imageCount;

- (void)setTextColor:(UIColor *)textColor;
- (void)setTextColor:(UIColor *)textColor atIndex:(NSInteger)index;
- (void)setBorderColor:(UIColor *)borderColor atIndex:(NSInteger)index;
- (void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth atIndex:(NSInteger)index;

- (void)setBgColor:(UIColor *)bgColor;
- (void)setBgColor:(UIColor *)bgColor atIndex:(NSInteger)index;

- (void)setText:(NSString *)text atIndex:(NSInteger)index;

- (void)setTexts:(NSArray <NSString *> *)textArray;
- (void)setTexts:(NSArray <NSString *> *)textArray bgColors:(NSArray <UIColor *> *)bgColors;
- (void)setTexts:(NSArray <NSString *> *)textArray bgColors:(NSArray <UIColor *> *)bgColors imageStrings:(NSArray <NSString *> *)imageStrings;

- (CGFloat)realWidth;
@end
