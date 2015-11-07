//
//  NSString+Regular.h
//  smartcity
//
//  Created by kongjun on 13-11-1.
//  Copyright (c) 2013年 junfrost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regular)

- (BOOL)isValidateEmail;//邮箱符合性验证。
- (BOOL)isValidateName; // 是否是合法名字。目前只允许大小写的字母、中文、数字、­_、-、(、）
- (BOOL)isNumber;//全是数字。
- (BOOL)isEnglishWords;//验证英文字母。
- (BOOL)isValidatePassword;//验证密码：6—18位，只能包含字符、数字和 下划线。
- (BOOL)isChineseWords;//验证是否为汉字。
- (BOOL)isInternetUrl;//验证是否为网络链接。
- (BOOL)isPhoneNumber;//验证是否为电话号码。正确格式为：XXXX-XXXXXXX，XXXX-XXXXXXXX，XXX-XXXXXXX，XXX-XXXXXXXX，XXXXXXX，XXXXXXXX
- (BOOL)isElevenDigitNum;//判断是否为11位的数字
- (BOOL)isIdentifyCardNumber;//验证15或18位身份证。
- (BOOL)isNotEmpty;//判断去除空格后是否为空

//密码验证最少8位，数字｜字母｜符号三者选2
- (BOOL)passwordCheckStrength;
//最后一位为"."
- (BOOL)checkLastCharaterIsDot;
//验证二位小数
- (BOOL)checkTwoPlaceDecimal;
//时间戳转时间
-(NSString*)timechangeWithTimest;
-(NSString*)timechangeWithMass;
//
-(NSString*)timechangeWithSquareList;
-(NSDate *)NSStringDateToNSDate;
@end
