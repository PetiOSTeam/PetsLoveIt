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
    [encoder encodeObject:self.uId forKey:@"uId"];
    [encoder encodeObject:self.uName forKey:@"uName"];
    [encoder encodeObject:self.sex forKey:@"sex"];
    [encoder encodeObject:self.mobile forKey:@"mobile"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.status forKey:@"status"];
    [encoder encodeObject:self.nickName forKey:@"nickName"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.uId = [decoder decodeObjectForKey:@"uId"];
        self.uName = [decoder decodeObjectForKey:@"uName"];
        self.sex = [decoder decodeObjectForKey:@"sex"];
        self.mobile = [decoder decodeObjectForKey:@"mobile"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.status = [decoder decodeObjectForKey:@"status"];
        self.nickName = [decoder decodeObjectForKey:@"nickName"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setUId:[self.uId copy]];
    [theCopy setUName:[self.uName copy]];
    [theCopy setSex:[self.sex copy]];
    [theCopy setMobile:[self.mobile copy]];
    [theCopy setEmail:[self.email copy]];
    [theCopy setStatus:[self.status copy]];
    [theCopy setNickName:[self.nickName copy]];
    
    return theCopy;
}
@end
