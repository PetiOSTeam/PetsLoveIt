//
//  AFHTTPClientUtil.m
//  TeamWork
//
//  Created by kongjun on 14-6-16.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import "AFHTTPClientUtil.h"
#import "NetworkAPI.h"


@implementation AFHTTPClientUtil


+ (instancetype) sharedClient{
    static AFHTTPClientUtil *_sharedClient = Nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFHTTPClientUtil alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return _sharedClient;
}




@end
