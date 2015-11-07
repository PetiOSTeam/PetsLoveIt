//
//  NetworkOperation.h
//  TeamWork
//
//  Created by kongjun on 14-6-17.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIOperation : NSObject

//获取url string
+ (NSString *) urlGET:(NSString*)URLString
           parameters:(id)parameters;

+ (void )GET:(NSString *)URLString
  parameters:(id)parameters
onCompletion:(void (^)(id responseData, NSError *error))completionBlock;

+ (void )POST:(NSString *)URLString
   parameters:(id)parameters
 onCompletion:(void (^)(id responseData, NSError *error))completionBlock;

+(void)uploadMedia:(NSString*)URLString parameters:(id)parameters
      onCompletion:(void (^)(id responseData, NSError* error))completionBlock;

+(void)uploadMutipleMedia:(NSString*)URLString parameters:(id)parameters
             onCompletion:(void (^)(id responseData, NSError* error))completionBlock;
+ (void)SEARCHGET:(NSInteger)indexForNum url:(NSString*)URLString
       parameters:(id)parameters
     onCompletion:(void (^)(id responseData, NSError* error,NSInteger indexNum))completionBlock;
@end
