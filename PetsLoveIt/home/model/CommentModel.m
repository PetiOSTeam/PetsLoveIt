//
//  CommentModel.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/5.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CommentModel.h"
#import "TWEmojHelper.h"
@implementation CommentModel

+(NSArray *)modelPrepare:(id)obj{
    NSData *jsonData = [obj[@"page_rows"] dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        return jsonArray;

    }else{
        return obj[@"rows"][@"rows"];
    }
}
- (NSString *)content{
        _content = [TWEmojHelper encodeEmojChineseToCodeWithText:_content];
    return _content;
}
- (NSString *)otherContent{
    _otherContent = [TWEmojHelper encodeEmojChineseToCodeWithText:_otherContent];
    return _otherContent;
}
@end
