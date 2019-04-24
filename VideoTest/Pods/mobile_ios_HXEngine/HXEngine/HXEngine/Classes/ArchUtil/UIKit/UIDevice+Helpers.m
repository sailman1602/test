//
//  UIDevice+Helpers.m
//
//  Created by zhenhua on 9/1/11.
//  Copyright 2011 Sina. All rights reserved.
//

#import "UIDevice+Helpers.h"
#import "HXUIDefines.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <sys/utsname.h>

#define ProductCode @"01"
#define PlatformCode @"2"
#define ChannelCategoryCode @"00"
#define ChannelCode @"100"

@implementation UIDevice (Helpers)

- (BOOL)isRetinaDisplay
{
    if ([[UIScreen mainScreen] scale] > 1.0)
    {
        return YES;
    }
	
	return NO;
}

- (BOOL)is4InchRetinaDisplay
{
    if (CGRectGetHeight([[UIScreen mainScreen] bounds]) == 568.0) {
        return YES;
    }
    
    return NO;
}

+ (NSInteger)getScreenScale
{
    static NSInteger screenScale = 0;
    static CGFloat h = 0.0;
    static CGFloat w = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        screenScale = [UIScreen mainScreen].scale;
        h = [UIScreen mainScreen].bounds.size.height;
        w = [UIScreen mainScreen].bounds.size.width;
        
        // iPhone6Plus zoomed mode修正
        if (3 == screenScale && 375.0f == w)
        {
            screenScale = 2;
        }
    });
    
    return screenScale;
}


+ (NSString *) platform
{
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
	free(machine);
	return platform;
}

+ (NSString *)getReturnPlat:(NSString *)platform
{
    // http://theiphonewiki.com/wiki/Models
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C (Global)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S (Global)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6sPlus";
    
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]||[platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]||[platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]||[platform isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]||[platform isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]||[platform isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,8"])    return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,2"])    return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,6"])    return @"iPhone XS Max";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air (TD)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini2";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini2 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini2 (TD)";
    if ([platform isEqualToString:@"iPad4,7"])       return@"iPad Mini3";
    if ([platform isEqualToString:@"iPad4,8"])       return@"iPad Mini3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,9"])       return@"iPad Mini3 (TD)";
    
    if ([platform isEqualToString:@"iPad5,3"])       return@"iPad Air2";
    if ([platform isEqualToString:@"iPad5,4"])       return@"iPad Air2 (GSM+CDMA)";
    
#if DEBUG
    if(IS_IPHONEX) return @"iPhone X Simulator";
#endif
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

+ (NSString *) getStandardPlat
{
	return [self getReturnPlat:[self platform]];
}

+ (BOOL)isDeviceOrientationLandscape
{
    return [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||
    [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight;
}

- (int)sn_majorVersion
{
    static int s_sn_uidevice_major_version = -1;
    if (s_sn_uidevice_major_version < 0)
        s_sn_uidevice_major_version = (int)[[self systemVersion] doubleValue];
    
    return s_sn_uidevice_major_version;
}

- (NSString*)sn_Version
{
    return [self systemVersion];
}

+ (NSString*)appName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name;
}

+ (NSString*)appCurVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version == nil ? @"1.0.0" : app_Version;
}

+ (NSString*)appBundleVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_BundleVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    return app_BundleVersion;
}


+ (NSString*)localPhoneModel
{
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    return localPhoneModel;
}

+ (NSString *)countryCode
{
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}

