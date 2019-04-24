//
//  HXTaskManager.m
//  newHfax
//
//  Created by lly on 2017/6/30.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXTaskManager.h"
#import "HXModel.h"
#import <Bolts/Bolts.h>
#import "HXTaskCache.h"
#import "UIKitMacros.h"

#import "HXToast.h"
#import "HXCookie.h"
#import "HXErrorWebViewController.h"
#if COCOAPODS_USE_FRAMEWORK
#import <RTRootNavigationController_lly/RTRootNavigationController.h>
#elif COCOAPODS
#import "RTRootNavigationController.h"
#else
#import <RTRootNavigationController/RTRootNavigationController.h>
#endif

#import "HXJSONRequestSerializer.h"
#import "HXSecurityPolicy.h"

#if !PRO
@interface NSArray (decription)
- (NSString *)description;
@end
@interface NSDictionary (decription)
- (NSString *)description;
@end

#endif

/**
 *  是否开启https SSL 验证
 *
 *  @return YES为开启，NO为关闭
 */
#define openHttpsSSL 1
/**
 *  SSL 证书名称，仅支持cer格式。
 */
#define certificate @"*.hfax.com"


#define LYDefineSuccessBlock(successHander) \
void (^succcessHandler)(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) = ^void(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) { \
HXLog(@"API Requst success -url:%@, response:%@",URLString,[responseObject description]); \
[self updateHTTPCookieStorageWithURLResponse:(NSHTTPURLResponse *)task.response];\
[self mapResponse:responseObject toClass:mappingClass withSuccessHandler:^(HXModel *response) { \
[completionSource trySetResult:response]; \
}errorHandler:^(NSError *error) { \
[completionSource trySetError:error]; \
}]; \
};

#define LYDefineFailBlock(errorHandler) \
void (^errorHandler)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) = ^void(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) { \
HXLog(@"API Requst error -url:%@, error:%@",URLString,error); \
[self showToast:[self errorMessage:error]];\
[completionSource trySetError:error]; \
}; \



NSString *const ErrorDomain = @"com.hfax";
NSString *const HTTPErrorDomain = @"com.alamofire.error.serialization.response";

@interface HXTaskManager()
@property (nonatomic,weak) id<HXTaskManagerCustom> cusDelegate;
@end

@implementation HXTaskManager

+ (instancetype)sharedInstance {
    static HXTaskManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HXTaskManager alloc]init];
    });
    
    return instance;
    
}

- (instancetype)init{
    self = [super init];
    if(self){
        
        self.requestSerializer = [HXJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        [self setSslCertificateName:self.certificateNameForHttps];
    }
    return self;
}

- (void)setCustomDelegate:(id<HXTaskManagerCustom>)delegate{
    self.cusDelegate = delegate;
}

#pragma mark - publicParams
- (NSDictionary *)allPublicParams{
    return ((HXJSONRequestSerializer *)self.requestSerializer).allPublicParams;
}

#pragma mark - data map

- (void)mapResponse:(NSDictionary*)data toClass:(Class)class withSuccessHandler:(void(^)(id response))successHandler errorHandler:(void (^)(NSError* error))errorHandler showToast:(BOOL)showToat{
    if (class&&![class isSubclassOfClass:HXModel.class]) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Response class is not a subclass of HXModel" userInfo:nil] raise];
    }
    
    //客户化解析errorCode errmessage
    NSInteger errCode = [[data objectForKey:@"errCode"] integerValue];
    NSString *errmessage = [data objectForKey:@"errMsg"];
    HXLog(@"********%@",errmessage);
    
    
    if(errCode){
        NSString *errorMessage =([errmessage isKindOfClass:NSString.class]&&errmessage.length) ? errmessage : @"服务器忙碌中，请稍后再试";
        if(showToat){
            [self showToast:errorMessage errorCode:errCode];
        }
        errorHandler([NSError errorWithDomain:ErrorDomain code:errCode userInfo:@{NSLocalizedDescriptionKey: errorMessage}]);
        [self handleErrorCodeAction:errCode errorMessage:errorMessage];
    }else{
        [self removeErrorWebViewController];
        id jsonData = [data objectForKey:@"data"];
        if(!class){
            successHandler(jsonData?jsonData:data);
            return;
        }
        if([jsonData isKindOfClass:[NSArray class]]){
            NSMutableArray *dataArray = [NSMutableArray array];
            for(NSDictionary *dic in jsonData){
                HXModel *mappedResponse = [class yy_modelWithDictionary:dic];
                [dataArray addObject:mappedResponse];
            }
            if (successHandler) {
                successHandler(dataArray);
            }
        }else{
            HXModel *mappedResponse = [class yy_modelWithDictionary:jsonData];
            if (successHandler) {
                successHandler(mappedResponse);
            }
        }
    }
}

