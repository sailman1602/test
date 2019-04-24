//
//  UIImage+phc_addition.h
//  p2p
//
//  Created by Philip on 9/7/15.
//  Copyright © 2015 PHSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    topToBottom = 0,//从上到下
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
}GradientType;

@interface UIImage (Factory)

+ (UIImage *)newWithColor:(UIColor *)color;

+ (UIImage *)newWithColor:(UIColor *)color height:(CGFloat)height;

+ (UIImage*) newWithColors:(NSArray*)colors gradientType:(GradientType)gradientType size:(CGSize)size;

- (UIImage *)fc_reszieWithsize:(CGSize)size compressionQuality:(CGFloat)compressionQuality;

//留中间，拉伸两边
+ (UIImage *)stretchLeftAndRightWithContainerSize:(CGSize)size imageName:(NSString *)imageName;
@end
