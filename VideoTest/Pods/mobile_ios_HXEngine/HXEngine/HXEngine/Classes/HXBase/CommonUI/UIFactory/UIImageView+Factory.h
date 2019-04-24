//  UIImageView+Factory.h
//  CYViews
//
//  Created by songhe on 5/26/15.
//  Copyright (c) 2015 Chunyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma clang diagnostic ignored "-Wdocumentation"

@interface UIImageView (Factory)

/**
 *  创建imageView
 *
 imageName
 frame
 */
+ (instancetype)newWithImageName:(NSString *)imageName;
+ (instancetype)newWithImageName:(NSString *)imageName
                                 frame:(CGRect)frame;

+ (instancetype)newWithImageName:(NSString *)imageName
                   hightLightImageName:(NSString *)hightLightName
                                 frame:(CGRect)frame;

/**
 *  创建imageView
 *
 *  @param image
 *  @param frame
 */
+ (instancetype)newWithImage:(UIImage *)image frame:(CGRect)frame;
+ (instancetype)newWithImage:(UIImage *)image;

/**
 *  创建imageView
 *
 *  @param imageName
 *  @param capWidth
 *  @param capHeight
 */
+ (instancetype)newWithImageName:(NSString *)imageName
                              capWidth:(CGFloat)capWidth
                             capHeight:(CGFloat)capHeight;

/**
 *  创建imageView
 *
 *  @param imageName
 *  @param capWidth  水平拉伸的位置
 *  @param capHeight 垂直拉伸的位置
 *  @param frame
 */
+ (instancetype)newWithImageName:(NSString *)imageName
                              capWidth:(CGFloat)capWidth
                             capHeight:(CGFloat)capHeight
                                 frame:(CGRect)frame;

@end
