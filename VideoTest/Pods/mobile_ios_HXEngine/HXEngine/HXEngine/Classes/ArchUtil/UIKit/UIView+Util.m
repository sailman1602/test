//
//  UIView+Util.m
//  cyViews
//
//  Created by songhe on 8/24/15.
//  Copyright (c) 2015 Chunyu. All rights reserved.
//

#import "UIView+Util.h"
#import "UIView+Factory.h"
#import "UIKitMacros.h"
#import "UIView+BFExtension.h"


@implementation UIView (Util)

- (instancetype)cySetBackColor:(UIColor *)backColor {
    self.backgroundColor = backColor;
    return self;
}

- (instancetype)cySetBackHexColor:(NSInteger)hexColor {
    return [self cySetBackColor:RGBCOLOR_HEX(hexColor)];
}

#pragma mark - border

- (instancetype)cyMakeRound {
    return [self cySetCornerRadius:self.height / 2];
}

- (instancetype)cySetBorderHexColor:(NSInteger)hexColor width:(CGFloat)width cornerRadius:(CGFloat)cornerRadius {
    [self cySetCornerRadius:cornerRadius];
    
    return [self cySetBorderHexColor:hexColor width:width];
}

- (instancetype)cySetBorderHexColor:(NSInteger)hexColor width:(CGFloat)width {
    return [self cySetBorderColor:RGBCOLOR_HEX(hexColor) width:width];
}

- (instancetype)cySetBorderColor:(UIColor *)color width:(CGFloat)width {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    return self;
}

- (instancetype)cySetCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
    return self;
}

#pragma mark - line

- (UIView *)cyLineWithSize:(CGSize)size color:(UIColor *)color {
    return [[self class] cyLineWithSize:size color:color];
}

- (UIView *)cyAddHSeparatorWithYOffset:(CGFloat)offset hexColor:(NSInteger)hexColor {
    return [self cyAddHSeparatorWithYOffset:offset width:0.5 hexColor:hexColor];
}

- (UIView *)cyAddVSeparatorWithXOffset:(CGFloat)offset hexColor:(NSInteger)hexColor {
    return [self cyAddVSeparatorWithYOffset:offset width:0.5 hexColor:hexColor];
}

- (UIView *)cyAddRightSeparatorWithWidth:(CGFloat)width hexColor:(NSInteger)hexColor {
    return [self cyAddVSeparatorWithYOffset:self.width - width width:width hexColor:hexColor];
}

- (UIView *)cyAddBottomSeparatorWithWidth:(CGFloat)width hexColor:(NSInteger)hexColor {
    return [self cyAddHSeparatorWithYOffset:self.height - width width:width hexColor:hexColor];
}

- (UIView *)cyAddHSeparatorWithYOffset:(CGFloat)offset width:(CGFloat)width hexColor:(NSInteger)hexColor {
    UIView *v = [self cyLineWithSize:CGSizeMake(self.width, width) color:rgbaFromHex(hexColor, 1.0)];
    v.top = offset;
    [self addSubview:v];
    return v;
}

- (UIView *)cyAddVSeparatorWithYOffset:(CGFloat)offset width:(CGFloat)width hexColor:(NSInteger)hexColor {
    UIView *v = [self cyLineWithSize:CGSizeMake(width, self.height) color:rgbaFromHex(hexColor, 1.0)];
    v.left = offset;
    [self addSubview:v];
    return v;
}

- (instancetype)cyAddShadow:(CGSize)offset radius:(CGFloat)radius hexColor:(NSInteger)hexColor opacity:(CGFloat)opacity {
    self.layer.shadowColor = RGBCOLOR_HEX(hexColor).CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    return self;
}

#pragma mark - frame

- (instancetype)cyShrink:(UIEdgeInsets)insets {
    self.left += insets.left;
    self.top += insets.top;
    self.width -= insets.left + insets.right;
    self.height -= insets.top + insets.bottom;
    
    return self;
}

- (instancetype)cyShrinkLeft:(CGFloat)left right:(CGFloat)right {
    return [self cyShrink:UIEdgeInsetsMake(0, left, 0, right)];
}

- (instancetype)cyShrinkTop:(CGFloat)top bottom:(CGFloat)bottom {
    return [self cyShrink:UIEdgeInsetsMake(top, 0, bottom, 0)];
}

- (instancetype)cyTakeSubviewsFromView:(UIView *)view {
    for (UIView *v in view.subviews) {
        [self addSubview:v];
    }
    return self;
}

- (instancetype)cyGiveSubviewsToView:(UIView *)view {
    return [view cyTakeSubviewsFromView:self];
}

- (instancetype)cyMoveSubviewYOffset:(CGFloat)yOffset {
    for (UIView *v in self.subviews) {
        v.top += yOffset;
    }
    return self;
}

- (instancetype)cyMoveSubviewXOffset:(CGFloat)xOffset {
    for (UIView *v in self.subviews) {
        v.left += xOffset;
    }
    return self;
}

- (instancetype)cyMoveSubviewWithOffset:(CGPoint)offset {
    for (UIView *v in self.subviews) {
        v.left += offset.x;
        v.top += offset.y;
    }
    return self;
}

- (instancetype)cySetWidth:(CGFloat)width {
    self.width = width;
    return self;
}

- (instancetype)cySetHeight:(CGFloat)height {
    self.height = height;
    return self;
}

- (instancetype)cySetLeft:(CGFloat)left {
    self.left = left;
    return self;
}

- (instancetype)cySetRight:(CGFloat)right {
    self.right = right;
    return self;
}

- (instancetype)cySetTop:(CGFloat)top {
    self.top = top;
    return self;
}

- (instancetype)cySetBottom:(CGFloat)bottom {
    self.bottom = bottom;
    return self;
}

- (instancetype)cySetSize:(CGSize)size {
    self.size = size;
    return self;
}

- (instancetype)cySetFrame:(CGRect)frame {
    self.frame = frame;
    return self;
}

#pragma mark - 

- (instancetype)cyAddToSuperview:(UIView *)superview {
    [superview addSubview:self];
    return self;
}

- (UIBarButtonItem *)cyWrapInUIBarButtonItem {
    return [[UIBarButtonItem alloc] initWithCustomView:self];
}

#pragma mark - snapshot

- (UIImage *)cySnapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImageView *)cySnapshotAsImageView {
    UIImageView *iv = [[UIImageView alloc] initWithImage:[self cySnapshot]];
    return iv;
}

#pragma mark - tag query

- (UILabel *)cyLabelViewWithTag:(NSInteger)tag {
    return (UILabel *)[self viewWithTag: tag];
}

- (UIImageView *)cyImageViewWithTag:(NSInteger)tag {
    return (UIImageView *)[self viewWithTag: tag];
}

- (UITextField *)cyTextFieldViewWithTag:(NSInteger)tag {
    return (UITextField *)[self viewWithTag: tag];
}

- (UIButton *)cyButtonWithTag:(NSInteger)tag {
    return (UIButton *)[self viewWithTag: tag];
}

- (UIActivityIndicatorView *)cyActivityIndicatorViewWithTag:(NSInteger)tag {
    return (UIActivityIndicatorView *)[self viewWithTag: tag];
}

@end
