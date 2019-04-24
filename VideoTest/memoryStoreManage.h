//
//  memoryStoreManage.h
//  VideoTest
//
//  Created by YNZMK on 2019/4/13.
//  Copyright © 2019 YNZMK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface memoryStoreManage : NSObject

+ (void)storeVideoPath:(NSString *)path url:(NSString *)url;
+ (NSString *)getVideoPathFromUrl:(NSString *)url;
+ (NSArray *)getStoreVideoList;

@end

NS_ASSUME_NONNULL_END
