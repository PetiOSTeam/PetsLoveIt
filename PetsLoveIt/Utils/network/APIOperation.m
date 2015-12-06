//
//  NetworkOperation.m
//  TeamWork
//
//  Created by kongjun on 14-6-17.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import "APIOperation.h"
#import "RESTError.h"
#import "OpenUDID.h"


#define kAFHttpClient ((CURRENT_SYS_VERSION< 7.0)?mAFHTTPClientForiOS6OrLower:mAFHTTPClient)
#define kServerErrorTip @"服务器维护中，请稍后再试"

@implementation APIOperation

+ (NSMutableDictionary *)paramsWithToken:(id) parameters{
    //加token，deviceId,userId
    NSMutableDictionary *kParameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    NSString *serverUdid = [AppCache getServerUDID];
    if (serverUdid && [serverUdid length]>0)
       [kParameters setObject:serverUdid forKey:@"udid"];
    if ([[AppCache getToken] length]>0) {
        [kParameters setObject:[AppCache getToken] forKey:@"userToken"];
    }
    return kParameters;
}

+ (void)tokenFailed:(NSString *) tokenFailInfo{
    if ([tokenFailInfo integerValue] == -1 ) {
        [mAppDelegate autoLogin];
    }
    
}

//获取url string
+ (NSString *) urlGET:(NSString*)URLString
           parameters:(id)parameters{
    id AFHttpClient=kAFHttpClient;
    //加token，deviceId,userId
    NSMutableDictionary *kParameters = [APIOperation paramsWithToken:parameters];
    NSString *urlString = [AFHttpClient urlGET:URLString parameters:kParameters];
    return  urlString;
}
//备用的get方法，去除了rtnCode处理
+ (void)GET_2:(NSString*)URLString
 parameters:(id)parameters
onCompletion:(void (^)(id responseData, NSError* error))completionBlock
{
    
    id AFHttpClient=kAFHttpClient;
    //加token，deviceId,userId
    NSMutableDictionary *kParameters = [APIOperation paramsWithToken:parameters];
    [AFHttpClient GET:URLString parameters:kParameters success:^(id operation, id responseObject) {
        
        NSDictionary *dataDict= responseObject;
        RESTError *restError = nil;

        //token异常重新登录
        [APIOperation tokenFailed:[responseObject objectForKey:@"rtnCode"]];
        if (completionBlock) {
            completionBlock(dataDict,restError);
        }
    } failure:^(id operation, NSError* error) {
        
        if (![mAppUtils hasConnectivity]) {
            [mAppUtils showHint:kNetWorkUnReachableDesc];
            if (completionBlock) {
                completionBlock(nil,error);
            }
            return ;
        }

        RESTError *restError = [[RESTError alloc] initWithDomain:kRequestErrorDomain
                                                            code:[error code]
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  kServerErrorTip, ERRORMSG,
                                                                  [NSString stringWithFormat:@"%ld",(long)[error code]],ERRORCODE , nil]];
        if (completionBlock) {
            completionBlock (nil,restError);
        }
    }];
}

+ (void)GET:(NSString*)URLString
      parameters:(id)parameters
    onCompletion:(void (^)(id responseData, NSError* error))completionBlock
{
    
    id AFHttpClient=kAFHttpClient;
    //加token，deviceId,userId
    NSMutableDictionary *kParameters = [APIOperation paramsWithToken:parameters];
    [AFHttpClient GET:URLString parameters:kParameters success:^(id operation, id responseObject) {
        
        NSString *code = [responseObject objectForKey:@"rtnCode"];
        NSDictionary *dataDict= responseObject;
        RESTError *restError = nil;
        if (![code isKindOfClass:[NSString class]]) {
            code = [NSString stringWithFormat:@"%@",code];
        }
        //业务逻辑错误
        if(![[code uppercaseString] isEqualToString:@"1"])
        {
            #if defined (CONFIGURATION_DEBUG)
            restError = [[RESTError alloc] initWithDomain:kBusinessErrorDomain
                                                     code:0
                                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@,%@",URLString,[responseObject objectForKey:kMessage]], ERRORMSG,[responseObject objectForKey:@"rtnCode"], ERRORCODE, nil]];
            #else
            restError = [[RESTError alloc] initWithDomain:kBusinessErrorDomain
                                                     code:0
                                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[responseObject objectForKey:kMessage]], ERRORMSG,[responseObject objectForKey:@"rtnCode"], ERRORCODE, nil]];
            #endif
            
        }
        //token异常重新登录
        [APIOperation tokenFailed:[responseObject objectForKey:@"rtnCode"]];
        if (completionBlock) {
            completionBlock(dataDict,restError);
        }
    } failure:^(id operation, NSError* error) {
        
        if (![mAppUtils hasConnectivity]) {
            [mAppUtils showHint:kNetWorkUnReachableDesc];
            if (completionBlock) {
                completionBlock(nil,error);
            }
            return ;
        }
        #if defined (CONFIGURATION_DEBUG)
        RESTError *restError = [[RESTError alloc] initWithDomain:kRequestErrorDomain
                                                            code:[error code]
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [NSString stringWithFormat:@"%@,%@",URLString,kServerErrorTip], ERRORMSG,
                                                                  [NSString stringWithFormat:@"%ld",(long)[error code]],ERRORCODE , nil]];
        #else
        RESTError *restError = [[RESTError alloc] initWithDomain:kRequestErrorDomain
                                                            code:[error code]
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  kServerErrorTip, ERRORMSG,
                                                                  [NSString stringWithFormat:@"%ld",(long)[error code]],ERRORCODE , nil]];
        #endif
        if (completionBlock) {
            completionBlock (nil,restError);
        }
    }];
}

