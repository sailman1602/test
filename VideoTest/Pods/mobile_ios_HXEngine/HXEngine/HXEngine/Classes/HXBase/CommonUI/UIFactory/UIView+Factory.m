//
//  UIView+phc_addition.m
//  p2p
//
//  Created by Philip on 9/7/15.
//  Copyright © 2015 PHSoft. All rights reserved.
//

#import "UIView+Factory.h"
#import "UIView+Util.h"
#import <Masonry/Masonry.h>

static const NSUInteger kBorderViewTag = 12345;

@implementation UIView (Factory)

- (UIView *)fc_configureBottomBorderWithHeight:(CGFloat)height color:(UIColor *)color {
    UIView *borderView = [UIView new];
    borderView.tag = kBorderViewTag;
    borderView.backgroundColor = color;
    
    [self addSubview:borderView];
    
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).with.offset(-3.0f);
        make.width.equalTo(self.mas_width).with.multipliedBy(0.7f);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(height));
    }];
    
    return borderView;
}

- (UIView *)fc_configureTopBorderWithHeight:(CGFloat)height color:(UIColor *)color {
    UIView *borderView = [UIView new];
    borderView.tag = kBorderViewTag;
    borderView.backgroundColor = color;
    
    [self addSubview:borderView];
    
    typeof(self) __weak weakSelf = self;
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.width.equalTo(weakSelf.mas_width);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.height.equalTo(@(height));
    }];
    
    return borderView;
}

- (UIView *)fc_configureLeftBorderWithWidth:(CGFloat)width color:(UIColor *)color {
    UIView *borderView = [UIView new];
    borderView.tag = kBorderViewTag;
    borderView.backgroundColor = color;
    
    [self addSubview:borderView];
    
    typeof(self) __weak weakSelf = self;
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.height.equalTo(weakSelf.mas_height);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.equalTo(@(width));
    }];
    
    return borderView;
}

- (UIView *)fc_configureRightBorderWithWidth:(CGFloat)width color:(UIColor *)color {
    UIView *borderView = [UIView new];
    borderView.tag = kBorderViewTag;
    borderView.backgroundColor = color;
    
    [self addSubview:borderView];
    
    typeof(self) __weak weakSelf = self;
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right);
        make.height.equalTo(weakSelf.mas_height);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.equalTo(@(width));
    }];
    
    return borderView;
}

- (void)fc_setBorderColor:(UIColor *)color {
    UIView *borderView = [self viewWithTag:kBorderViewTag];
    borderView.backgroundColor = color;
}

+ (UIView *)fc_lineWithSize:(CGSize)size color:(UIColor *)color{
    UIView *v = [UIView fc_viewWithFrame:CGRectMake(0, 0, size.width, size.height) backColor:color];
    return v;
}

+ (instancetype)fc_lineWithPattern:(NSString *)name width:(NSInteger)width height:(NSInteger)height{
    return [self fc_lineWithSize:CGSizeMake(width, height) color:[UIColor colorWithPatternImage:[UIImage imageNamed:name]]];
}

+ (instancetype)fc_roundView:(CGFloat)radius{
    UIView *v = [[self alloc] initWithFrame:CGRectMake(0, 0, radius * 2, radius * 2)];
    [v cyMakeRound];
    return v;
}

+ (instancetype)fc_roundViewWithDiameter:(CGFloat)diameter{
    return [self roundView:diameter / 2];
}

+ (instancetype)roundView:(CGFloat)radius {
    UIView *v = [[self alloc] initWithFrame:CGRectMake(0, 0, radius * 2, radius * 2)];
    [v cyMakeRound];
    return v;
}
+ (instancetype )fc_viewWithFrame:(CGRect)frame backColor:(UIColor *)backColor {
    UIView *v = [[self alloc] initWithFrame:frame];
    v.backgroundColor = backColor;
    return v;
}

@end
