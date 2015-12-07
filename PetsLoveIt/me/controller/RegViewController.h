//
//  RegViewController.h
//  PetsLoveIt
//
//  Created by kongjun on 15/11/22.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CommonViewController.h"

@interface RegViewController : CommonViewController
@property (nonatomic,assign) BOOL isOtherLogin;//三方登录
@property (nonatomic,strong) NSString *otherType;
@property (nonatomic,strong) NSString *otherAccount;

@end
