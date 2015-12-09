//
//  CommentModel.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/5.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CommentModel.h"

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

@end
