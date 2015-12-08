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
@property (strong, nonatomic) NSString *userGrade;
@property (strong, nonatomic) NSString *userIntegral;
@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSString *todaySigned;//今天是否签到
@property (strong, nonatomic) NSString *deliveryAddress;//收货地址

//用作自动登录用的
@property (strong, nonatomic) NSString *loginType;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *accountName;
//三方登录
@property (strong, nonatomic) NSString *otherType;
@property (strong, nonatomic) NSString *otherAccount;

//消息相关
@property (nonatomic, copy) NSNumber *messageVibration;  // 消息振动
@property (nonatomic, copy) NSNumber *messageVoice;  // 消息声音
@property (nonatomic, copy) NSNumber *messageCornerMark;  // 消息角标

@end
