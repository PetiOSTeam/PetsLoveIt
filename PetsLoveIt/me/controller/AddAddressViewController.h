//
//  AddAddressViewController.h
//  PetsLoveIt
//
//  Created by liubingyang on 15/11/30.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "CommonViewController.h"
#import "AddressModel.h"
@interface AddAddressViewController : CommonViewController
@property (nonatomic,assign) BOOL isUpdateAddress;//修改地址
@property (nonatomic,strong) AddressModel *address;
@end
