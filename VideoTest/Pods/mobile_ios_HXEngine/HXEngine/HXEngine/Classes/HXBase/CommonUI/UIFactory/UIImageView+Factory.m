//
//  UIImageView+Factory.m
//  newHfax
//
//  Created by lly on 2017/7/21.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "UIImageView+Factory.h"

@implementation UIImageView (Factory)

+ (instancetype)newWithImageName:(NSString *)imageName {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
}

+ (instancetype)newWithImageName:(NSString *)imageName frame:(CGRect)frame {
    UIImageView *iv = [self newWithImageName:imageName];
    iv.frame = frame;
    return iv;
}

+ (instancetype)newWithImageName:(NSString *)imageName
                   hightLightImageName:(NSString *)hightLightName
                                 frame:(CGRect)frame {
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName] highlightedImage:[UIImage imageNamed:hightLightName]];
    iv.frame = frame;
    return iv;
}

+ (instancetype)newWithImage:(UIImage *)image frame:(CGRect)frame {
    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
    iv.frame = frame;
    return iv;
}

+ (instancetype)newWithImage:(UIImage *)image {
    return [[UIImageView alloc] initWithImage:image];
}

+ (instancetype)newWithImageName:(NSString *)imageName capWidth:(CGFloat)capWidth capHeight:(CGFloat)capHeight {
    UIImage *image = [UIImage imageNamed:imageName];
    NSAssert(image, @"image %@ does not exist", imageName);
    
    image = [image stretchableImageWithLeftCapWidth:capWidth topCapHeight:capHeight];
    return [UIImageView newWithImage:image];
}

+ (instancetype)newWithImageName:(NSString *)imageName capWidth:(CGFloat)capWidth capHeight:(CGFloat)capHeight frame:(CGRect)frame {
    UIImageView *iv = [self newWithImageName:imageName capWidth:capWidth capHeight:capHeight];
    iv.frame = frame;
    return iv;
}

@end
