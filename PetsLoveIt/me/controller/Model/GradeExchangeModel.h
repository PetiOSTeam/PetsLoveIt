//
//  
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器   http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BeanEntity.h"

@interface GradeExchangeModel : NSObject<NSCoding>

@property (nonatomic,strong) NSString *rtnCode;
@property (nonatomic,strong) NSString *rtnMsg;
@property (nonatomic,strong) BeanEntity *bean;
@property (nonatomic,strong) NSString *userToken;
 


-(id)initWithJson:(NSDictionary *)json;

@end
