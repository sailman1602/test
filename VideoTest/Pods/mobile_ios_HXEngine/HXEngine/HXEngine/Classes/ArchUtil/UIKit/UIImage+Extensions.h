//
//  UIImage+Extensions.h
//  HealthChat3.0
//
//  Created by maomao on 12-12-4.
//  Copyright (c) 2012年 maomao. All rights reserved.
//

#import <UIKit/UIKit.h>

UIImage *create_image(CGSize size,BOOL scale,BOOL opaque,void(^block)(CGContextRef context));

@interface UIImage (Extensions)
- (UIImage *)decodedImage;
- (UIImage *)constrainedToSize:(CGSize)size;
- (UIImage *)clipToSize:(CGSize)size;
- (UIImage *)constrainedToSize:(CGSize)size scale:(BOOL)scale;
- (UIImage *)clipToSize:(CGSize)size scale:(BOOL)scale;
- (UIImage *)imageWithCornerRadius:(int)cornerRadius;
- (UIImage *)mergeImage:(UIImage *)image withRect:(CGRect)rect;
//- (UIImage *)snapImage;

//压缩图片质量 二分法
+ (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength;
//压缩图片尺寸
+ (UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength;
//压缩质量+尺寸
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;
@end