+ (void)POST:(NSString*)URLString
      parameters:(id)parameters
    onCompletion:(void (^)(id responseData, NSError* error))completionBlock
{
    id AFHttpClient=kAFHttpClient;
    //加token，deviceId,userId
    NSMutableDictionary *kParameters = [APIOperation paramsWithToken:parameters];
    [AFHttpClient POST:URLString parameters:kParameters success:^(id operation, id responseObject) {
        
        NSString *code = [responseObject objectForKey:@"rtnCode"];
        NSDictionary *dataDict = responseObject;
        RESTError *restError = nil;
        if (![code isKindOfClass:[NSString class]]) {
            code = [NSString stringWithFormat:@"%@",code];
        }
        //业务逻辑错误
        if(![[code uppercaseString] isEqualToString:@"1"])
        {
            
#if defined (CONFIGURATION_DEBUG)
            restError = [[RESTError alloc] initWithDomain:kBusinessErrorDomain
                                                     code:0
                                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@,%@",URLString,[responseObject objectForKey:kMessage]], ERRORMSG,[responseObject objectForKey:@"rtnCode"], ERRORCODE, nil]];
#else
            restError = [[RESTError alloc] initWithDomain:kBusinessErrorDomain
                                                     code:0
                                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[responseObject objectForKey:kMessage], ERRORMSG,[responseObject objectForKey:@"rtnCode"], ERRORCODE, nil]];
#endif
        }
        //token异常重新登录
        [APIOperation tokenFailed:[responseObject objectForKey:@"rtnCode"]];
        if (completionBlock) {
            completionBlock(dataDict,restError);
        }
    } failure:^(id operation, NSError* error) {
        if (![mAppUtils hasConnectivity]) {
            [mAppUtils showHint:kNetWorkUnReachableDesc];
            if (completionBlock) {
                completionBlock(nil,error);
            }
            return ;
        }
#if defined (CONFIGURATION_DEBUG)
        RESTError *restError = [[RESTError alloc] initWithDomain:kRequestErrorDomain
                                                            code:[error code]
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [NSString stringWithFormat:@"%@,%@",URLString,kServerErrorTip], ERRORMSG,
                                                                  [NSString stringWithFormat:@"%ld",(long)[error code]],ERRORCODE , nil]];
#else
        RESTError *restError = [[RESTError alloc] initWithDomain:kRequestErrorDomain
                                                            code:[error code]
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  kServerErrorTip, ERRORMSG,
                                                                  [NSString stringWithFormat:@"%ld",(long)[error code]],ERRORCODE , nil]];
#endif
        if (completionBlock) {
            completionBlock (nil,restError);
        }
    }];
}

