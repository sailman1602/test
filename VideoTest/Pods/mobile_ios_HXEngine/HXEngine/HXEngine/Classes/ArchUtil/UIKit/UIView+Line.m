//
//  UIView+Line.m
//  JRJInvestAdviser
//
//  Created by songhe on 11/23/15.
//  Copyright © 2015 cy. All rights reserved.
//

#import "UIView+Line.h"
#import <objc/runtime.h>

@implementation UIView (Line)
- (UIView *)topLineView
{
    return objc_getAssociatedObject(self, @selector(topLineView)) ;
}

- (void)setTopLineView:(UIView *)view
{
    objc_setAssociatedObject(self, @selector(topLineView), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)botomLineView
{
    return objc_getAssociatedObject(self, @selector(botomLineView)) ;
}

- (void)setBotomLineView:(UIView *)view
{
    objc_setAssociatedObject(self, @selector(botomLineView), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)leftLineView
{
    return objc_getAssociatedObject(self, @selector(leftLineView)) ;
}

- (void)setLeftLineView:(UIView *)view
{
    objc_setAssociatedObject(self, @selector(leftLineView), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)rightLineView
{
    return objc_getAssociatedObject(self, @selector(rightLineView)) ;
}

- (void)setRightLineView:(UIView *)view
{
    objc_setAssociatedObject(self, @selector(rightLineView), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIColor *)borderColor
{
    return [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1];
}


- (void)showLine:(LinePosition)position
{
    if (LinePositionLeft & position) {
        if (!self.leftLineView) {
            self.leftLineView = [[UIView alloc] init];
            [self setupBorder:self.leftLineView verticalFormat:@"V:|[border]|" horizontalFormat:@"H:|[border(width)]"];
        }
    }
    
    if (LinePositionRight & position) {
        if (!self.rightLineView) {
            self.rightLineView = [[UIView alloc] init];
            [self setupBorder:self.rightLineView verticalFormat:@"V:|[border]|" horizontalFormat:@"H:[border(width)]|"];
        }
    }
    
    if (LinePositionTop & position) {
        if (!self.topLineView) {
            self.topLineView = [[UIView alloc] init];
            [self setupBorder:self.topLineView verticalFormat:@"V:|[border(width)]" horizontalFormat:@"H:|[border]|"];
        }
    }

    if (LinePositionBotom & position) {
        if (!self.botomLineView) {
            self.botomLineView = [[UIView alloc] init];
             [self setupBorder:self.botomLineView verticalFormat:@"V:[border(width)]|" horizontalFormat:@"H:|[border]|"];
        }
    }
}

- (void)setupBorder:(UIView *)border verticalFormat:(NSString *)vFormat horizontalFormat:(NSString *)hFormat
{
    border.backgroundColor = self.borderColor;
    border.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:border];
    
    NSDictionary *views     = @{@"border": border};
    NSDictionary *metrics   = @{@"width": @(1.0/[UIScreen mainScreen].scale)};
    
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:vFormat options:0 metrics:metrics views:views]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:hFormat options:0 metrics:metrics views:views]];
}

- (void)showLine:(LinePosition)position andColor:(UIColor *)color{
    if (LinePositionLeft & position) {
        if (!self.leftLineView) {
            self.leftLineView = [[UIView alloc] init];
            [self setupBorder:self.leftLineView verticalFormat:@"V:|[border]|" horizontalFormat:@"H:|[border(width)]"];
            self.leftLineView.backgroundColor = color;
        }
    }
    
    if (LinePositionRight & position) {
        if (!self.rightLineView) {
            self.rightLineView = [[UIView alloc] init];
            [self setupBorder:self.rightLineView verticalFormat:@"V:|[border]|" horizontalFormat:@"H:[border(width)]|"];
            self.rightLineView.backgroundColor = color;
        }
    }
    
    if (LinePositionTop & position) {
        if (!self.topLineView) {
            self.topLineView = [[UIView alloc] init];
            [self setupBorder:self.topLineView verticalFormat:@"V:|[border(width)]" horizontalFormat:@"H:|[border]|"];
            self.topLineView.backgroundColor = color;
        }
    }
    
    if (LinePositionBotom & position) {
        if (!self.botomLineView) {
            self.botomLineView = [[UIView alloc] init];
            [self setupBorder:self.botomLineView verticalFormat:@"V:[border(width)]|" horizontalFormat:@"H:|[border]|"];
            self.botomLineView.backgroundColor = color;
        }
    }

}
@end
