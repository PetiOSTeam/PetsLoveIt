//
//  OrderModel.h
//  PetsLoveIt
//
//  Created by Joon on 15/11/8.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CoreListCommonModel.h"

@interface OrderModel : CoreListCommonModel

@property (strong, nonatomic) NSString *orderPictureUrl;
@property (strong, nonatomic) NSString *orderTitle;
@property (strong, nonatomic) NSString *userIconUrl;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *shareTime;
@property (strong, nonatomic) NSString *commentNum;
@property (strong, nonatomic) NSString *likeNum;
@property (nonatomic,strong) NSString *notworthnum;
/**产品的喜爱度 */
@property (nonatomic, copy) NSString* popularitystr;
@end
