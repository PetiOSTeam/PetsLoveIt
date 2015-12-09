//
//  BLModel.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/9.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "BLModel.h"

@implementation BLModel
+(NSArray *)modelPrepare:(id)obj{
    return obj[@"rows"][@"rows"];
}
@end
