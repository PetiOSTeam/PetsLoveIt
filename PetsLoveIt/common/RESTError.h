//
//  RESTError.h
//  TeamWork
//
//  Created by kongjun on 14-6-17.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRequestErrorDomain @"HTTP_ERROR"       //  HTTP错误
#define kBusinessErrorDomain @"BISSINESS_ERROR" //  业务逻辑错误

@interface RESTError : NSError

@end
