//
//  
//  AutomaticCoder
//
//  Created by 张玺自动代码生成器   http://zhangxi.me
//  Copyright (c) 2012年 me.zhangxi. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface GradeModel : NSObject<NSCoding>

@property (nonatomic,strong) NSString *discount;
@property (nonatomic,strong) NSString *remainingNum;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *discountPic;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *receiveLimit;
@property (nonatomic,strong) NSString *discountId;
@property (nonatomic,strong) NSString *order;
@property (nonatomic,strong) NSString *totalNum;
@property (nonatomic,strong) NSString *integral;
@property (nonatomic,strong) NSString *awardCode;
@property (nonatomic,strong) NSString *effectiveDate;
@property (nonatomic,strong) NSString *instructions;
@property (nonatomic,strong) NSString *haschanged;
@property (nonatomic,strong) NSString *name;
 


-(id)initWithJson:(NSDictionary *)json;

@end
