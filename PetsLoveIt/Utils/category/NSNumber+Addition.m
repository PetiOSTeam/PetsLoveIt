//
//  NSNumber+Addition.m
//  TeamWork
//
//  Created by kongjun on 14-8-2.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import "NSNumber+Addition.h"

@implementation NSNumber (Addition)


-(NSString*)timestamp2date{
//    NSString * timeStampString =[NSString stringWithFormat:@"%@",self];
    NSTimeInterval _interval=[self doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"yyyy/MM/dd"];
    return [_formatter stringFromDate:date];
}
@end
