//
//  AFHTTPClientForiOS6AndLower.m
//  TeamWork
//
//  Created by kongjun on 14-7-30.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import "AFHTTPClientForiOS6OrLower.h"

@implementation AFHTTPClientForiOS6OrLower
+ (instancetype) sharedClient{
    static AFHTTPClientForiOS6OrLower *_sharedClient = Nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFHTTPClientForiOS6OrLower alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return _sharedClient;
}
@end
