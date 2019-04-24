//
//  HXCheckNumber.m
//  newHfax
//
//  Created by 出神入化 on 2017/7/5.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXCheckNumber.h"
@implementation HXCheckNumber

+ (BOOL)check:(NSString *)pattern checkString:(NSString *)checkString
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:checkString];
}

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber
{
    if(!telNumber.length) return NO;
//  return  [self check:@"^1([0-9]{10})" checkString:telNumber];
    NSString *headString = [telNumber substringToIndex:1];
    NSString *footString = [telNumber substringFromIndex:1];
    if (telNumber.length != 11) {
        return NO;
    }
    if (![headString isEqualToString:@"1"]) {
        return NO;
    }
    if (![self check:@"^[0-9]{10}" checkString:footString]) {
        return NO;
    }
    return YES;
}

//#pragma 正则匹配用户密码8-16位数字和字母组合

//+ (BOOL)checkPassword:(NSString *)password
//{
//    return  [self check:@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,16}" checkString:password];
//}

#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard:(NSString *)value
{
    /**************************为了方便测试,********************************/
    if (value.length != 15 && value.length != 18) {
        return NO;
    }
    if (value.length > 0) {
        NSString *headString = [value substringToIndex:value.length-1];
        NSString *footString = [value substringFromIndex:value.length-1];
        if (![self check:@"^[0-9]{14,17}" checkString:headString]) {
            return NO;
        }
        
        if ([footString isEqualToString:@"x"] || [footString isEqualToString:@"X"] || [self check:@"^[0-9]{1}" checkString:footString]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    /*********以上是为了方便测试,若正式发包,将上述代码注释掉,打开下面的代码*****************/

    
    
    /********************以下是实际的身份证号码校验代码********************************/
//    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    
//    NSInteger length = 0;
//    
//    if (!value) {
//        return NO;
//    }
//    else {
//        length = (int)value.length;
//        
//        if (length !=15 && length !=18) {
//            return NO;
//        }
//    }
//    // 省份代码
//    NSArray *areasArray =@[@"11",@"12",@"13",@"14",@"15",@"21",@"22",@"23",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"41",@"42",@"43",@"44",@"45",@"46",@"50",@"51",@"52",@"53",@"54",@"61",@"62",@"63",@"64",@"65",@"71",@"81",@"82",@"91"];
//    
//    NSString *valueStart2 = [value substringToIndex:2];
//    
//    BOOL areaFlag =NO;
//    
//    for (NSString *areaCode in areasArray) {
//        
//        if ([areaCode isEqualToString:valueStart2]) {
//            areaFlag =YES;
//            break;
//        }
//    }
//    
//    if (!areaFlag) {
//        return NO;
//    }
//    
//    NSRegularExpression *regularExpression;
//    NSUInteger numberofMatch;
//    NSInteger year =0;
//    switch (length) {
//        case 15:{
//            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
//            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
//                                                                       options:NSRegularExpressionCaseInsensitive
//                                                                         error:nil];//测试出生日期的合法性
//            }else {
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
//                                                                       options:NSRegularExpressionCaseInsensitive
//                                                                         error:nil];//测试出生日期的合法性
//            }
//            numberofMatch = [regularExpression numberOfMatchesInString:value
//                                                               options:NSMatchingReportProgress
//                                                                 range:NSMakeRange(0, value.length)];
//            
//            if(numberofMatch >0) {
//                return YES;
//            }else {
//                return NO;
//            }
//        }
//        case 18:
//            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
//            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
//                                                                       options:NSRegularExpressionCaseInsensitive
//                                                                         error:nil];//测试出生日期的合法性
//            }else {
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
//                                                                       options:NSRegularExpressionCaseInsensitive
//                                                                         error:nil];//测试出生日期的合法性
//            }
//            numberofMatch = [regularExpression numberOfMatchesInString:value
//                                                               options:NSMatchingReportProgress
//                                                                 range:NSMakeRange(0, value.length)];
//            
//            if(numberofMatch >0) {
//                
//                NSInteger S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
//                
//                NSInteger Y = S %11;
//                
//                NSString *M =@"F";
//                
//                NSString *JYM =@"10X98765432";
//                
//                M = [JYM substringWithRange:NSMakeRange(Y,1)];//判断校验位
//                
//                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
//                    return YES;// 检测ID的校验位
//                }else {
//                    return NO;
//                }
//            }else {
//                
//                return NO;
//            }
//        default:
//            return NO;
//    }
    
    
    return YES;
}

//#pragma 正则匹配银行卡号
//+ (BOOL)checkBankCardNo:(NSString *)cardNo
//{
//    /********已与测试和安卓沟通,取消银行卡号本地校验;卡号位数校验已经在页面判断,此处无需处理*****/
//    return YES;

//    NSInteger oddsum = 0;    //奇数求和
//    NSInteger evensum = 0;    //偶数求和
//    NSInteger allsum = 0;
//    NSInteger cardNoLength = (int)[cardNo length];
//    NSInteger lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
//    
//    cardNo = [cardNo substringToIndex:cardNoLength -1];
//    for (NSInteger i = cardNoLength -1 ; i>=1;i--) {
//        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1,1)];
//        NSInteger tmpVal = [tmpString intValue];
//        if (cardNoLength % 2 ==1 ) {
//            if((i % 2) == 0){
//                tmpVal *= 2;
//                if(tmpVal>=10)
//                    tmpVal -= 9;
//                evensum += tmpVal;
//            }else{
//                oddsum += tmpVal;
//            }
//        }else{
//            if((i % 2) == 1){
//                tmpVal *= 2;
//                if(tmpVal>=10)
//                    tmpVal -= 9;
//                evensum += tmpVal;
//            }else{
//                oddsum += tmpVal;
//            }
//        }
//    }
//    
//    allsum = oddsum + evensum;
//    allsum += lastNum;
//    if((allsum % 10) ==0)
//        return YES;
//    else
//        return NO;
    
//}

#pragma 正则匹配邮箱
+ (BOOL)checkEmail:(NSString *)email
{
    if ([email rangeOfString:@"@"].location != NSNotFound) {//包含@
        NSArray *stringArr = [email componentsSeparatedByString:@"@"];
        if ([stringArr[0] length] < 2 ||  [stringArr[0] length] > 32) {
            return NO;
        }
    } else {
        return NO;
    }
    return  [self check:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" checkString:email];
}

#pragma 正则匹配用户中文真实姓名,2-15位
+ (BOOL)checkUserName:(NSString *)userName
{
    /*
    NSRange range1 = [userName rangeOfString:@"·"];
    NSRange range2 = [userName rangeOfString:@"•"];
    if(range1.location != NSNotFound ||   // 中文 ·
       range2.location != NSNotFound )    // 英文 •
    {//一般中间带 `•`的名字长度不会超过15位，如果有那就设高一点
        if ([userName length] < 2 || [userName length] > 15)
        {
            return NO;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+[·•][\u4e00-\u9fa5]+$" options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:userName options:0 range:NSMakeRange(0, [userName length])];
        
        NSUInteger count = [match numberOfRanges];
        
        return count == 1;
    } else {//一般正常的名字长度不会少于2位并且不超过8位，如果有那就设高一点
        if ([userName length] < 2 || [userName length] > 15) {
            return NO;
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\u4e00-\u9fa5]+$" options:0 error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:userName options:0 range:NSMakeRange(0, [userName length])];
        
        NSUInteger count = [match numberOfRanges];
        
        return count == 1;
    }
     return NO;*/
     
    //和安卓校验规则保持一致,只检测长度
    return (userName.length > 1 && userName.length < 30) ? YES : NO;
    
}

#pragma 正则匹配6位(纯数字)验证码
+ (BOOL)checkMessageCode:(NSString *)messageCode;
{
    return  [self check:@"^[0-9]{4,6}" checkString:messageCode];
}


#pragma 8-16位(所以输入密码校验)密码
+ (NSString *)erorMessageFromCheckLoginPassword:(NSString *)password{
    if (password.length<8) return @"请输入至少8位密码";
    else if (password.length>16) return @"最高支持16位密码";
    return nil;
}

//6-16位登录密码，需包含英文字母和数字
+ (NSString *)erorMessageFromCheckSetLoginPassword:(NSString *)password{
    if (password.length<8||password.length>16||![self CheckContainsNumberChar:password]||![self CheckContainsEnglishChar:password]) return @"请输入8-16位数字及字母集合";
    return nil;
}


#pragma 6-16位()交易密码
+ (NSString *)erorMessageFromCheckTradePassword:(NSString *)password
{
    if (password.length<6) return @"请输入至少6位密码";
    else if (password.length>16) return @"最高支持16位密码";
    
    return nil;
}

+ (NSString *)erorMessageFromCheckSetTradePassword:(NSString *)tradePassword{
    BOOL check = (tradePassword.length>=6)&&(tradePassword.length<=16);
    if(check)
        check = [self checkIsOrderNumber:tradePassword];
    else
        return @"请输入6-16位数字及字符集合";
    if(!check)
        check = [self checkEqualStr:tradePassword];
    else
        return @"请勿使用连续数字作为密码";
    if(!check)
        check = [self checkIsStartWithSpecialChar:tradePassword];
    else
        return @"请勿使用单一字符作为密码";
    if(check)
        return @"请勿使用特殊字符开头作为密码";
    return nil;
}

//#pragma 是否包含特殊字符
/**
 * 是否是相同的字符
 * @param numOrStr
 * @return
 */
+ (BOOL)checkEqualStr:(NSString *)numOrStr{
    BOOL flag = true;
    char str = [numOrStr characterAtIndex:0];
    for (NSInteger i = 0; i < numOrStr.length; i++) {
        if (str != [numOrStr characterAtIndex:i]) {
            flag = false;
            break;
        }
    }
    return flag;
}

+ (BOOL)checkCharacterIsNumber:(char)schar{
    for (NSInteger i = 0; i < 10; i++) {
        if (schar == [@"0123456789" characterAtIndex:i]) {
            return YES;
        }
    }
    return NO;
}
/**
 * 是否是连续的数字
 * @param numOrStr
 * @return
 */
+ (BOOL)checkIsOrderNumber:(NSString *) numOrStr{
    BOOL flag = true;//如果全是连续数字返回true
    BOOL isNumeric = true;//如果全是数字返回true
    for (NSInteger i = 0; i < numOrStr.length; i++) {
        if (![self checkCharacterIsNumber:[numOrStr characterAtIndex:i]]) {
            isNumeric = false;
            break;
        }
    }
    if (isNumeric) {//如果全是数字则执行是否连续数字判断
        for (NSInteger i = 0; i < numOrStr.length; i++) {
            if (i > 0) {//判断如123456
                NSInteger num = [[numOrStr substringWithRange:NSMakeRange(i, 1)] intValue];
                NSInteger num_ = [[numOrStr substringWithRange:NSMakeRange(i-1, 1)] intValue]+1;
                if (num != num_) {
                    flag = false;
                    break;
                }
            }
        }
        if (!flag) {
            flag = true;
            for (NSInteger i = 0; i < numOrStr.length; i++) {
                if (i > 0) {//判断如654321
                    NSInteger num = [[numOrStr substringWithRange:NSMakeRange(i, 1)] intValue];
                    NSInteger num_ = [[numOrStr substringWithRange:NSMakeRange(i, 1)] intValue]-1;
                    if (num != num_) {
                        flag = false;
                        break;
                    }
                }
            }
        }
    } else {
        flag = false;
    }
    return flag;
}

/**
 * 是否是特殊字符开头
 * @param pwd
 * @return
 */
+ (BOOL)checkIsStartWithSpecialChar:(NSString *) pwd {
    if (pwd.length) {
        return ![self check:@"^[0-9a-zA-Z].*$" checkString:pwd];
    }
    return false;
}

/**
 * 是否含有特殊字符
 * @param pwd
 * @return
 */
+ (BOOL)CheckContainsSpecialChar:(NSString *) pwd {
    if (pwd.length) {
        return ![self check:@"^[0-9a-zA-Z]+$" checkString:pwd];
    }
    return false;
}

/**
 * 是否含有数字
 * @param pwd
 * @return
 */
+ (BOOL)CheckContainsNumberChar:(NSString *) pwd {
    
    //數字條件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合數字條件的有幾個字元
    NSInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:pwd
                                                                      options:NSMatchingReportProgress
                                                                        range:NSMakeRange(0, pwd.length)];
    return tNumMatchCount>0;
}

/**
 * 是否含有英文字母
 * @param pwd
 * @return
 */
+ (BOOL)CheckContainsEnglishChar:(NSString *) pwd {
    //英文字條件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合英文字條件的有幾個字元
    NSInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:pwd options:NSMatchingReportProgress range:NSMakeRange(0, pwd.length)];
    
    return tLetterMatchCount>0;
}


+ (BOOL)validateNickname:(NSString *)nickname
{

    return  [self CheckContainsSpecialChar:nickname];
}


@end
