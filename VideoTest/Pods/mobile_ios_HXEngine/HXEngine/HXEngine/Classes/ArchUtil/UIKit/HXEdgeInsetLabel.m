//
//  HXEdgeInsetLabel.m
//  newHfax
//  内边距lable
//  Created by sh on 2017/10/18.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXEdgeInsetLabel.h"

@implementation HXEdgeInsetLabel

- (instancetype)init {
    if (self = [super init]) {
        self.edgeInsets = UIEdgeInsetsMake(1, 5, 1, 5);
    }
    return self;
}

+ (instancetype)newWithFont:(UIFont *)font textColor:(UIColor *)textColor bgColor:(UIColor *)color {
    HXEdgeInsetLabel *label = [HXEdgeInsetLabel new];
    label.textColor = textColor;
    [label setFont:font];
    label.backgroundColor = color ? color : [UIColor whiteColor];
    return label;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

// 修改绘制文字的区域，edgeInsets增加bounds
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds,self.edgeInsets) limitedToNumberOfLines:numberOfLines];
    //根据edgeInsets，修改绘制文字的bounds
    rect.origin.x += self.edgeInsets.left;
    rect.origin.y += self.edgeInsets.top;
    rect.size.width += self.edgeInsets.left + self.edgeInsets.right;
    rect.size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return rect;
}

@end
