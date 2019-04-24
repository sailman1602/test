//
//  UIButton+Property.h
//  SymptomChecker
//
//  Created by songhe on 14-1-8.
//
//

#import <UIKit/UIKit.h>

@interface UIButton (Property)

// normal title & color
- (instancetype)setTitle:(NSString *)title color:(UIColor *)color state:(UIControlState)state;

// image named

- (instancetype)setImageNamed:(NSString *)imageName state:(UIControlState)state;
- (instancetype)setImageNamed:(NSString *)imageName;
- (instancetype)setHighlightedImageNamed:(NSString *)imageName ;
- (instancetype)setSelectedImageNamed:(NSString *)imageName;

// back image named

- (instancetype)setBackImageNamed:(NSString *)imageName state:(UIControlState)state;
- (instancetype)setBackImageNamed:(NSString *)imageName ;
- (instancetype)setHighlightedBackImageNamed:(NSString *)imageName ;
- (instancetype)setSelectedBackImageNamed:(NSString *)imageName;

// background color
- (instancetype)setBackgroundNormalColor:(UIColor*)normalColor highLight:(UIColor*)highLightColor;

@end
