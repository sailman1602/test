//
//  UIDevice+Helpers.h
//
//  Created by zhenhua on 9/1/11.
//  Copyright 2011 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    AppleIphone4  = 0,
    AppleIphone5,
    AppleIphone6,
    AppleIphone6plus,
} DeviceScreenType;


// >=
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
// >
#define SYSTEM_VERSION_GREATER_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
// ==
#define SYSTEM_VERSION_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

// 屏幕大小
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
#define kNavigationBarHG   (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")?64:44)
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height


@interface UIDevice (Helpers)

- (BOOL)isRetinaDisplay;
- (BOOL)is4InchRetinaDisplay;
//- (BOOL)isWIFIConnected;
//- (BOOL)isHaveNetWork;
+ (NSInteger)getScreenScale;

+ (NSString *) platform;
+ (NSString *) getReturnPlat:(NSString *)platform;
+ (NSString *) getStandardPlat;
+ (BOOL)isDeviceOrientationLandscape;

//app基础设置
+ (NSString*)appName;
+ (NSString*)appCurVersion;   //app内部基础设置。例如：1.0.0
+ (NSString *)versionCode;    //版本号处理。例如：0100
+ (NSString*)appBundleVersion; //开发版本号
+ (NSString*)UUID;           //客户端唯一表示,不会变化。
+ (NSString*)dynamicUUID;    //获取动态uuid
+ (NSString*)device;
+ (NSString *)languageCode;
+ (NSString *)countryCode;
+ (NSString*)appFrom;
+ (NSString *)nowDateFromat:(NSString*)timeZoneName;
+ (NSString*)localPhoneModel;
+ (NSString*)dpi;

- (NSString*)sn_Version; 
- (int)sn_majorVersion;
- (BOOL)sn_isIOS5OrEarlier;
- (BOOL)sn_isIOS6OrEarlier;
- (BOOL)sn_isIOS7OrLater;
- (BOOL)sn_isIOS8OrLater;
- (BOOL)sn_isIOS9OrLater;

- (BOOL)sn_shouldEnableTabBarBlurEffect;

- (NSString *) sn_deviceModelString;

+(DeviceScreenType)showDeviceScreenType;
+(BOOL)isAppleIphone5;
+(BOOL)isAppleIphone4Or5;
+(BOOL)isAppleIphone6;
+(BOOL)isAppleIphone6plus;


@end
