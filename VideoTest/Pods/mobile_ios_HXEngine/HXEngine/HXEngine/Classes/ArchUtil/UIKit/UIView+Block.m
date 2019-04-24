//
//  UIView+Block.m
//  UIKit
//
//  Created by songhe on 12/2/15.
//  Copyright © 2015 SpringRain. All rights reserved.
//

#import "UIView+Block.h"
#import <objc/runtime.h>
#import "UIKitMacros.h"

@implementation UIView (Block)

// tap
- (UITapGestureRecognizer *)addTapGestureWithTarget:(id)target selector:(SEL)selector {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    return tap;
}

// long press
- (UILongPressGestureRecognizer *)addLongPressGestureWithTarget:(id)target selector:(SEL)selector {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:selector];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:longPress];
    return longPress;
}

#pragma mark - long press block

- (UILongPressGestureRecognizer *)addLongPressGestureWithActionBlock:(GestureActionBlock)actionBlock {
    assert(self.longPressActionBlock == nil);
    if (self.longPressActionBlock != nil) return nil;
    
    self.LongPressActionBlock = actionBlock;
    return [self addLongPressGestureWithTarget:self selector:@selector(longPressSelector:)];
}

- (void)longPressSelector:(UIGestureRecognizer *)gesture {
    safe_block(self.longPressActionBlock, gesture);
}

// set
- (void)setLongPressActionBlock:(GestureActionBlock)LongPressActionBlock {
    objc_setAssociatedObject(self, @selector(longPressActionBlock), LongPressActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// get
- (GestureActionBlock)longPressActionBlock {
    return objc_getAssociatedObject(self, @selector(longPressActionBlock));
}

#pragma mark - tap block

- (UITapGestureRecognizer *)addTapGestureWithActionBlock:(GestureActionBlock)actionBlock {
    assert(self.tapActionBlock == nil);
    if (self.tapActionBlock != nil) return nil;
    
    self.TapActionBlock = actionBlock;
    return [self addTapGestureWithTarget:self selector:@selector(tapGestureSelector:)];
}

- (void)tapGestureSelector:(UIGestureRecognizer *)gestrue {
    safe_block(self.tapActionBlock, gestrue);
}

// set
- (void)setTapActionBlock:(GestureActionBlock)TapActionBlock {
    objc_setAssociatedObject(self, @selector(tapActionBlock), TapActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// get
- (GestureActionBlock)tapActionBlock {
    return objc_getAssociatedObject(self, @selector(tapActionBlock));
}

@end
