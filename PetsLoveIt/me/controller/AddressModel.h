//
//  AddressModel.h
//  PetsLoveIt
//
//  Created by kongjun on 15/11/30.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "JSONModel.h"

@interface AddressModel : JSONModel
@property (nonatomic,strong) NSString *addressId;
@property (nonatomic,strong) NSString *receiveAddress;
@property (nonatomic,strong) NSString *receiveName;
@property (nonatomic,strong) NSString *receiveTel;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *updDate;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *zipCode;
@end
