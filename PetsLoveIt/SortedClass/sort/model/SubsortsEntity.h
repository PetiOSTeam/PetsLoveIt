//
//  
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器   http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface SubsortsEntity : NSObject<NSCoding>

@property (nonatomic,strong) NSString *sortIcon;
@property (nonatomic,strong) NSString *sortId;
@property (nonatomic,strong) NSString *order;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *sort;
 


-(id)initWithJson:(NSDictionary *)json;

@end
