//
//  AddAddressViewController.h
//  PetsLoveIt
//
//  Created by kongjun on 15/11/30.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CommonViewController.h"
#import "AddressModel.h"
@interface AddAddressViewController : CommonViewController
@property (nonatomic,assign) BOOL isUpdateAddress;//修改地址
@property (nonatomic,strong) AddressModel *address;
@end
