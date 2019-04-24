//
//  UIButton+Block.h
//  SymptomChecker
//
//  Created by songhe on 13-12-12.
//
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^buttonActionBlock)(void);

@interface UIButton(Block)

- (instancetype)addTouchEvent:(UIControlEvents)controlEvent withBlock:(buttonActionBlock)action;
- (instancetype)addTouchUpInsideWithTarget:(id)target selector:(SEL)selector;

- (instancetype)addTouchUpInsideWithBlock:(buttonActionBlock)action;

@property (nonatomic, copy) buttonActionBlock actionBlock;

@end
