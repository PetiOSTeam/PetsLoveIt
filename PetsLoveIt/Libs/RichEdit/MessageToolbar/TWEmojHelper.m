//
//  TWEmojHelper.m
//  TeamWork
//
//  Created by jianlong on 15/4/15.
//  Copyright (c) 2015年 Shenghuo. All rights reserved.
//

#import "TWEmojHelper.h"
#import "Emoji.h"
#import "XLUtil.h"

static NSDictionary *emojCodeChineseMapDictionary;
static NSDictionary *emojCodePictureMapDictionary;

NSString *emojCodeRegx = @"\\[#&\\d{0,3}\\]+";
NSString *emojChineseRegx = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";

@interface TWEmojHelper ()
{
    NSRegularExpression *mEmojCodeRegx;
    NSRegularExpression *mEmojChineseRegx;
}

@end

@implementation TWEmojHelper

+ (TWEmojHelper *)shareInstance
{
    static TWEmojHelper *emojiHelper = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        emojiHelper = [[TWEmojHelper alloc] init];
        emojCodeChineseMapDictionary = [NSDictionary dictionaryWithContentsOfFile:filePathAtMainBundle(@"expression-chinese.plist")];
    });
    
    return emojiHelper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        mEmojCodeRegx = [[NSRegularExpression alloc] initWithPattern:emojCodeRegx options:NSRegularExpressionCaseInsensitive error:nil];
        mEmojChineseRegx = [[NSRegularExpression alloc] initWithPattern:emojChineseRegx options:NSRegularExpressionCaseInsensitive error:nil];
    }
    
    return self;
}

#pragma mark - Private Method

- (NSString *)getDictionaryKeyWithValue:(NSString *)aValue
{
    NSString *resultString = aValue;
    
    for (NSString *key in [emojCodeChineseMapDictionary allKeys]) {
        NSString *value = [emojCodeChineseMapDictionary objectForKey:key];
        
        if ([value isEqualToString:aValue]) {
            resultString = key;
            break;
        }
    }
    
    return resultString;
}

// 将字符串中得emoji表情code转化为描述 // [#&123] => [大哭]
- (NSString *)decodeEmojCodeToChineseWithText:(NSString *)aText {
    if (!aText) {
        return @"";
    }
    
    NSMutableString *retText = [[NSMutableString alloc] initWithString:aText];
    
    NSRange stringRange = NSMakeRange(0, aText.length);
    __block NSInteger stringOffset = 0;
    [mEmojCodeRegx enumerateMatchesInString:aText options:NSMatchingWithTransparentBounds range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange codeRange = result.range;
        codeRange.location -= stringOffset;
        
        NSString *codeString = [aText substringWithRange:result.range];
        NSString *replaceString = [self getDictionaryKeyWithValue:codeString];
        
        [retText replaceCharactersInRange:codeRange withString:replaceString];
        
        stringOffset += (codeRange.length - replaceString.length);
    }];
    
    return retText;
}

//  将字符串中得emoji表情描述转化为code // [大哭] => [#&123]
- (NSString *)encodeEmojChineseToCodeWithText:(NSString *)aText {
    NSMutableString *retText = [[NSMutableString alloc] initWithString:aText];
    
    NSRange stringRange = NSMakeRange(0, aText.length);
    __block NSInteger stringOffset = 0;
    [mEmojChineseRegx enumerateMatchesInString:aText options:NSMatchingWithTransparentBounds range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange codeRange = result.range;
        codeRange.location -= stringOffset;
        
        NSString *codeString = [aText substringWithRange:result.range];
        NSString *replaceString = [emojCodeChineseMapDictionary objectForKey:codeString];
        
        if (replaceString != nil) {
            [retText replaceCharactersInRange:codeRange withString:replaceString];
            
            stringOffset += (codeRange.length - replaceString.length);
        }
        
    }];
    
    return retText;
}

// 判断的输入是否是表情，是得话删除后返回
- (NSMutableString *)removeLastEmojChineseWithText:(NSString *)aText
{
    if (aText.length == 0) {
        return [NSMutableString stringWithString:@""];
    }
    
    NSMutableString *retText = [[NSMutableString alloc] initWithString:aText];
    
    NSRange stringRange = NSMakeRange(0, aText.length);
    NSArray *matchRes = [mEmojChineseRegx matchesInString:aText options:NSMatchingWithTransparentBounds range:stringRange];
    
    NSString *matchString = @"";
    for (NSTextCheckingResult *item in matchRes) {
        NSString *emojiString = [aText substringWithRange:item.range];
        
        if ([retText hasSuffix:emojiString]) {
            matchString = emojiString;
        }
    }
    
    if (matchString.length > 0) {
        NSUInteger location = aText.length == matchString.length ? 0 : (aText.length - matchString.length);
        [retText replaceCharactersInRange:NSMakeRange(location, matchString.length) withString:@""];
    }
    
    return retText;
}

// 检查光标的位置是否在emoj中，如果在，返回正常的range
- (NSRange)checkCousorInEmojRangeWithText:(NSString *)aText selectedRange:(NSRange)aSelectedRange
{
    NSRange stringRange = NSMakeRange(0, aText.length);
    NSArray *matchRes = [mEmojChineseRegx matchesInString:aText options:NSMatchingWithTransparentBounds range:stringRange];
    
    NSRange retRange = aSelectedRange;
    for (NSTextCheckingResult *item in matchRes) {
        NSRange itemRange = item.range;
        
        if (NSLocationInRange(aSelectedRange.location, itemRange) && aSelectedRange.location != itemRange.location) {
            retRange = NSMakeRange(itemRange.location, 0);
            break;
        }
    }
    
    return retRange;
}

