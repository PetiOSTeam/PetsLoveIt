//
//  TWEmojHelper.h
//  TeamWork
//
//  Created by jianlong on 15/4/15.
//  Copyright (c) 2015年 Shenghuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWEmojHelper : NSObject

+ (TWEmojHelper *)shareInstance;

+ (NSString *)convertToCommonEmoticons:(NSString *)text;
+ (NSString *)convertToSystemEmoticons:(NSString *)text;

// 将字符串中得emoji表情code转化为描述 // [#&123] => [大哭]
+ (NSString *)decodeEmojCodeToChineseWithText:(NSString *)aText;
//  将字符串中得emoji表情描述转化为code // [大哭] => [#&123]
+ (NSString *)encodeEmojChineseToCodeWithText:(NSString *)aText;

// 判断的输入是否是表情，是得话删除后返回  
+ (NSMutableString *)removeLastEmojChineseWithText:(NSString *)aText;

// 检查光标的位置是否在emoj中，如果在，返回正常的range
+ (NSRange)checkCousorInEmojRangeWithText:(NSString *)aText selectedRange:(NSRange)aSelectedRange;

@end
