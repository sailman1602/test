//
//  UIButton+Block.m
//  SymptomChecker
//
//  Created by songhe on 13-12-12.
//
//
/**
 *  用overViewKey进行属性扩展，保存block
 */

#import "UIButton+Block.h"
#import "UIKitMacros.h"

@implementation UIButton(Block)

- (instancetype)addTouchEvent:(UIControlEvents)controlEvent withBlock:(buttonActionBlock)action {
    assert(self.actionBlock == nil);
    
    self.actionBlock = action;
    
    [self addTarget:self action:@selector(touchEventSelector:) forControlEvents:controlEvent];
    
    return self;
}

- (instancetype)addTouchUpInsideWithTarget:(id)target selector:(SEL)selector {
    [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (instancetype)addTouchUpInsideWithBlock:(buttonActionBlock)action {
    return [self addTouchEvent:UIControlEventTouchUpInside withBlock:action];
}

- (void)touchEventSelector:(id)sender {
    safe_block(self.actionBlock);
}

- (buttonActionBlock)actionBlock {
    return objc_getAssociatedObject(self, @selector(actionBlock));
}

- (void)setActionBlock:(buttonActionBlock)actionBlock{
    objc_setAssociatedObject(self, @selector(actionBlock), actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
