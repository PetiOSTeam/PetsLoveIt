//
//  TopicModel.h
//  youbibuluo
//
//  Created by kongjun on 15/7/13.
//  Copyright (c) 2015年 kongjun. All rights reserved.
//

#import "JSONModel.h"

@interface TopicModel : JSONModel
@property (nonatomic,strong) NSString *topicId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *sort_id;
@end
