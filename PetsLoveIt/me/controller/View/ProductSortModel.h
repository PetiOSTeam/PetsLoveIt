//
//  ProductSortModel.h
//  PetsLoveIt
//
//  Created by kongjun on 15/12/10.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "JSONModel.h"

@interface ProductSortModel : JSONModel
@property (nonatomic,strong) NSString *sortIcon;
@property (nonatomic,strong) NSString *sortId;
@property (nonatomic,strong) NSString *order;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *sort;
@end
