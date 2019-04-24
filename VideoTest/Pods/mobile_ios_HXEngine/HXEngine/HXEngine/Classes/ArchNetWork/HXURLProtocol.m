//
//  HXURLProtocol.m
//  newHfax
//
//  Created by lly on 2018/3/14.
//  Copyright © 2018年 hfax. All rights reserved.
//

#import "HXURLProtocol.h"
#import "NSMutableURLRequest+PostRequest.h"
#import <WebKit/WebKit.h>
#import "NSDictionary+JSONExtern.h"
#import "HXTaskManager.h"
#if !PRO
#import "HXModule.h"
#endif

FOUNDATION_STATIC_INLINE Class ContextControllerClass() {
    static Class cls;
    if (!cls) {
        cls = [[[WKWebView new] valueForKey:@"browsingContextController"] class];
    }
    return cls;
}

FOUNDATION_STATIC_INLINE SEL RegisterSchemeSelector() {
    return NSSelectorFromString(@"registerSchemeForCustomProtocol:");
}

FOUNDATION_STATIC_INLINE SEL UnregisterSchemeSelector() {
    return NSSelectorFromString(@"unregisterSchemeForCustomProtocol:");
}

static NSString* const FilteredKey = @"FilteredKey";

@interface HXURLProtocol () <NSURLConnectionDataDelegate>

@property (nonatomic,strong) NSURLConnection *connection;

@end

@implementation HXURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    BOOL isPost = [request.allHTTPHeaderFields objectForKey:@"hfaxPostBody"]!=nil;
    return [request.HTTPMethod isEqualToString:@"POST"]&&isPost&&[NSURLProtocol propertyForKey:FilteredKey inRequest:request] == nil;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading{
    NSMutableURLRequest * realRequest = [self formatRequest:[self.request mutableCopy]];
    [NSURLProtocol setProperty:@(YES) forKey:FilteredKey inRequest:realRequest];
    self.connection = [NSURLConnection connectionWithRequest: realRequest delegate:self];
}
- (void)stopLoading{
    
}

