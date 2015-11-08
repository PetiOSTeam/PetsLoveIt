//
//  ArticleModel.h
//  PetsLoveIt
//
//  Created by kongjun on 15/11/8.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CoreListCommonModel.h"

@interface ArticleModel : CoreListCommonModel
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *commentNum;
@property (nonatomic,strong) NSString *favorNum;
@property (nonatomic,strong) NSString *dateDesc;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;


@end
