//
//  
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器   http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BeansEntity.h"

@interface ScreecSoretedEntity : NSObject<NSCoding>

@property (nonatomic,strong) NSMutableArray *beans;
@property (nonatomic,strong) NSString *rtnCode;
@property (nonatomic,strong) NSString *rtnMsg;
@property (nonatomic,strong) NSString *userToken;
 


-(id)initWithJson:(NSDictionary *)json;

@end
