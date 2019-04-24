//
//  UIButton+ShowLoadingIndicator.h
//  JRJInvestAdviser
//
//  Created by FarTeen on 6/17/15.
//  Copyright (c) 2015 jrj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ShowLoadingIndicator)

@property (nonatomic, assign)       BOOL                        showLoadingIndicator;
@property (nonatomic, strong)       UIActivityIndicatorView     *indicator;
- (void)buttonShowLoadingIndicator:(BOOL)isToShow;
- (void)buttonShowLoadingIndicator:(BOOL)isToShow style:(UIActivityIndicatorViewStyle)style;

@end
