
//
//  UIButton+ShowLoadingIndicator.m
//  JRJInvestAdviser
//
//  Created by FarTeen on 6/17/15.
//  Copyright (c) 2015 jrj. All rights reserved.
//

#import "UIButton+ShowLoadingIndicator.h"
#import <objc/runtime.h>

static const char *UIBUTTON_SHOW_LOADING_INDICATOR_BOOL_FLAG = "";
static const char *UIBUTTON_SHOW_LOADING_INDICATOR_VIEW_FLAG = "";

@implementation UIButton (ShowLoadingIndicator)

- (void)setShowLoadingIndicator:(BOOL)showLoadingIndicator
{
    objc_setAssociatedObject(self, UIBUTTON_SHOW_LOADING_INDICATOR_BOOL_FLAG, @(showLoadingIndicator), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)showLoadingIndicator
{
    return [objc_getAssociatedObject(self, UIBUTTON_SHOW_LOADING_INDICATOR_BOOL_FLAG) boolValue];
}

- (void)setIndicator:(UIActivityIndicatorView *)indicator
{
    objc_setAssociatedObject(self, UIBUTTON_SHOW_LOADING_INDICATOR_VIEW_FLAG, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)indicator
{
    return objc_getAssociatedObject(self, UIBUTTON_SHOW_LOADING_INDICATOR_VIEW_FLAG);
}

- (void)buttonShowLoadingIndicator:(BOOL)isToShow
{
    [self buttonShowLoadingIndicator:isToShow style:UIActivityIndicatorViewStyleGray];
}

- (void)buttonShowLoadingIndicator:(BOOL)isToShow style:(UIActivityIndicatorViewStyle)style
{
    if (isToShow) {
        if (!self.indicator) {
            self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
            self.indicator.frame = self.frame;
            self.indicator.hidesWhenStopped = YES;
        }
        self.hidden = YES;
        self.indicator.hidden = NO;
        [self.indicator startAnimating];
        [self.superview addSubview:self.indicator];
    } else {
        [self.indicator removeFromSuperview];
        self.hidden = NO;
    }
}

@end
