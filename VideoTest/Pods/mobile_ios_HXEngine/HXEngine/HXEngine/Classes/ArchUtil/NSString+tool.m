//
//  NSString+tool.m
//  newHfax
//
//  Created by 张驰 on 2017/7/24.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "NSString+tool.h"

@implementation NSString (tool)
+(BOOL)isNullString:(NSString *)string{
    if (string == nil || [string isEqualToString:@""] || string == NULL || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
+(NSString *)amountFormatString:(NSString *)string{
    if ([self isNullString:string]||string.floatValue<=0) {
        return @"0.00";
    }else return string;
}
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString dateFormat:(NSString *)dateType
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //[formatter setDateFormat:@"yyyy.MM.dd"];
    [formatter setDateFormat:dateType];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

//输入的字符串转成金额 单位分
- (long)amountCentValue{
    NSString *relStr = [self stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSRange pointRange = [relStr rangeOfString:@"."];
    if(pointRange.location != NSNotFound){
        if(pointRange.location==relStr.length-1){//最后一位 123.
            relStr = [relStr stringByReplacingOccurrencesOfString:@"." withString:@"00"];
        }else if (pointRange.location==relStr.length-2){//123.3
            relStr = [relStr stringByReplacingOccurrencesOfString:@"." withString:@""];
            relStr = [relStr stringByAppendingString:@"0"];
        }else{//123.12 123.2344
            relStr = [relStr stringByReplacingOccurrencesOfString:@"." withString:@""];
            relStr = [relStr substringToIndex:pointRange.location+2];
        }
        return [relStr longLongValue];
    }else{
        return [relStr longLongValue]*100;
    }
}

+ (NSString *)filterSpaseString:(NSString*)string
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

////输入的字符串转成金额 单位元
//-(double)amountYuanValue{
//    long cent = [self amountCentValue];
//    NSMutableString *centString = [NSMutableString stringWithString:@(cent).stringValue];
//    if(centString.length>=3){
//        [centString insertString:@"." atIndex:centString.length-1];
//    }else if(centString.length>=2){
//        [centString insertString:@"0." atIndex:0];
//      }else{
//          [centString insertString:@"0.0" atIndex:0];
//      }
//   return [centString doubleValue];
//}
@end
