//
//  HXEngineConfigFile.m
//  AFNetworking
//
//  Created by sh on 2018/11/27.
//

#import <UIKit/UIKit.h>
#import "HXEngineConfiguration.h"
#import "UIColor+Factory.h"

//#define ConfigColorRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@implementation HXEngineConfiguration

+ (instancetype)sharedInstance {
    static HXEngineConfiguration *file = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        file = [[HXEngineConfiguration alloc]init];
    });
    return file;
}

- (void)ucardConfiguration {
    self.toastSetting = YES;
    
    self.contentColor = [UIColor colorWithRGB:0x979797];
    self.bgColor = [UIColor colorWithRGB:0x363349];
    self.cornerRadius = 5;
    self.alpha = 0.9;
    
    self.textColor = [UIColor colorWithRGB:0xEAEAEA];
    self.textFont = [UIFont systemFontOfSize:12];
}

@end