#pragma mark - Static Method
// 检查光标的位置是否在emoj中，如果在，返回正常的range
+ (NSRange)checkCousorInEmojRangeWithText:(NSString *)aText selectedRange:(NSRange)aSelectedRange
{
    return [[TWEmojHelper shareInstance] checkCousorInEmojRangeWithText:aText selectedRange:aSelectedRange];
}

// 将字符串中得emoji表情code转化为描述 // [#&123] => [大哭]
+ (NSString *)decodeEmojCodeToChineseWithText:(NSString *)aText {
    return [[TWEmojHelper shareInstance] decodeEmojCodeToChineseWithText:aText];
}

//  将字符串中得emoji表情描述转化为code // [大哭] => [#&123]
+ (NSString *)encodeEmojChineseToCodeWithText:(NSString *)aText {
    return [[TWEmojHelper shareInstance] encodeEmojChineseToCodeWithText:aText];
}

// 判断的输入是否是表情，是得话删除后返回
+ (NSMutableString *)removeLastEmojChineseWithText:(NSString *)aText
{
    return [[TWEmojHelper shareInstance] removeLastEmojChineseWithText:aText];
}

+ (NSString *)convertToCommonEmoticons:(NSString *)text {
    NSInteger allEmoticsCount = [Emoji allEmoji].count;
    NSMutableString *retText = [[NSMutableString alloc] initWithString:text];
    for(int i=0; i<allEmoticsCount; ++i) {
        NSRange range;
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😊"
                                 withString:@"[):]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😃"
                                 withString:@"[:D]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😉"
                                 withString:@"[;)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😮"
                                 withString:@"[:-o]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😋"
                                 withString:@"[:p]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😎"
                                 withString:@"[(H)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😡"
                                 withString:@"[:@]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😖"
                                 withString:@"[:s]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😳"
                                 withString:@"[:$]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😞"
                                 withString:@"[:(]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😭"
                                 withString:@"[:'(]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😐"
                                 withString:@"[:|]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😇"
                                 withString:@"[(a)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😬"
                                 withString:@"[8o|]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😆"
                                 withString:@"[8-|]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😱"
                                 withString:@"[+o(]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🎅"
                                 withString:@"[<o)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😴"
                                 withString:@"[|-)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😕"
                                 withString:@"[*-)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😷"
                                 withString:@"[:-#]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😯"
                                 withString:@"[:-*]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😏"
                                 withString:@"[^o)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"😑"
                                 withString:@"[8-)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"💖"
                                 withString:@"[(|)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"💔"
                                 withString:@"[(u)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🌙"
                                 withString:@"[(S)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🌟"
                                 withString:@"[(*)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🌞"
                                 withString:@"[(#)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🌈"
                                 withString:@"[(R)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        
        [retText replaceOccurrencesOfString:@"😚"
                                 withString:@"[(})]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        
        [retText replaceOccurrencesOfString:@"😍"
                                 withString:@"[({)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"💋"
                                 withString:@"[(k)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🌹"
                                 withString:@"[(F)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"🍂"
                                 withString:@"[(W)]"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"👍"
                                 withString:@"[(D)]"
                                    options:NSLiteralSearch
                                      range:range];
    }
    
    return retText;
}

+ (NSString *)convertToSystemEmoticons:(NSString *)text {
    NSInteger allEmoticsCount = [Emoji allEmoji].count;
    NSMutableString *retText = [[NSMutableString alloc] initWithString:text];
    for(int i=0; i<allEmoticsCount; ++i) {
        NSRange range;
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[):]"
                                 withString:@"😊"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:D]"
                                 withString:@"😃"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[;)]"
                                 withString:@"😉"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:-o]"
                                 withString:@"😮"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:p]"
                                 withString:@"😋"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(H)]"
                                 withString:@"😎"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:@]"
                                 withString:@"😡"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:s]"
                                 withString:@"😖"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:$]"
                                 withString:@"😳"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:(]"
                                 withString:@"😞"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:'(]"
                                 withString:@"😭"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:|]"
                                 withString:@"😐"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(a)]"
                                 withString:@"😇"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[8o|]"
                                 withString:@"😬"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[8-|]"
                                 withString:@"😆"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[+o(]"
                                 withString:@"😱"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[<o)]"
                                 withString:@"🎅"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[|-)]"
                                 withString:@"😴"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[*-)]"
                                 withString:@"😕"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:-#]"
                                 withString:@"😷"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:-*]"
                                 withString:@"😯"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[^o)]"
                                 withString:@"😏"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[8-)]"
                                 withString:@"😑"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(|)]"
                                 withString:@"💖"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(u)]"
                                 withString:@"💔"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(S)]"
                                 withString:@"🌙"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(*)]"
                                 withString:@"🌟"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(#)]"
                                 withString:@"🌞"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(R)]"
                                 withString:@"🌈"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        
        [retText replaceOccurrencesOfString:@"[(})]"
                                 withString:@"😚"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        
        [retText replaceOccurrencesOfString:@"[({)]"
                                 withString:@"😍"
                                    options:NSLiteralSearch
                                      range:range];
        
        
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(k)]"
                                 withString:@"💋"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(F)]"
                                 withString:@"🌹"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(W)]"
                                 withString:@"🍂"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(D)]"
                                 withString:@"👍"
                                    options:NSLiteralSearch
                                      range:range];
    }
    
    return retText;
}

@end
