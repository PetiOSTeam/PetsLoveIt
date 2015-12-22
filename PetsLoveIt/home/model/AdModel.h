//
//  AdModel.h
//  PetsLoveIt
//
//  Created by kongjun on 15/11/26.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "JSONModel.h"

@interface AdModel : JSONModel
@property (nonatomic,strong) NSString *adpic;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *nodeUid;
@property (nonatomic,strong) NSString *order;
@property (nonatomic,strong) NSString *prodId;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *goUrl;

@end