- (void)mapResponse:(NSDictionary*)data toClass:(Class)class withSuccessHandler:(void(^)(id response))successHandler errorHandler:(void (^)(NSError* error))errorHandler {
    [self mapResponse:data toClass:class withSuccessHandler:successHandler errorHandler:errorHandler showToast:YES];
}

#pragma mark - data cache
- (void)GETCache:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters completionSource:(BFTaskCompletionSource *)completionSource{
    id cacheData = [HXTaskCache httpCacheForURL:URLString parameters:parameters];
    if(!cacheData){
        [completionSource trySetError:[NSError errorWithDomain:ErrorDomain code:-1 userInfo:nil]];
        return;
    }
    [self mapResponse:cacheData toClass:mappingClass withSuccessHandler:^(id response) {
        [completionSource trySetResult:response];
    } errorHandler:^(NSError *error) {
        [completionSource trySetError:error];
    }];
    
}

#pragma mark - data request
- (NSURLSessionDataTask *)GET:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters completionSource:(BFTaskCompletionSource *)completionSource{
    return [self GET:URLString mappingClass:mappingClass parameters:parameters  showToast:YES cache:NO completionSource:completionSource];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters cache:(BOOL)needCache completionSource:(BFTaskCompletionSource *)completionSource{
    return  [self GET:URLString mappingClass:mappingClass parameters:parameters  showToast:YES cache:needCache completionSource:completionSource];
}

- (NSURLSessionDataTask *)GETNoToast:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters completionSource:(BFTaskCompletionSource *)completionSource{
    return [self GET:URLString mappingClass:mappingClass parameters:parameters  showToast:NO cache:NO completionSource:completionSource];
}
- (NSURLSessionDataTask *)GETNoToast:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters  cache:(BOOL)needCache completionSource:(BFTaskCompletionSource *)completionSource{
    return [self GET:URLString mappingClass:mappingClass parameters:parameters  showToast:NO cache:needCache completionSource:completionSource];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters showToast:(BOOL)showToast  cache:(BOOL)needCache completionSource:(BFTaskCompletionSource *)completionSource{
    NSURLSessionDataTask *task = nil;
    NSDate *startTime = [NSDate date];
    [self trackRequestStartWithUrl:URLString startTime:startTime];
    void (^succcessHandler)(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) = ^void(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        HXLog(@"API Requst success -url:%@, response:%@",URLString,[responseObject description]);
        [self trackRequestFinishWithUrl:URLString startTime:startTime endTime:[NSDate date] error:nil];
        if(needCache){
            [HXTaskCache setHttpCache:responseObject URL:URLString parameters:parameters];
        }
        [self updateHTTPCookieStorageWithURLResponse:(NSHTTPURLResponse *)task.response];
        [self mapResponse:responseObject toClass:mappingClass withSuccessHandler:^(HXModel *response) {
            [completionSource trySetResult:response];
        }errorHandler:^(NSError *error) {
            [completionSource trySetError:error];
        } showToast:showToast];
    };
    
    void (^errorHandler)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) = ^void(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        HXLog(@"API Requst error -url:%@, error:%@",URLString,error);
        [self trackRequestFinishWithUrl:URLString startTime:startTime endTime:[NSDate date] error:error];
        if(showToast){
            [self showToast:[self errorMessage:error]];
        }
        [completionSource trySetError:error];
    };
    
    task = [self GET:URLString parameters:parameters progress:nil success:succcessHandler failure:errorHandler];
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters completionSource:(BFTaskCompletionSource *)completionSource{
    return [self POST:URLString mappingClass:mappingClass parameters:parameters isFormData:NO showToast:YES completionSource:completionSource ];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters isFormData:(BOOL)isFormData  showToast:(BOOL)showToast completionSource:(BFTaskCompletionSource *)completionSource{
    HXLog(@"API Requst Begin -url:%@,public parameters:%@,parameters:%@",URLString,self.allPublicParams,parameters);
    NSDate *startTime = [NSDate date];
    [self trackRequestStartWithUrl:URLString startTime:startTime];
    NSURLSessionDataTask *task = nil;
    void (^succcessHandler)(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) = ^void(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        HXLog(@"API Requst success -url:%@, response:%@",URLString,[responseObject description]);
        [self trackRequestFinishWithUrl:URLString startTime:startTime endTime:[NSDate date] error:nil];
        [self updateHTTPCookieStorageWithURLResponse:(NSHTTPURLResponse *)task.response];
        [self mapResponse:responseObject toClass:mappingClass withSuccessHandler:^(HXModel *response) {
            [completionSource trySetResult:response];
        }errorHandler:^(NSError *error) {
            [completionSource trySetError:error];
        } showToast:showToast];
    };
    void (^errorHandler)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) = ^void(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        HXLog(@"API Requst error -url:%@, error:%@",URLString,error);
        [self trackRequestFinishWithUrl:URLString startTime:startTime endTime:[NSDate date] error:error];
        if(showToast){
            [self showToast:[self errorMessage:error]];
        }
        [completionSource trySetError:error];
    };
    if(isFormData){
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
        BOOL isUploadFile = [dic objectForKey:@"filedata"] != nil;
        if(isUploadFile){
            [dic removeObjectForKey:@"filedata"];
            dic[@"updateFile"] = @(1);
        }
        task = [self POST:URLString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if(isUploadFile){
                [formData appendPartWithFileData:parameters[@"filedata"] name:@"file" fileName:@"img.jpg" mimeType:@"image/jpeg"];
            }
        } progress:nil success:succcessHandler failure:errorHandler];
    }else{
        task = [self POST:URLString parameters:parameters progress:nil success:succcessHandler failure:errorHandler];
    }
    return task;
}

- (NSURLSessionDataTask *)POSTNoToast:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters completionSource:(BFTaskCompletionSource *)completionSource{
    return [self POST:URLString mappingClass:mappingClass parameters:parameters isFormData:NO showToast:NO completionSource:completionSource ];
}

- (NSURLSessionDataTask *)POSTFormData:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters completionSource:(BFTaskCompletionSource *)completionSource{
    return [self POST:URLString mappingClass:mappingClass parameters:parameters isFormData:YES showToast:YES completionSource:completionSource];
}

- (NSURLSessionDataTask *)performRequestWithMethod:(NSString *)method urlString:(NSString *)URLString mappingClass:(Class)mappingClass parameters:(NSDictionary *)parameters completionSource:(BFTaskCompletionSource *)completionSource {
    
    HXLog(@"API Requst Begin -url:%@,public parameters:%@,parameters:%@",URLString,self.allPublicParams,parameters);
    NSURLSessionDataTask *task = nil;
    LYDefineSuccessBlock(successHander);
    LYDefineFailBlock(errorHandler);
    
    if ([method isEqualToString:@"GET"]) {
        task = [self GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:succcessHandler failure:errorHandler];
    } else if ([method isEqualToString:@"POST"]) {
        task = [self POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:succcessHandler failure:errorHandler];
    } else if ([method isEqualToString:@"PUT"]) {
        task = [self PUT:[self urlString:URLString withParams:parameters] parameters:nil success:succcessHandler failure:errorHandler];
    } else if ([method isEqualToString:@"DELETE"]) {
        task = [self DELETE:[self urlString:URLString withParams:parameters] parameters:parameters success:succcessHandler failure:errorHandler];
    }
    
    return task;
}

- (NSString*)urlString:(NSString*) url withParams:(NSDictionary*) params {
    NSMutableString* string = [NSMutableString stringWithString:url];
    [string appendString:@"?"];
    for (NSString* key in params) {
        NSString* value = [NSString stringWithFormat:@"%@", [params objectForKey:key]];
        NSString *encodedValue = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                                      (CFStringRef)value, nil,
                                                                                                      (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        if (key && ![value isEqual:NSNull.null]) {
            [string appendString:[NSString stringWithFormat:@"%@=%@&", key, encodedValue]];
        } else {
            [string appendString:[NSString stringWithFormat:@"%@&", key]];
            
        }
    }
    
    return [string substringToIndex:string.length - 1];
}

#pragma mark - track
- (void)trackRequestStartWithUrl:(NSString *)url startTime:(NSDate *)startTime{
    if(self.cusDelegate&&[self.cusDelegate respondsToSelector:@selector(customTrackRequestStartWithUrl:startTime:)]){
        [self.cusDelegate customTrackRequestStartWithUrl:url startTime:startTime];
    }
}
- (void)trackRequestFinishWithUrl:(NSString *)url startTime:(NSDate *)startTime endTime:(NSDate *)endTime error:(NSError *)error{
    if(self.cusDelegate&&[self.cusDelegate respondsToSelector:@selector(customTrackRequestFinishWithUrl:startTime:endTime:error:)]){
        [self.cusDelegate customTrackRequestFinishWithUrl:url startTime:startTime endTime:endTime error:error];
    }
}

#pragma mark - private
- (void)showToast:(NSString *)message{
    if(self.cusDelegate&&[self.cusDelegate respondsToSelector:@selector(customShowToast:)]){
        [self.cusDelegate customShowToast:message];
    }else{
        HXToast * tost = [[HXToast alloc] initWithView:[UIApplication sharedApplication].keyWindow text:message duration:2];
        [tost show];
    }
}
- (void)showToast:(NSString *)message errorCode:(NSInteger)errCode{
    if(self.cusDelegate && [self.cusDelegate respondsToSelector:@selector(customShowToast:errorCode:)]){
        [self.cusDelegate customShowToast:message errorCode:errCode];
    }else{
        [self showToast:message];
    }
}

#pragma mark -certificate
- (void)setSslCertificateName:(NSString *)sslCertificateName{
#if openHttpsSSL
    [self setSecurityPolicy:[self customSecurityPolicy:sslCertificateName]];
#endif
}

- (NSString *)certificateNameForHttps{
    if(!_certificateNameForHttps.length){
        return certificate;
    }
    return _certificateNameForHttps;
}

- (AFSecurityPolicy*)customSecurityPolicy:(NSString *)sslCertificateName
{
    // /先导入证书
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:sslCertificateName ofType:@"cer"];//证书的路径
    //    NSAssert(cerPath!=nil, @"ssl certificate file path not excists!");
    //    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    AFSecurityPolicy *securityPolicy = [HXSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
#if !PRO
    securityPolicy.allowInvalidCertificates = YES;
#else
    securityPolicy.allowInvalidCertificates = NO;
#endif
    securityPolicy.validatesDomainName = NO;
    
    return securityPolicy;
}

#pragma mark - cookie
- (void)updateHTTPCookieStorageWithURLResponse:(NSHTTPURLResponse *)response{
    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
    HXLog(@"API Requst success -url:%@, cookie:%@",response.URL,cookies);
    
    NSMutableArray *oldCookies = [[HXCookie cookies] mutableCopy];
    if(!oldCookies)oldCookies = [NSMutableArray array];
    for (NSHTTPCookie *cookie in cookies) {
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        for(NSHTTPCookiePropertyKey key in cookie.properties){
            if(![key isEqualToString: NSHTTPCookieSecure])
                [properties setObject:[cookie.properties objectForKey:key] forKey:key];
        }
        NSHTTPCookie *newCookie = [NSHTTPCookie cookieWithProperties:properties];
        
        BOOL find = NO;
        for(int i = 0;i<oldCookies.count;i++){
            NSHTTPCookie *oldCookie = oldCookies[i];
            if([oldCookie.name isEqualToString:cookie.name]){
                [oldCookies replaceObjectAtIndex:i withObject:newCookie];
                find = YES;
            }
        }
        if(!find){
            [oldCookies addObject:newCookie];
        }
    }
    
    [HXCookie saveCookie:oldCookies];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in oldCookies) {
        [cookieStorage setCookie:cookie];
    }
}