//上传文件\图片
+(void)uploadMedia:(NSString*)URLString parameters:(id)parameters
      onCompletion:(void (^)(id responseData, NSError* error))completionBlock {
    
    NSData *fileData = UIImageJPEGRepresentation([parameters objectForKey:@"file"], 0.5);
    id AFHttpClient=kAFHttpClient;
    //加token，deviceId,userId
    NSMutableDictionary *kParameters = [APIOperation paramsWithToken:parameters];
    [AFHttpClient POST:URLString parameters:kParameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        id fileParamKeyName = [parameters objectForKey:@"fileParamKeyName"];
        if (!fileParamKeyName) {
            fileParamKeyName = @"file";
        }
        [formData appendPartWithFileData:fileData
                                    name:fileParamKeyName
                                fileName:@"picture.jpg"
                                mimeType:@"image/jpeg"];
        
    } success:^(id operation, id responseObject) {
        
        NSString *code = [responseObject objectForKey:@"rtnCode"];
        NSDictionary *dataDict=responseObject;
        RESTError *restError = nil;
        //业务逻辑错误
        if(![[code uppercaseString] isEqualToString:@"1"])
        {
            
            restError = [[RESTError alloc] initWithDomain:kBusinessErrorDomain
                                                     code:0
                                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[responseObject objectForKey:kMessage], ERRORMSG,[responseObject objectForKey:@"rtnCode"], ERRORCODE, nil]];
        }
        //token异常重新登录
        [APIOperation tokenFailed:[responseObject objectForKey:@"rtnCode"]];
        if (completionBlock) {
            completionBlock(dataDict,restError);
        }
        
    } failure:^(id operation, NSError *error) {
        if (![mAppUtils hasConnectivity]) {
            [mAppUtils showHint:kNetWorkUnReachableDesc];
            if (completionBlock) {
                completionBlock(nil,error);
            }
            return ;
        }
        RESTError *restError = [[RESTError alloc] initWithDomain:kRequestErrorDomain
                                                            code:[error code]
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  kServerErrorTip, ERRORMSG,
                                                                  [NSString stringWithFormat:@"%ld",(long)[error code]],ERRORCODE , nil]];
        if (completionBlock) {
            completionBlock (nil,restError);
        }
        
    }];
    
}


+(void)uploadMutipleMedia:(NSString*)URLString parameters:(id)parameters
      onCompletion:(void (^)(id responseData, NSError* error))completionBlock {
    
    NSMutableArray *mediaArray = [NSMutableArray new];
    NSMutableDictionary *params = [NSMutableDictionary new];
    for (int i =0 ;i<[parameters allKeys].count;i++) {
        id key =[[parameters allKeys] objectAtIndex:i];
        id value = [[parameters allValues] objectAtIndex:i];
        
        if ([value isKindOfClass:[NSData class]]) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setValue:key  forKey:@"name"];
            [dict setValue:value  forKey:@"data"];
            [mediaArray addObject:dict];
        }else{
            [params setObject:value forKey:key];
        }
    }
    
    // 对图片进行排序
    [mediaArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary *dic1 = obj1;
        NSDictionary *dic2 = obj2;
        
        NSString *name1String = [dic1 objectForKey:@"name"];
        NSString *name2String = [dic2 objectForKey:@"name"];
        
        return [name1String compare:name2String];
    }];
    
    //NSDictionary *parametersDict = parameters;
   //  = @{@"userId":[parametersDict valueForKey:@"userId"] ,
                      //       @"tasks":[parametersDict valueForKey:@"tasks"]
                          //   };
    //NSData *fileData = UIImageJPEGRepresentation([parameters objectForKey:@"file"], 0.5);
    id AFHttpClient=kAFHttpClient;
    //加token，deviceId,userId
    NSMutableDictionary *kParameters = [APIOperation paramsWithToken:params];
    [AFHttpClient POST:URLString parameters:kParameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSDictionary *dict in mediaArray) {
            [formData appendPartWithFileData:[dict objectForKey:@"data"]
                                        name:[dict objectForKey:@"name"]
                                    fileName:@"picture.jpg"
                                    mimeType:@"image/jpeg"];
        }
        
    } success:^(id operation, id responseObject) {
        
        NSString *code = [responseObject objectForKey:@"rtnCode"];
        NSDictionary *dataDict=[responseObject objectForKey:@"data"];
        RESTError *restError = nil;
        //业务逻辑错误
        if(![[code uppercaseString] isEqualToString:@"1"])
        {
            
            restError = [[RESTError alloc] initWithDomain:kBusinessErrorDomain
                                                     code:0
                                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[responseObject objectForKey:kMessage], ERRORMSG,[responseObject objectForKey:@"rtnCode"], ERRORCODE, nil]];
        }
        //token异常重新登录
        [APIOperation tokenFailed:[responseObject objectForKey:@"rtnCode"]];
        if (completionBlock) {
            completionBlock(dataDict,restError);
        }
        
    } failure:^(id operation, NSError *error) {
        if (![mAppUtils hasConnectivity]) {
            [mAppUtils showHint:kNetWorkUnReachableDesc];
            if (completionBlock) {
                completionBlock(nil,error);
            }
            return ;
        }
        RESTError *restError = [[RESTError alloc] initWithDomain:kRequestErrorDomain
                                                            code:[error code]
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  kServerErrorTip, ERRORMSG,
                                                                  [NSString stringWithFormat:@"%ld",(long)[error code]],ERRORCODE , nil]];
        if (completionBlock) {
            completionBlock (nil,restError);
        }
        
    }];
    
}

