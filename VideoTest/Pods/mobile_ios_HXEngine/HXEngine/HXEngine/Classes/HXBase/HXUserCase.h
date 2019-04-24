//
//  HXUserCase.h
//  newHfax
//
//  Created by lly on 2017/6/30.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXTaskManager.h"
#import <Bolts/BFTask.h>
#import <Bolts/BFTaskCompletionSource.h>

@class BFTask;
@class HXModule;

@protocol HXUserCaseDelegate <NSObject>

- (void)open;
- (void)close;

@end

@interface HXUserCase : NSObject <HXUserCaseDelegate>

- (void)onOpen;
- (void)onClose;

- (NSString *)APIHost;
- (NSString *)H5Host;
@end
