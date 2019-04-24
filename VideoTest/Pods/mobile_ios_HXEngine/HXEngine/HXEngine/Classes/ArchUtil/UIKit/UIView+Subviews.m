//
//  UIView+Subviews.m
//  CYViews
//
//  Created by songhe on 5/26/15.
//  Copyright (c) 2015 Chunyu. All rights reserved.
//

#import "UIView+Subviews.h"
#import "UIView+BFExtension.h"

@implementation UIView (Subviews)

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0, y = 0;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (UIView *)firstResponderBeneathView {
    return [UIView findFirstResponderBeneathView:self];
}

+ (UIView *)findFirstResponderBeneathView:(UIView *)view {
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) {
            return childView;
        }
        
        UIView *result = [self findFirstResponderBeneathView:childView];
        if (result) {
            return result;
        }
    }
    return nil;
}

@end