#pragma mark - delegate
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //    dataString = @"{\"errCode\":9005,\"errMsg\":\"请登录\"}";
    NSLog(@"URLProtocol didReceiveData: %@",dataString);
    NSDictionary *dataDic = [NSDictionary dictionaryWithJsonString:dataString];
    if (dataDic && [dataDic objectForKey:@"errCode"] && [dataDic objectForKey:@"errMsg"]) {
        [HXTaskManagerInstance handleProtocolErrorCodeAction:[[dataDic objectForKey:@"errCode"] integerValue] errorMessage:[dataDic objectForKey:@"errMsg"] ];
        return ;
    }
    [self.client URLProtocol:self didLoadData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

- (nullable NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(nullable NSURLResponse *)response{
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        if ([HTTPResponse statusCode] == 301 || [HTTPResponse statusCode] == 302)
        {
            NSMutableURLRequest *mutableRequest = [request mutableCopy];
            [mutableRequest setURL:[NSURL URLWithString:[[HTTPResponse allHeaderFields] objectForKey:@"Location"]]];
            request = [mutableRequest copy];
            
            [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
        }
    }
    return request;
}

//#if DEBUG
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
         [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
//    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

//#endif
/*
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
        return;
    }
    static CFArrayRef certs;
    if (!certs) {
        NSData *certData =[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"*.hfax.com" ofType:@"cer"]];
        SecCertificateRef rootcert =SecCertificateCreateWithData(kCFAllocatorDefault,CFBridgingRetain(certData));
        const void *array[1] = { rootcert };
        certs = CFArrayCreate(NULL, array, 1, &kCFTypeArrayCallBacks);
        CFRelease(rootcert);    // for completeness, really does not matter
    }
    
    SecTrustSetAnchorCertificates([challenge.protectionSpace serverTrust],certs);
    //Set to server trust management object to JUST ALLOW those anchor objects assigned to it (ABOVE), and disable apple CA trusts
    SecTrustSetAnchorCertificatesOnly([challenge.protectionSpace serverTrust], YES);
    //Try to evalute it
    SecTrustResultType evaluateResult = kSecTrustResultInvalid; //evaluate result
    OSStatus sanityCheck = SecTrustEvaluate([challenge.protectionSpace serverTrust], &evaluateResult);
    //Check for no evaluate error
    if (sanityCheck == noErr) {
        //Check for result
        if ([[self class] validateTrustResult:evaluateResult]) {
             [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
            return;
        }
    }
    //deny!
    [challenge.sender cancelAuthenticationChallenge:challenge];
    
//    SecTrustRef trust = [[challenge protectionSpace] serverTrust];
//    int err;
//    SecTrustResultType trustResult = 0;
//    err = SecTrustSetAnchorCertificates(trust, certs);
//    if (err == noErr) {
//        err = SecTrustEvaluate(trust,&trustResult);
//    }
//    CFRelease(trust);
//    BOOL trusted = (err == noErr) && ((trustResult == kSecTrustResultProceed)||(trustResult == kSecTrustResultConfirm) || (trustResult == kSecTrustResultUnspecified));
//
//    if (trusted) {
//        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//    }else{
//        [challenge.sender cancelAuthenticationChallenge:challenge];
//    }
}*/

#pragma mark - SERVER Auth Helper
//Validate server certificate with challenge
+ (BOOL)validateServerWithChallenge:(NSURLAuthenticationChallenge *)challenge {
    //Get server trust management object a set anchor objects to validate it
    NSData *certData =[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"*.hfax.com" ofType:@"cer"]];
    SecCertificateRef rootcert =SecCertificateCreateWithData(kCFAllocatorDefault,CFBridgingRetain(certData));
    const void *array[1] = { rootcert };
    
    SecTrustSetAnchorCertificates([challenge.protectionSpace serverTrust],CFArrayCreate(NULL, array, 1, &kCFTypeArrayCallBacks));
    //Set to server trust management object to JUST ALLOW those anchor objects assigned to it (ABOVE), and disable apple CA trusts
    SecTrustSetAnchorCertificatesOnly([challenge.protectionSpace serverTrust], YES);
    //Try to evalute it
    SecTrustResultType evaluateResult = kSecTrustResultInvalid; //evaluate result
    OSStatus sanityCheck = SecTrustEvaluate([challenge.protectionSpace serverTrust], &evaluateResult);
    //Check for no evaluate error
    if (sanityCheck == noErr) {
        //Check for result
        if ([self validateTrustResult:evaluateResult]) { return YES ; }
    }
    //deny!
    return NO ;
}
//Validate SecTrustResulType
+ (BOOL)validateTrustResult:(SecTrustResultType)result {
    switch (result) {
        case kSecTrustResultProceed: { NSLog(@"kSecTrustResultProceed"); return YES ; }
            break;
        case kSecTrustResultConfirm: { NSLog(@"kSecTrustResultConfirm"); return YES ; }
            break;
        case kSecTrustResultUnspecified: { NSLog(@"kSecTrustResultUnspecified"); return YES ; }
            break;
        case kSecTrustResultDeny: { NSLog(@"kSecTrustResultDeny"); return YES ; }
            break;
        case kSecTrustResultFatalTrustFailure: {NSLog(@"kSecTrustResultFatalTrustFailure"); return NO ; }
            break;
        case kSecTrustResultInvalid: { NSLog(@"kSecTrustResultInvalid"); return NO ; }
            break;
        case kSecTrustResultOtherError: { NSLog(@"kSecTrustResultOtherError"); return NO ; }
            break;
        case kSecTrustResultRecoverableTrustFailure: { NSLog(@"kSecTrustResultRecoverableTrustFailure"); return NO ; }
            break;
        default: { NSLog(@"unkown certificate evaluate result type! denying..."); return NO ; }
            break;
    }
}


#pragma mark - func
- (NSMutableURLRequest *)formatRequest:(NSMutableURLRequest *)request{
    NSString *postBoby = [request.allHTTPHeaderFields objectForKey:@"hfaxPostBody"];
    [request setValue:nil forHTTPHeaderField:@"hfaxPostBody"];
    request.HTTPBody = [postBoby dataUsingEncoding: NSUTF8StringEncoding];
    NSString *realUrl = nil;
#if !PRO
    if([GlobalAPIHost hasPrefix:@"http://"])
        realUrl = [request.URL.absoluteString  stringByReplacingOccurrencesOfString:@"hfaxpost://" withString:@"http://"];
    else if ([GlobalAPIHost hasPrefix:@"https://"])
        realUrl = [request.URL.absoluteString  stringByReplacingOccurrencesOfString:@"hfaxpost://" withString:@"https://"];
#else
    realUrl = [request.URL.absoluteString  stringByReplacingOccurrencesOfString:@"hfaxpost://" withString:@"https://"];
#endif
    request.URL = [NSURL URLWithString:realUrl];
    return request;
}

#pragma mark -



@end

@implementation NSURLProtocol (wk)

#pragma mark - wk_registerScheme
+ (void)wk_registerScheme:(NSString *)scheme {
    Class cls = ContextControllerClass();
    SEL sel = RegisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}

+ (void)wk_unregisterScheme:(NSString *)scheme {
    Class cls = ContextControllerClass();
    SEL sel = UnregisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}

@end
