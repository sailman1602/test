//
//  HXModule.h
//  newHfax
//
//  Created by lly on 2017/6/30.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGJRouter.h"
#import "HXUserCase.h"

extern NSString *GlobalAPIHost;
extern NSString *GlobalH5Host;

@interface HXModule : MGJRouter

@property (nonatomic,copy) NSString *APIHost;
@property (nonatomic,copy) NSDictionary *APIPublicParams;
@property (nonatomic,copy) NSString *H5Host;
@property (nonatomic,copy) NSBundle *bundle;


+ (instancetype)instance;

+ (void)install;
+ (void)unInstall;
+ (BOOL)isInstalled;

+ (void)registerUserCase:(Class) userCaseClass;
+ (__kindof HXUserCase *)obtainUserCase:(Class) userCaseClass;
+ (void)closeUserCase:(Class)userCaseClass;
+ (void)closeAllUserCase;

+ (void)configureGlobalWithAPIhost:(NSString *)APIHost H5Host:(NSString *)H5Host;

- (void)registerUserCase:(Class) userCaseClass;
- (__kindof HXUserCase *)obtainUserCase:(Class) userCaseClass;
- (void)closeUserCase:(Class)userCaseClass;
- (void)closeAllUserCase;

- (void)initEnvironment;
- (void)initRouter;
- (void)unInitRouter;

- (void)onModuleInstlled;
- (void)onModuleUninstalled;
- (void)onRegisterUserCase;

#pragma mark - func
//如果传过来是path自动加上h5host
- (NSString *)fullH5UrlWithPath:(NSString *)path;


@end
