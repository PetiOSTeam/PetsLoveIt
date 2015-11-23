//
//  LocalUserInfoModelClass.h
//  TeamWork
//
//  Created by HY on 14-6-18.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import "JSONModel.h"

@interface LocalUserInfoModelClass : JSONModel

@property (strong, nonatomic) NSString *uId;
@property (strong, nonatomic) NSString *uName;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *user_icon;

@end
