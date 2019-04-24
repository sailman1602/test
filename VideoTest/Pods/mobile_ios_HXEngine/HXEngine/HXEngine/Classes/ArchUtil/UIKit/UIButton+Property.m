//
//  UIButton+Property.m
//  SymptomChecker
//
//  Created by songhe on 14-1-8.
//
//

#import "UIButton+Property.h"
#import "UIKitMacros.h"
#import "UIImage+Factory.h"

@implementation UIButton (Property)


// normal title & color
- (instancetype)setTitle:(NSString *)title color:(UIColor *)color state:(UIControlState)state {
    [self setTitle:title forState:state];
    [self setTitleColor:color forState:state];
    return self;
}

// image named

- (instancetype)setImageNamed:(NSString *)imageName state:(UIControlState)state {
    [self setImage:[UIImage imageNamed:imageName] forState:state];
    return self;
}

- (instancetype)setImageNamed:(NSString *)imageName {
    return [self setImageNamed:imageName state:UIControlStateNormal];
}

- (instancetype)setHighlightedImageNamed:(NSString *)imageName {
    return [self setImageNamed:imageName state:UIControlStateHighlighted];
}

- (instancetype)setSelectedImageNamed:(NSString *)imageName {
    return [self setImageNamed:imageName state:UIControlStateSelected];
}

// back image named

- (instancetype)setBackImageNamed:(NSString *)imageName state:(UIControlState)state {
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:state];
    return self;
}

- (instancetype)setBackImageNamed:(NSString *)imageName {
    return [self setBackImageNamed:imageName state:UIControlStateNormal];
}

- (instancetype)setHighlightedBackImageNamed:(NSString *)imageName {
    return [self setBackImageNamed:imageName state:UIControlStateHighlighted];
}

- (instancetype)setSelectedBackImageNamed:(NSString *)imageName {
    return [self setBackImageNamed:imageName state:UIControlStateSelected];
}

- (instancetype)setBackgroundNormalColor:(UIColor*)normalColor highLight:(UIColor*)highLightColor{
    [self setBackgroundImage:[UIImage newWithColor:normalColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage newWithColor:highLightColor] forState:UIControlStateHighlighted];
    return self;
}

@end
