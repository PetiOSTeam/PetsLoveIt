//
//  LocalUserInfoModelClass.h
//  TeamWork
//
//  Created by HY on 14-6-18.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import "JSONModel.h"

@interface LocalUserInfoModelClass : JSONModel
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *user_account;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *user_source_id;
@property (strong, nonatomic) NSString *user_source_name;
@property (strong, nonatomic) NSString *nick_name;
@property (strong, nonatomic) NSString *user_icon;
@property (strong, nonatomic) NSString *op_open_id;

@property (strong, nonatomic) NSString *op_token;

@property (nonatomic, strong) NSString *op_expire_time;
@property (nonatomic, strong) NSString *user_desc;
@property (nonatomic, strong) NSString *op_type;
@property (nonatomic, strong) NSString *fans_num;
@property (nonatomic, strong) NSString *at_num;
@property (nonatomic, strong) NSString *is_check;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *contact_name;
@property (nonatomic, strong) NSMutableArray *tagList;
@property (nonatomic, strong) NSString *contact_tel;
@property (strong, nonatomic) NSString *is_public;
@property (strong, nonatomic) NSString *companyId;
@property (strong, nonatomic) NSString *point;
@property (strong, nonatomic) NSString *msg_push_market;
@property (strong, nonatomic) NSString *msg_push_sort;
@property (strong, nonatomic) NSString *stock_num_collect;
@property (strong, nonatomic) NSString *level_name;
@property (strong, nonatomic) NSString *is_at;
@property (strong, nonatomic) NSString *user_check;


@end
