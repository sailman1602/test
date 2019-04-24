//
//  HXModule.m
//  newHfax
//
//  Created by lly on 2017/6/30.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXModule.h"
#import "NSObject+LYLock.h"
#import "HXUserCaseManager.h"
#import "UIKitMacros.h"

NSString *GlobalAPIHost = nil;
NSString *GlobalH5Host = nil;

#define HXModuleInstance [self instance]
static NSMutableDictionary *instances = nil;

@interface HXModule()

@property (nonatomic,assign) BOOL isOnload;
@property (nonatomic,strong) HXUserCaseManager *userCaseManager;

@end

@implementation HXModule

+(void)load{
    if(self.class==HXModule.class){
        instances = [NSMutableDictionary dictionary];
    }
}

+ (instancetype )instance
{
    NSString *classString = NSStringFromClass(self.class);
    HXModule *m = [instances objectForKey:classString];
    return m;
}

+ (HXModule *)sharedInstance{
    return [self instance];
}

+ (void)removeShareInstance{
    [instances ly_lockObject];
    [instances removeObjectForKey:NSStringFromClass(self.class)];
    [instances ly_unlockObject];
}

+ (void)configureGlobalWithAPIhost:(NSString *)APIHost H5Host:(NSString *)H5Host{
    GlobalAPIHost = APIHost;
    GlobalH5Host = H5Host;
}

#pragma mark - lifeCycle
- (instancetype)init{
    self = [super init];
    if(self){
        self.userCaseManager = [[HXUserCaseManager alloc]init];;
    }
    return self;
}

- (void)initEnvironment{
    HXLog(@"Module : %@ initEnvironment!",NSStringFromClass(self.class));
}

- (void)onModuleInstlled{
    HXLog(@"Module : %@ installed!",NSStringFromClass(self.class));
    [self initEnvironment];
    [self initRouter];
    [self onRegisterUserCase];
    
}

- (void)onModuleUninstalled{
    HXLog(@"Module : %@ unInstalled!",NSStringFromClass(self.class));
    [self unInitRouter];
    [self.class closeAllUserCase];
}

- (void)onRegisterUserCase{
    HXLog(@"registerUserCase");
}


#pragma mark - register
+ (void)install{
    NSAssert(self!=[HXModule class], @"to be installed module must extends HXModule!!!");
    HXModule * m = [self instance];
    if(m){
        NSAssert(false, @"the Module:%@ has installed !",NSStringFromClass(m.class));
    }else{
        m = [[self.class alloc]init];
        [instances ly_lockObject];
        [instances setObject:m forKey:NSStringFromClass(self.class)];
        [instances ly_unlockObject];
        [m onModuleInstlled];
    }
}

+ (void)unInstall{
    NSAssert(self!=[HXModule class], @"to be installed module must extends HXModule!!!");
    if(![self isInstalled]){
        NSAssert(false, @"the Module:%@ has Unregistered !",NSStringFromClass(self.class));
    }else{
        HXModule * m = [self instance];
        [m onModuleUninstalled];
        [self removeShareInstance];
        m = nil;
    }
}

+ (BOOL)isInstalled{
    NSAssert(self!=[HXModule class], @"to be installed module must extends HXModule!!!");
    HXModule *m = [self instance];
    return m?true:false;
}

#pragma maark - useCase
- (void)registerUserCase:(Class) userCaseClass{
    [self.userCaseManager registerUserCase:userCaseClass];
}

- (__kindof HXUserCase *)obtainUserCase:(Class) userCaseClass{
    return [self.userCaseManager obtainUserCase:userCaseClass];
}

- (void)closeUserCase:(Class)userCaseClass{
    return [self.userCaseManager closeUserCase:userCaseClass];
}

- (void)closeAllUserCase{
    [self.userCaseManager closeAllUserCases];
}

+ (void)registerUserCase:(Class) userCaseClass{
    [HXModuleInstance registerUserCase:userCaseClass];
}

+ (__kindof HXUserCase *)obtainUserCase:(Class) userCaseClass{
    return [HXModuleInstance obtainUserCase:userCaseClass];
}

+ (void)closeUserCase:(Class)userCaseClass{
    [HXModuleInstance closeUserCase:userCaseClass];
}

+ (void)closeAllUserCase{
    [HXModuleInstance closeAllUserCase];
}

#pragma mark - router
- (void)initRouter{
    //overWrite
}

- (void)unInitRouter{
    //overWrite
}

#pragma mark - env
- (NSString *)APIHost{
    if(_APIHost.length>0){
        return _APIHost;
    }else{
        return GlobalAPIHost;
    }
}

- (NSString *)H5Host{
    if(_H5Host.length>0){
        return _H5Host;
    }else{
        return GlobalH5Host;
    }
}

- (NSBundle *)bundle{
    if(!_bundle){
        _bundle = [NSBundle bundleForClass:self.class];
    }
    return _bundle;
}

#pragma mark -func
- (NSString *)fullH5UrlWithPath:(NSString *)path{
    if([path hasPrefix:@"http"]){
        return path;
    }
    return [[NSString stringWithFormat:@"%@%@",self.H5Host, path] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
