//
//  
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器   http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface KeywordsModel : NSObject<NSCoding>

@property (nonatomic,strong) NSString *ishot;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *order;
 


-(id)initWithJson:(NSDictionary *)json;

@end