#pragma mark - error message
- (NSString *)errorMessage:(NSError *)error{
    NSString *errorMessage = @"网络不给力,请稍后再试";
    if([HXSecurityPolicy isProxyError]&&error.code != -1009&&error.code !=- 1001){
        errorMessage = [HXSecurityPolicy proxySecurityErrorMsg];
    }
    
    return errorMessage;
}
#pragma mark - error Code action
- (void)handleErrorCodeAction:(NSInteger)errCode errorMessage:(NSString *)errorMsg{
    if(self.cusDelegate&&[self.cusDelegate respondsToSelector:@selector(customHandleErrorCodeAction:errorMessage:)]){
        [self.cusDelegate customHandleErrorCodeAction:errCode errorMessage:errorMsg];
    }
}

- (void)handleProtocolErrorCodeAction:(NSInteger)errCode errorMessage:(NSString *)errorMsg{
    [self handleErrorCodeAction:errCode errorMessage:errorMsg];
}

- (void)removeErrorWebViewController{
    if(self.cusDelegate&&[self.cusDelegate respondsToSelector:@selector(customRemoveErrorWebViewController)]){
        [self.cusDelegate customRemoveErrorWebViewController];
    }
}
@end

#pragma mark -------debug Print------
#if !PRO
@implementation NSArray (decription)
- (NSString *)description
{
    NSMutableString *str = [NSMutableString stringWithString:@"("];
    for (id obj in self) {
        if(obj == self.lastObject){
            [str appendFormat:@"\t%@", [obj description]];
        }else{
            [str appendFormat:@"\t%@,\n", [obj description]];
        }
    }
    [str appendString:@")"];
    
    return str;
}
@end

@implementation NSDictionary (decription)
- (NSString *)description
{
    NSArray *allKeys = [self allKeys];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];
    
    for (NSString *key in allKeys) {
        id value= self[key];
        [str appendFormat:@"\t \"%@\" = %@,\n",key, [value description]];
    }
    [str appendString:@"}"];
    return str;
}
@end
#endif
