//
//  HXUserCaseManager.m
//  newHfax
//
//  Created by lHX on 2017/6/30.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXUserCaseManager.h"
#import "HXUserCase.h"

@interface HXUserCaseManager ()

@property (nonatomic,strong) NSMutableDictionary<NSString *,HXUserCase *> *userCaseRefDic;
@property (nonatomic,strong) NSHashTable<Class> *userCaseRegisterSet;


@end

@implementation HXUserCaseManager

- (instancetype)init{
    self = [super init];
    if(self){
        _userCaseRegisterSet = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        _userCaseRefDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerUserCase:(Class)userCaseClass {
    [self.userCaseRegisterSet addObject:userCaseClass];
}

- (__kindof HXUserCase *)obtainUserCase:(Class) userCaseClass{
    NSString *userCaseClassStr = NSStringFromClass(userCaseClass);
    NSAssert([_userCaseRegisterSet containsObject:userCaseClass], @"%@ has not registered",userCaseClassStr);
    
    HXUserCase *userCase = [self.userCaseRefDic objectForKey:userCaseClassStr];
    if(!userCase){
        userCase = [[userCaseClass alloc]init];
        [self.userCaseRefDic setObject:userCase forKey:userCaseClassStr];
        [userCase open];
    }
    
    return userCase;
}

- (void)closeUserCase:(Class)userCaseClass {
    NSString *userCaseClassStr = NSStringFromClass(userCaseClass);
    HXUserCase *userCase = [self.userCaseRefDic objectForKey:userCaseClassStr];
    if(userCase){
        [userCase close];
        [self.userCaseRefDic removeObjectForKey:userCaseClassStr];
    }

}

- (void)closeAllUserCases{
    [self.userCaseRefDic.allValues enumerateObjectsUsingBlock:^(HXUserCase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj close];
    }];
    [self.userCaseRefDic removeAllObjects];
}


@end
