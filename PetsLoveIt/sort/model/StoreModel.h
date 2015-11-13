//
//  
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器   http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface StoreModel : NSObject<NSCoding>

@property (nonatomic,strong) NSString *mallId;
@property (nonatomic,strong) NSString *isChian;
@property (nonatomic,strong) NSString *order;
@property (nonatomic,strong) NSString *mallIcon;
@property (nonatomic,strong) NSString *nodeUid;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *state;
 


-(id)initWithJson:(NSDictionary *)json;

@end
