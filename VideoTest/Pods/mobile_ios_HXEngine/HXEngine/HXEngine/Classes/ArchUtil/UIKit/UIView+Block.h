//
//  UIView+Block.h
//  UIKit
//
//  Created by songhe on 12/2/15.
//  Copyright © 2015 SpringRain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureActionBlock) (UIGestureRecognizer *gestrue);

@interface UIView (Block)

// tap & selector
- (UITapGestureRecognizer *)addTapGestureWithTarget:(id)target selector:(SEL)selector;

// long press & selector
- (UILongPressGestureRecognizer *)addLongPressGestureWithTarget:(id)target selector:(SEL)selector;

// tap & block
- (UITapGestureRecognizer *)addTapGestureWithActionBlock:(GestureActionBlock)actionBlock;

// long press & block
- (UILongPressGestureRecognizer *)addLongPressGestureWithActionBlock:(GestureActionBlock)actionBlock;

// tap block
@property (nonatomic, copy) GestureActionBlock tapActionBlock;
- (void)setTapActionBlock:(GestureActionBlock)TapActionBlock;

// long press block
@property (nonatomic, copy) GestureActionBlock longPressActionBlock;
- (void)setLongPressActionBlock:(GestureActionBlock)LongPressActionBlock;

@end
