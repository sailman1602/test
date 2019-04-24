//
//  UIView+Util.h
//  cyViews
//
//  Created by songhe on 8/24/15.
//  Copyright (c) 2015 Chunyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Util)

- (instancetype)cySetBackColor:(UIColor *)backColor;
- (instancetype)cySetBackHexColor:(NSInteger)hexColor;

// border

- (instancetype)cyMakeRound;

- (instancetype)cySetBorderHexColor:(NSInteger)hexColor width:(CGFloat)width cornerRadius:(CGFloat)cornerRadius; // border & corner
- (instancetype)cySetBorderColor:(UIColor *)color width:(CGFloat)width; // border
- (instancetype)cySetBorderHexColor:(NSInteger)hexColor width:(CGFloat)width; // border
- (instancetype)cySetCornerRadius:(CGFloat)cornerRadius; // corner

// return the sep, so you can config it, eg. offset it, make it shorter

- (UIView *)cyAddHSeparatorWithYOffset:(CGFloat)offset hexColor:(NSInteger)hexColor;

- (UIView *)cyAddVSeparatorWithXOffset:(CGFloat)offset hexColor:(NSInteger)hexColor;

/**
 *  @param width    line粗细
 *  @param hexColor 颜色
 *  @return separator
 */
- (UIView *)cyAddRightSeparatorWithWidth:(CGFloat)width hexColor:(NSInteger)hexColor;
- (UIView *)cyAddBottomSeparatorWithWidth:(CGFloat)width hexColor:(NSInteger)hexColor;

/**
 *  @param offset   line offset
 *  @param width    line粗细
 *  @param hexColor 颜色
 */
- (UIView *)cyAddHSeparatorWithYOffset:(CGFloat)offset width:(CGFloat)width hexColor:(NSInteger)hexColor;

- (UIView *)cyAddVSeparatorWithYOffset:(CGFloat)offset width:(CGFloat)width hexColor:(NSInteger)hexColor;

- (instancetype)cyAddShadow:(CGSize)offset radius:(CGFloat)radius hexColor:(NSInteger)hexColor opacity:(CGFloat)opacity;

// frame

- (instancetype)cyShrinkLeft:(CGFloat)left right:(CGFloat)right;
- (instancetype)cyShrinkTop:(CGFloat)top bottom:(CGFloat)bottom;

/**
 *  根据insets，向内收缩，如果对应值<0，则相当于扩张
 */
- (instancetype)cyShrink:(UIEdgeInsets)insets;

- (instancetype)cyMoveSubviewYOffset:(CGFloat)yOffset;
- (instancetype)cyMoveSubviewXOffset:(CGFloat)xOffset;

- (instancetype)cyTakeSubviewsFromView:(UIView *)view;
- (instancetype)cyGiveSubviewsToView:(UIView *)view;

- (instancetype)cySetWidth:(CGFloat)width;
- (instancetype)cySetHeight:(CGFloat)height;

- (instancetype)cySetLeft:(CGFloat)left;
- (instancetype)cySetTop:(CGFloat)top;
- (instancetype)cySetRight:(CGFloat)right;
- (instancetype)cySetBottom:(CGFloat)bottom;

- (instancetype)cySetSize:(CGSize)size;
- (instancetype)cySetFrame:(CGRect)frame;

//
- (instancetype)cyAddToSuperview:(UIView *)superview;
- (UIBarButtonItem *)cyWrapInUIBarButtonItem;

#pragma mark - snap shot

- (UIImage *)cySnapshot;

- (UIImageView *)cySnapshotAsImageView;

#pragma mark - tag query

- (UILabel *)cyLabelViewWithTag:(NSInteger)tag;

- (UIImageView *)cyImageViewWithTag:(NSInteger)tag;

- (UITextField *)cyTextFieldViewWithTag:(NSInteger)tag;

- (UIButton *)cyButtonWithTag:(NSInteger)tag;

- (UIActivityIndicatorView *)cyActivityIndicatorViewWithTag:(NSInteger)tag;

@end
