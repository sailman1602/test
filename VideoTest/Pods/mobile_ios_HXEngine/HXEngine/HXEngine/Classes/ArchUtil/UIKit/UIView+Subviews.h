//
//  UIView+Subviews.h
//  CYViews
//
//  Created by songhe on 5/26/15.
//  Copyright (c) 2015 Chunyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  NOTE:
 *      1. These features are derived from previous project
 *      2. !!!!DO NOT USE!!!! these features, if you need these features, your may need to recheck your design.
 */

@interface UIView (Subviews)

- (void)removeAllSubviews;

- (CGPoint)offsetFromView:(UIView*)otherView;

/**
 *  return which controller current view is in
 */
- (UIViewController *)viewController;

- (UIView *)firstResponderBeneathView;

+ (UIView *)findFirstResponderBeneathView:(UIView *)view;

@end