+ (void)SEARCHGET:(NSInteger)indexForNum url:(NSString*)URLString
 parameters:(id)parameters
onCompletion:(void (^)(id responseData, NSError* error,NSInteger indexNum))completionBlock
{
    
    id AFHttpClient=kAFHttpClient;
    //加token，deviceId,userId
    NSMutableDictionary *kParameters = [APIOperation paramsWithToken:parameters];
    [AFHttpClient GET:URLString parameters:kParameters success:^(id operation, id responseObject) {
        
        NSString *code = [responseObject objectForKey:@"rtnCode"];
        NSDictionary *dataDict=[responseObject objectForKey:@"payload"];
        RESTError *restError = nil;
        //业务逻辑错误
        if(![[code uppercaseString] isEqualToString:@"1"])
        {
#if defined (CONFIGURATION_DEBUG)
            restError = [[RESTError alloc] initWithDomain:kBusinessErrorDomain
                                                     code:0
                                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@,%@",URLString,[responseObject objectForKey:kMessage]], ERRORMSG,[responseObject objectForKey:@"rtnCode"], ERRORCODE, nil]];
#else
            restError = [[RESTError alloc] initWithDomain:kBusinessErrorDomain
                                                     code:0
                                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[responseObject objectForKey:kMessage], ERRORMSG,[responseObject objectForKey:@"rtnCode"], ERRORCODE, nil]];
#endif
            
        }
        //token异常重新登录
        [APIOperation tokenFailed:[responseObject objectForKey:@"rtnCode"]];
        if (completionBlock) {
            completionBlock(dataDict,restError,indexForNum);
        }
    } failure:^(id operation, NSError* error) {
        
        if (![mAppUtils hasConnectivity]) {
            [mAppUtils showHint:kNetWorkUnReachableDesc];
            if (completionBlock) {
                completionBlock(nil,error,indexForNum);
            }
            return ;
        }
#if defined (CONFIGURATION_DEBUG)
        RESTError *restError = [[RESTError alloc] initWithDomain:kRequestErrorDomain
                                                            code:[error code]
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [NSString stringWithFormat:@"%@,%@",URLString,kServerErrorTip], ERRORMSG,
                                                                  [NSString stringWithFormat:@"%ld",(long)[error code]],ERRORCODE , nil]];
#else
        RESTError *restError = [[RESTError alloc] initWithDomain:kRequestErrorDomain
                                                            code:[error code]
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  kServerErrorTip, ERRORMSG,
                                                                  [NSString stringWithFormat:@"%ld",(long)[error code]],ERRORCODE , nil]];
#endif
        if (completionBlock) {
            completionBlock (nil,restError,indexForNum);
        }
    }];
}

+ (void)GET:(NSString *)apiName
 parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"%@%@", kBaseURL, apiName];
    if (parameters) {
        NSMutableString *urlString = [NSMutableString stringWithString:path];
        [urlString appendString:@"?"];
        NSDictionary *kParameters = parameters;
        if (kParameters) {
            for (int i = 0; i < kParameters.count; i++) {
                NSString *key = [kParameters allKeys][i];
                NSString *value = [kParameters objectForKey:key];
                [urlString appendFormat:@"%@=%@", key, value];
                if (i < kParameters.count - 1) {
                    [urlString appendString:@"&"];
                }
            }
        }
        path = urlString;
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //3.请求
    [manager GET:path parameters:nil success:success failure:failure];
}


+ (void)POST:(NSString *)apiName
  parameters:(id)parameters
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *path = [NSString stringWithFormat:@"%@%@", kBaseURL, apiName];
    [manager POST:path parameters:parameters success:success failure:failure];
}

@end
