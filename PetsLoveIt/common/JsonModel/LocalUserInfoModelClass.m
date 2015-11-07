//
//  LocalUserInfoModelClass.m
//  TeamWork
//
//  Created by HY on 14-6-18.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import "LocalUserInfoModelClass.h"

@implementation LocalUserInfoModelClass

-(void) setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"tags"]){
        
    }
    
    else
        [super setValue:value forKey:key];
}




//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.user_id forKey:@"user_id"];
    [encoder encodeObject:self.user_account forKey:@"user_account"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.user_source_id forKey:@"user_source_id"];
    [encoder encodeObject:self.user_source_name forKey:@"user_source_name"];
    [encoder encodeObject:self.nick_name forKey:@"nick_name"];
    [encoder encodeObject:self.user_icon forKey:@"user_icon"];
    [encoder encodeObject:self.op_open_id forKey:@"op_open_id"];
    [encoder encodeObject:self.op_token forKey:@"op_token"];
    [encoder encodeObject:self.op_expire_time forKey:@"op_expire_time"];
    [encoder encodeObject:self.user_desc forKey:@"user_desc"];
    [encoder encodeObject:self.op_type forKey:@"op_type"];
    [encoder encodeObject:self.fans_num forKey:@"fans_num"];
    [encoder encodeObject:self.at_num forKey:@"at_num"];
    [encoder encodeObject:self.is_check forKey:@"is_check"];
    [encoder encodeObject:self.level forKey:@"level"];
    [encoder encodeObject:self.state forKey:@"state"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.contact_name forKey:@"contact_name"];
    [encoder encodeObject:self.tagList forKey:@"tagList"];
    [encoder encodeObject:self.contact_tel forKey:@"contact_tel"];
    [encoder encodeObject:self.is_public forKey:@"is_public"];
    [encoder encodeObject:self.companyId forKey:@"companyId"];
    [encoder encodeObject:self.point forKey:@"point"];
    [encoder encodeObject:self.msg_push_market forKey:@"msg_push_market"];
    [encoder encodeObject:self.msg_push_sort forKey:@"msg_push_sort"];
    [encoder encodeObject:self.stock_num_collect forKey:@"stock_num_collect"];
    [encoder encodeObject:self.level_name forKey:@"level_name"];
    [encoder encodeObject:self.is_at forKey:@"is_at"];
    [encoder encodeObject:self.user_check forKey:@"user_check"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.user_id = [decoder decodeObjectForKey:@"user_id"];
        self.user_account = [decoder decodeObjectForKey:@"user_account"];
        self.token = [decoder decodeObjectForKey:@"token"];
        self.user_source_id = [decoder decodeObjectForKey:@"user_source_id"];
        self.user_source_name = [decoder decodeObjectForKey:@"user_source_name"];
        self.nick_name = [decoder decodeObjectForKey:@"nick_name"];
        self.user_icon = [decoder decodeObjectForKey:@"user_icon"];
        self.op_open_id = [decoder decodeObjectForKey:@"op_open_id"];
        self.op_token = [decoder decodeObjectForKey:@"op_token"];
        self.op_expire_time = [decoder decodeObjectForKey:@"op_expire_time"];
        self.user_desc = [decoder decodeObjectForKey:@"user_desc"];
        self.op_type = [decoder decodeObjectForKey:@"op_type"];
        self.fans_num = [decoder decodeObjectForKey:@"fans_num"];
        self.at_num = [decoder decodeObjectForKey:@"at_num"];
        self.is_check = [decoder decodeObjectForKey:@"is_check"];
        self.level = [decoder decodeObjectForKey:@"level"];
        self.state = [decoder decodeObjectForKey:@"state"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.contact_name = [decoder decodeObjectForKey:@"contact_name"];
        self.tagList = [decoder decodeObjectForKey:@"tagList"];
        self.contact_tel = [decoder decodeObjectForKey:@"contact_tel"];
        self.is_public = [decoder decodeObjectForKey:@"is_public"];
        self.companyId = [decoder decodeObjectForKey:@"companyId"];
        self.point = [decoder decodeObjectForKey:@"point"];
        self.msg_push_market = [decoder decodeObjectForKey:@"msg_push_market"];
        self.msg_push_sort = [decoder decodeObjectForKey:@"msg_push_sort"];
        self.stock_num_collect = [decoder decodeObjectForKey:@"stock_num_collect"];
        self.level_name = [decoder decodeObjectForKey:@"level_name"];
        self.is_at = [decoder decodeObjectForKey:@"is_at"];
        self.user_check = [decoder decodeObjectForKey:@"user_check"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setUser_id:[self.user_id copy]];
    [theCopy setUser_account:[self.user_account copy]];
    [theCopy setToken:[self.token copy]];
    [theCopy setUser_source_id:[self.user_source_id copy]];
    [theCopy setUser_source_name:[self.user_source_name copy]];
    [theCopy setNick_name:[self.nick_name copy]];
    [theCopy setUser_icon:[self.user_icon copy]];
    [theCopy setOp_open_id:[self.op_open_id copy]];
    [theCopy setOp_token:[self.op_token copy]];
    [theCopy setOp_expire_time:[self.op_expire_time copy]];
    [theCopy setUser_desc:[self.user_desc copy]];
    [theCopy setOp_type:[self.op_type copy]];
    [theCopy setFans_num:[self.fans_num copy]];
    [theCopy setAt_num:[self.at_num copy]];
    [theCopy setIs_check:[self.is_check copy]];
    [theCopy setLevel:[self.level copy]];
    //[theCopy setState:[self.state copy]];
    [theCopy setAddress:[self.address copy]];
    [theCopy setContact_name:[self.contact_name copy]];
    [theCopy setTagList:[self.tagList copy]];
    [theCopy setContact_tel:[self.contact_tel copy]];
    [theCopy setIs_public:[self.is_public copy]];
    [theCopy setCompanyId:[self.companyId copy]];
    [theCopy setPoint:[self.point copy]];
    [theCopy setMsg_push_market:[self.msg_push_market copy]];
    [theCopy setMsg_push_sort:[self.msg_push_sort copy]];
    [theCopy setStock_num_collect:[self.stock_num_collect copy]];
    [theCopy setLevel_name:[self.level_name copy]];
    [theCopy setIs_at:[self.is_at copy]];
    [theCopy setUser_check:[self.user_check copy]];
    
    return theCopy;
}
@end
