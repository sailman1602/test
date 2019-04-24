//
//  HXUserCase.m
//  newHfax
//
//  Created by lly on 2017/6/30.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXUserCase.h"
#import "HXModule.h"
#import "HXUserCaseManager.h"
#import "UIKitMacros.h"

@interface HXUserCase(){
    BOOL isOpen;
}

@end

@implementation HXUserCase


- (void)open{
    if(isOpen) return;
    [self onOpen];
    isOpen = true;
}

- (void)close{
    if(!isOpen) return;
    [self onClose];
    isOpen = false;
}

- (void)onOpen{
    HXLog(@"%@ onOpen!",NSStringFromClass(self.class));
}

- (void)onClose{
    HXLog(@"%@ onClose!",NSStringFromClass(self.class));
}

- (void)dealloc{
    HXLog(@"%@ dealloc!",NSStringFromClass(self.class));
}

#pragma mark - getter and setter
- (NSString *)APIHost{
    return  GlobalAPIHost;
}

- (NSString *)H5Host{
    return GlobalH5Host;
}
@end
