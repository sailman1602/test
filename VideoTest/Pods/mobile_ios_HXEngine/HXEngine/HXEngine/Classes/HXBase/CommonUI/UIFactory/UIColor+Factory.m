//
//  UIColor+phc_addition.m
//  p2p
//
//  Created by Philip on 10/16/15.
//  Copyright © 2015 PHSoft. All rights reserved.
//

#import "UIColor+Factory.h"

@implementation UIColor (phc_addition)

+ (UIColor*)colorWithARGB:(NSUInteger)argb
{
    CGFloat alpha = (argb > 0xFFFFFF) ? (((argb>>24)&0xFF)/255.0f) : 1.0f;
    return [UIColor colorWithRGB:argb alpha:alpha];
}

+ (UIColor *)colorWithRGB:(NSUInteger)rgb;
{
    return [UIColor colorWithRGB:rgb alpha:1.0f];
}

+ (UIColor*)colorWithRGB:(NSUInteger)rgb alpha:(CGFloat)alpha
{
    NSUInteger red = (rgb>>16)&0xFF;
    NSUInteger green = (rgb>>8)&0xFF;
    NSUInteger blue = rgb&0xFF;
    return RGBA(red, green, blue, alpha);
}

+ (UIColor*)colorWithString:(NSString *)strColor
{
    NSArray* colorValueArr = [strColor componentsSeparatedByString:@"|"];
    if (colorValueArr.count < 3 || colorValueArr.count > 4) {
        return nil;
    }
    
    NSUInteger red = [[colorValueArr objectAtIndex:0] integerValue];
    NSUInteger green = [[colorValueArr objectAtIndex:1] integerValue];
    NSUInteger blue = [[colorValueArr objectAtIndex:2] integerValue];
    CGFloat alpha = 1.0f;
    if (colorValueArr.count == 4) {
        alpha = [[colorValueArr objectAtIndex:3] floatValue];
    }
    return RGBA(red, green, blue, alpha);
}

+ (UIColor *)phc_orange {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xF7574A);
    });
    
    return color;
}

+ (UIColor *)phc_gray {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xAEBAC6);
    });
    
    return color;
}

+ (UIColor *)phc_lightGray {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xf7f7f7);
    });
    
    return color;
}

+ (UIColor *)phc_lightOrange {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xE3835B);
    });
    
    return color;
}

@end
