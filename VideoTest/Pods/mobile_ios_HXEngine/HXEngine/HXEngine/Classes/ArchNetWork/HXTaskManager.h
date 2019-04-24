//
//  HXTaskManager.h
//  newHfax
//
//  Created by lly on 2017/6/30.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@protocol HXTaskManagerCustom <NSObject>

@optional
#pragma mark - can be overwrite to be custom
- (void)customHandleErrorCodeAction:(NSInteger)errCode errorMessage:(NSString *)errorMsg;//#pragma mark - error Code action
- (void)customRemoveErrorWebViewController;
- (void)customShowToast:(NSString *)message;
- (void)customShowToast:(NSString *)message errorCode:(NSInteger)errCode;
#pragma mark - track  - can be overwrite to be custom
- (void)customTrackRequestStartWithUrl:(NSString *)url startTime:(NSDate *)startTime;
- (void)customTrackRequestFinishWithUrl:(NSString *)url startTime:(NSDate *)startTime endTime:(NSDate *)endTime error:(NSError *)error;

@end

@class BFTaskCompletionSource;

#define HXTaskManagerInstance [HXTaskManager sharedInstance]

@interface HXTaskManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

- (void)setCustomDelegate:(id<HXTaskManagerCustom>)delegate;

@property (nonatomic,copy)NSString  *certificateNameForHttps;

- (NSURLSessionDataTask *)GETNoToast:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters completionSource:(BFTaskCompletionSource *)completionSource;

- (NSURLSessionDataTask *)GETNoToast:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters  cache:(BOOL)needCache completionSource:(BFTaskCompletionSource *)completionSource;

- (NSURLSessionDataTask *)GET:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters completionSource:(BFTaskCompletionSource *)completionSource;

- (NSURLSessionDataTask *)POST:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters completionSource:(BFTaskCompletionSource *)completionSource;

- (NSURLSessionDataTask *)POSTFormData:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters completionSource:(BFTaskCompletionSource *)completionSource;

- (NSURLSessionDataTask *)POSTNoToast:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters completionSource:(BFTaskCompletionSource *)completionSource;

#pragma mark - cache
- (NSURLSessionDataTask *)GET:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters cache:(BOOL)needCache completionSource:(BFTaskCompletionSource *)completionSource;

- (void)GETCache:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters completionSource:(BFTaskCompletionSource *)completionSource;

- (NSDictionary *)allPublicParams;//#pragma mark - publicParams + custom

#pragma mark - can be overwrite to be custom
- (void)handleErrorCodeAction:(NSInteger)errCode errorMessage:(NSString *)errorMsg;//#pragma mark - error Code action
//Protocol错误处理默认是调取handleErrorCodeAction的方法，如果自定义可以在分类进行覆盖
- (void)handleProtocolErrorCodeAction:(NSInteger)errCode errorMessage:(NSString *)errorMsg;
- (void)removeErrorWebViewController;
//- (void)showToast:(NSString *)message;
//- (void)showToast:(NSString *)message errorCode:(NSInteger)errCode;
//#pragma mark - track  - can be overwrite to be custom
//- (void)trackRequestStartWithUrl:(NSString *)url startTime:(NSDate *)startTime;
//- (void)trackRequestFinishWithUrl:(NSString *)url startTime:(NSDate *)startTime endTime:(NSDate *)endTime error:(NSError *)error;

@end
