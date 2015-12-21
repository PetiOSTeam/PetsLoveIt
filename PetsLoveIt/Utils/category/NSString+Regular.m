//
//  NSString+Regular.m
//  smartcity
//
//  Created by kongjun on 13-11-1.
//  Copyright (c) 2013年 junfrost. All rights reserved.
//

#import "NSString+Regular.h"

@implementation NSString (Regular)

- (BOOL)isValidateEmail
{
    NSString *regex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isValidateName
{
    NSString *regex = @"^[a-zA-Z0-9\u4e00-\u9fa5\\-_()\\[\\]]{1,12}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isNumber
{
    NSString *regex = @"^[0-9]*(.)?[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isEnglishWords
{
    NSString *regex = @"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

//字母数字下划线，6－18位
- (BOOL)isValidatePassword
{
    NSString *regex = @"^[\\w\\d_]{6,18}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isChineseWords
{
    NSString *regex = @"^[\\u4E00-\\u9FA5\\uF900-\\uFA2D]+$";
//    NSString *regex = @"^[\u4e00-\u9fa5],{0,100}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isInternetUrl
{
    NSString *regex = @"^http://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$ ；^[a-zA-z]+://(w+(-w+)*)(.(w+(-w+)*))*(?S*)?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}
- (BOOL)isPhoneNumber{
//    NSString * MOBILE = @"((\\+86)|(86))?(1)\\d{10}$";
    
    NSString * MOBILE = @"1[3458]([0-9]){9}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if (([regextestmobile evaluateWithObject:self] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isPhoneNumber_backup
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
    */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isElevenDigitNum
{
    NSString *regex = @"^[0-9]*$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predicate evaluateWithObject:self];
    
    if (result && self.length == 11)
        return YES;
    
    return NO;
}
//密码验证6-25位，数字｜字母｜符号三者选2
- (BOOL)passwordCheckStrength {
   
    BOOL hasChar;
    BOOL hasSpecialChar;
    BOOL hasNumber;
    
    // 1. Upper case.
    //if (![[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[password characterAtIndex:0]])
        //return NO;
    
    // 2. Length.
    if ([self length] < 6||[self length]>25)
        return NO;
    
    
    // 3. Special characters.
    // Change the specialCharacters string to whatever matches your requirements.
    NSString *specialCharacters = @"!#€%&/()[]=?$§*'";
    if ([[self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:specialCharacters]] count] < 2){
        hasSpecialChar=NO;
    }else{
        hasSpecialChar=YES;
    }
    
    
    // 4. Numbers.
    if ([[self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]] count] < 2){
        hasNumber=NO;
    }else{
        hasNumber=YES;
    }
    
    // characters
    NSString *characters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    if ([[self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:characters]] count] < 2){
        hasChar=NO;
    }else{
        hasChar=YES;
    }
    
    
    return (hasChar&&hasNumber)||(hasChar&&hasSpecialChar)||(hasNumber&&hasSpecialChar);
}
//最后一位为"."
- (BOOL)checkLastCharaterIsDot{
    NSString *regex =@".$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predicate evaluateWithObject:self];
    return result;
}

//验证二位小数
- (BOOL)checkTwoPlaceDecimal{
    
    NSString *regex =@"^[0-9]+(.[0-9]{1,2})?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predicate evaluateWithObject:self];
    return result;
}

- (BOOL)isIdentifyCardNumber
{
    int length = 0;
    if (!self) {
        return NO;
    }else {
        length =(int) self.length;
        
        if (length != 15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91"];
    
    NSString *valueStart2 = [self substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag = YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year = 0;
    switch (length) {
        case 15:
            year = [self substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];// 测试出生日期的合法性
            } else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:self
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, self.length)];
            
            if(numberofMatch > 0) {
                return YES;
            } else {
                return NO;
            }
        case 18:
            
            year = [self substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];// 测试出生日期的合法性
            } else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:self
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, self.length)];
            
            
            if (numberofMatch > 0) {
                int S = ([self substringWithRange:NSMakeRange(0,1)].intValue + [self substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([self substringWithRange:NSMakeRange(1,1)].intValue + [self substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([self substringWithRange:NSMakeRange(2,1)].intValue + [self substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([self substringWithRange:NSMakeRange(3,1)].intValue + [self substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([self substringWithRange:NSMakeRange(4,1)].intValue + [self substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([self substringWithRange:NSMakeRange(5,1)].intValue + [self substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([self substringWithRange:NSMakeRange(6,1)].intValue + [self substringWithRange:NSMakeRange(16,1)].intValue) *2 + [self substringWithRange:NSMakeRange(7,1)].intValue *1 + [self substringWithRange:NSMakeRange(8,1)].intValue *6 + [self substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S % 11;
                NSString *M = @"F";
                NSString *M_x = @"F";
                NSString *JYM = @"10X98765432";
                NSString *JYM_x = @"10x98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)]; // 判断校验位
                M_x=[JYM_x substringWithRange:NSMakeRange(Y,1)];
                if ([M isEqualToString:[self substringWithRange:NSMakeRange(17,1)]]||[M_x isEqualToString:[self substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                } else {
                    return NO;
                }
                
            } else {
                return NO;
            }
        default:
            return false;
    }
}

-(NSString*)timechangeWithTimest
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self intValue]];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * morelocationString=[dateformatter stringFromDate:date];
    return morelocationString;
}

-(NSString*)timechangeWithMass
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self intValue]];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM月dd日"];
    NSString * morelocationString=[dateformatter stringFromDate:date];
    return morelocationString;
}

-(NSString*)timechangeWithSquareList
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self intValue]];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd"];
    NSString * morelocationString=[dateformatter stringFromDate:date];
    return morelocationString;
}

- (BOOL)isNotEmpty
{
    if ([self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        return YES;
    }
    return NO;
}

-(NSDate *)NSStringDateToNSDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
   // [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //#define kDEFAULT_DATE_TIME_FORMAT (@"yyyy-MM-dd'T'HH:mm:ss'Z'")
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [formatter dateFromString:self];
    return date;
}

@end