+ (NSString *)languageCode
{
    return [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
}

+ (NSString*)device
{
    NSString *device = [NSString stringWithFormat:@"iOS/%@/%@/%@", [[UIDevice currentDevice] systemVersion], [[UIDevice currentDevice] model],  [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    return device;
    //OSType/OSVersion/DeviceModel/DeviceId
}

+ (NSString*)UUID
{
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *strUrl = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return strUrl;
}

+ (NSString*)dynamicUUID
{
    return [NSUUID UUID].UUIDString;
}


+ (NSString *)nowDateFromat:(NSString*)timeZoneName
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = nil;
    if (timeZoneName != nil)
    {
        destinationTimeZone = [NSTimeZone timeZoneWithName:timeZoneName];
    }
    else
    {
        destinationTimeZone = [NSTimeZone localTimeZone];
    }
    
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:[NSDate date]];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:[NSDate date]];
    //得到时间偏移量的差值
    NSTimeInterval interval =  destinationGMTOffset - sourceGMTOffset;
    
    NSInteger  hours = labs((NSInteger)interval) / 3600;
    NSInteger min = labs(((NSInteger)interval)/60) % 60;
    
    NSString *result = @"";
    
    if (interval > 0)
    {
        result = @"+";
    }
    else
    {
        result = @"-";
    }
    return [NSString stringWithFormat:@"%@%02ld:%02ld",result,(long) hours,(long)min];
}

+ (NSString*)appFrom
{
    NSString *versionCode = [UIDevice appCurVersion];
    return [NSString stringWithFormat:@"%@%@%@%@%@%@", ProductCode, PlatformCode, versionCode, ChannelCategoryCode, ChannelCode , @"0000"];
}

+ (NSString *)versionCode
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    return [self getReturnPlat:platform];
}

+ (NSString*)dpi{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    int width = size.width*scale;
    int height = size.height*scale;
    return [NSString stringWithFormat:@"%d*%d",width,height];
}


- (BOOL)sn_isIOS5OrEarlier
{
    return [self sn_majorVersion] <= 5;
}

- (BOOL)sn_isIOS6OrEarlier
{
    return [self sn_majorVersion] <= 6;
}

- (BOOL)sn_isIOS7OrLater
{
    return [self sn_majorVersion] >= 7;
}

- (BOOL)sn_isIOS8OrLater
{
    return [self sn_majorVersion] >= 8;
}

- (BOOL)sn_isIOS9OrLater
{
     return [self sn_majorVersion] >= 9;
}

- (BOOL)sn_shouldEnableTabBarBlurEffect
{
    return ([self sn_isIOS7OrLater]);
}

- (NSString *) sn_deviceModelString
{
    static NSString * s_sn_uidevice_model_string = nil;
    if (!s_sn_uidevice_model_string)
    {
        struct utsname systemInfo;
        int ret = uname(&systemInfo);
        if (ret == 0)
        {
            s_sn_uidevice_model_string = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        }
        else
        {
            s_sn_uidevice_model_string = @"Unknown";
        }
    }
    
    return s_sn_uidevice_model_string;
}

+(DeviceScreenType)showDeviceScreenType
{
    DeviceScreenType  screenType = AppleIphone6;
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = [UIScreen mainScreen].bounds.size.height;
    switch(width)
    {
        case 320:
        {
            if (height == 480){
                screenType = AppleIphone4;
            } else {
                screenType = AppleIphone5;
            }
        }break;
            
        case 375:
        {
            screenType = AppleIphone6;
        }break;
            
        case 414:
        {
            screenType = AppleIphone6plus;
        }break;
            
        default:
        {
            screenType = AppleIphone6;
        }break;
    }
    return screenType;
}

+(BOOL)isAppleIphone4Or5
{
    int width = [UIScreen mainScreen].bounds.size.width;
    if (width == 320)
    {
        return YES;
    }
    
    return NO;
}

+(BOOL)isAppleIphone5
{
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = [UIScreen mainScreen].bounds.size.height;
    if (width == 320 && height > 480)
    {
        return YES;
    }
    
    return NO;
}

+(BOOL)isAppleIphone6
{
    int width = [UIScreen mainScreen].bounds.size.width;
    if (width == 375)
    {
        return YES;
    }
    
    return NO;
}

+(BOOL)isAppleIphone6plus
{
    int width = [UIScreen mainScreen].bounds.size.width;
    if (width == 414)
    {
        return YES;
    }
    return NO;
}


/**
 * http://theiphonewiki.com/wiki/Models
 */

+ (NSString*) trimString:(NSString*)str
{
    if (!str)
        return nil;
    
    NSMutableString* mstring = [NSMutableString stringWithString:str];
    CFStringTrimWhitespace((CFMutableStringRef)mstring);
    return [mstring copy];
}

@end
