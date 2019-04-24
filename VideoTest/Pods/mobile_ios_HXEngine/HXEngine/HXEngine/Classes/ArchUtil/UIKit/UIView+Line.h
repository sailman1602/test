//
//  UIView+Line.h
//  JRJInvestAdviser
//
//  Created by songhe on 11/23/15.
//  Copyright © 2015 cy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum LinePosition
{
    LinePositionTop = 1 << 0,
    LinePositionBotom = 1 << 1,
    LinePositionLeft = 1 << 2,
    LinePositionRight = 1 << 3,
}LinePosition;

@interface UIView (Line)

@property (nonatomic, readonly) UIView *leftLineView;
@property (nonatomic, readonly) UIView *rightLineView;
@property (nonatomic, readonly) UIView *topLineView;
@property (nonatomic, readonly) UIView *botomLineView;

- (void)showLine:(LinePosition)position;
- (void)showLine:(LinePosition)position andColor:(UIColor*)color;
@end
