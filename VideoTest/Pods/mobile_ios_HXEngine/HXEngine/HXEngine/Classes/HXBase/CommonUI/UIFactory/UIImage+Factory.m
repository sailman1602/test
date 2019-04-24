//
//  UIImage+phc_addition.m
//  p2p
//
//  Created by Philip on 9/7/15.
//  Copyright © 2015 PHSoft. All rights reserved.
//

#import "UIImage+Factory.h"

@implementation UIImage (Factory)

+ (UIImage *)newWithColor:(UIColor *)color {
    return [self newWithColor:color height:1.0f];
}

+ (UIImage *)newWithColor:(UIColor *)color height:(CGFloat)height {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)fc_reszieWithsize:(CGSize)size compressionQuality:(CGFloat)compressionQuality;
{
    NSData *editedData = UIImageJPEGRepresentation(self, compressionQuality);
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [[UIImage imageWithData:editedData] drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

+ (UIImage*) newWithColors:(NSArray*)colors gradientType:(GradientType)gradientType size:(CGSize)size{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
            break;
        case 3:
            start = CGPointMake(size.width, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)stretchLeftAndRightWithContainerSize:(CGSize)size imageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    CGSize imageSize = image.size;
    CGSize bgSize = size;
    //1.第一次拉伸右边 保护左边
    image = [image stretchableImageWithLeftCapWidth:imageSize.width *0.7 topCapHeight:imageSize.height * 0.5];
    //第一次拉伸的距离之后图片总宽度
    CGFloat tempWidth = (bgSize.width)/2 + imageSize.width/2; UIGraphicsBeginImageContextWithOptions(CGSizeMake(tempWidth, imageSize.height), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, tempWidth, bgSize.height)];
    //拿到拉伸过的图片
    UIImage *firstStrechImage = UIGraphicsGetImageFromCurrentImageContext(); UIGraphicsEndImageContext();
    //2.第二次拉伸左边 保护右边
    UIImage *secondStrechImage = [firstStrechImage stretchableImageWithLeftCapWidth:1 topCapHeight:firstStrechImage.size.height*0.5];
    return secondStrechImage;
    
}


@end
