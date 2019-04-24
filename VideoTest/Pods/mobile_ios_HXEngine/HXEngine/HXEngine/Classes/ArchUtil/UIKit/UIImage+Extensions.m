//
//  UIImage+Extensions.m
//  HealthChat3.0
//
//  Created by maomao on 12-12-4.
//  Copyright (c) 2012年 maomao. All rights reserved.
//

#import "UIImage+Extensions.h"
UIImage *create_image(CGSize size,BOOL scale,BOOL opaque,void(^block)(CGContextRef context)) {
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale?0:1);
    block(UIGraphicsGetCurrentContext());
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@implementation UIImage (Extensions)
- (UIImage *)decodedImage{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawAtPoint:CGPointZero];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)constrainedToSize:(CGSize)size scale:(BOOL)scale {
    if (self.size.width > size.width || self.size.height > size.height) {
        float sizeScale = MAX(self.size.width / size.width, self.size.height / size.height);
        size.width = self.size.width / sizeScale;
        size.height = self.size.height / sizeScale;
        return create_image(size, scale, YES, ^(CGContextRef context) {
            [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
        });
    }
    return self;
}

- (UIImage *)constrainedToSize:(CGSize)size {
    return [self constrainedToSize:size scale:NO];
}

- (UIImage *)clipToSize:(CGSize)size scale:(BOOL)scale{
    if (!CGSizeEqualToSize(self.size, size)) {
        float sizeScale = MIN(self.size.width / size.width, self.size.height / size.height);
        float width = self.size.width / sizeScale;
        float height = self.size.height / sizeScale;
        float x = (size.width - width) * 0.5f;
        float y = (size.height - height) * 0.5f;
        return create_image(size, scale, YES, ^(CGContextRef context) {
            [self drawInRect:CGRectMake(x, y, width, height)];
        });
    }
    return self;
}

- (UIImage *)clipToSize:(CGSize)size {
    return [self clipToSize:size scale:NO];
}


- (UIImage *)imageWithCornerRadius:(int)cornerRadius {
    if (cornerRadius == 0) {
        return self;
    }
    return create_image(self.size, YES, NO, ^(CGContextRef context) {
        CGRect rect = CGRectZero;
        rect.size = self.size;
        float leftX = rect.origin.x;
        float centerX = leftX + rect.size.width/2;
        float rightX = leftX + rect.size.width;
        float topY = rect.origin.y;
        float centerY = topY + rect.size.height/2;
        float bottomY = topY + rect.size.height;
        CGContextMoveToPoint(context, centerX, topY);
        CGContextAddArcToPoint(context, rightX, topY, rightX, centerY, cornerRadius);
        CGContextAddArcToPoint(context, rightX, bottomY, centerX, bottomY, cornerRadius);
        CGContextAddArcToPoint(context, leftX, bottomY, leftX, centerY, cornerRadius);
        CGContextAddArcToPoint(context, leftX, topY, centerX, topY, cornerRadius);
        CGContextClip(context);
        [self drawInRect:rect];
    });
}

- (UIImage *)mergeImage:(UIImage *)image withRect:(CGRect)rect
{
    UIImage *newImage = nil;
    if ([[UIScreen mainScreen] scale] == 2.0) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, 2.0);
    }
    else {
        UIGraphicsBeginImageContextWithOptions(self.size, NO,         1.0);
    }
    CGRect bounds = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
    [self drawInRect:bounds];
    [image drawInRect:rect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}

+ (UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength {
    UIImage *resultImage = image;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return resultImage;
}

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}

@end
