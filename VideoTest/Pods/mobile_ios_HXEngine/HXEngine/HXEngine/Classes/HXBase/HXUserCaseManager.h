//
//  HXUserCaseManager.h
//  newHfax
//
//  Created by lly on 2017/6/30.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HXUserCase;
@class HXModule;

@interface HXUserCaseManager : NSObject

@property (nonatomic,weak,readonly) __kindof HXModule *belongModule;

- (void)registerUserCase:(Class) userCaseClass;

- (__kindof HXUserCase *)obtainUserCase:(Class) userCaseClass;

- (void)closeUserCase:(Class)userCaseClass;

- (void)closeAllUserCases;

@end
