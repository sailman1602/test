//
//  HXCheckNumber.h
//  newHfax
//
//  Created by 出神入化 on 2017/7/5.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXCheckNumber : NSObject

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber;

#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard:(NSString *)value;

//#pragma 正则匹配银行卡号
//+ (BOOL)checkBankCardNo:(NSString *)cardNo;

#pragma 正则匹配邮箱
+ (BOOL)checkEmail:(NSString *)email;

#pragma 正则匹配用户中文真实姓名,2-15位
+ (BOOL)checkUserName:(NSString *)userName;

#pragma 正则匹配6位(纯数字)验证码
+ (BOOL)checkMessageCode:(NSString *)messageCode;


//返回参数：errorMsg,如果为nil则校验通过，
//+ (NSString *)erorMessageFromCheckPassword:(NSString *)password;
//
//+ (NSString *)erorMessageFromCheckSetPassword:(NSString *)tradePassword;

#pragma 8-16位(登录密码校验)密码
+ (NSString *)erorMessageFromCheckLoginPassword:(NSString *)password;

+ (NSString *)erorMessageFromCheckSetLoginPassword:(NSString *)tradePassword;

#pragma 6-16位(交易密码校验)密码
+ (NSString *)erorMessageFromCheckTradePassword:(NSString *)password;

//返回参数：errorMsg,如果为nil则校验通过，
+ (NSString *)erorMessageFromCheckSetTradePassword:(NSString *)tradePassword;

@end
