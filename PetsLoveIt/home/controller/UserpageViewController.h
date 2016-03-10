//
//  UserpageViewController.h
//  PetsLoveIt
//
//  Created by 123 on 16/1/5.
//  Copyright © 2016年 liubingyang. All rights reserved.
#import "CoreLTVC.h"
#import "CommentModel.h"
@class UserpageModel;
@interface UserpageViewController : CoreLTVC
@property (strong,nonatomic) UserpageModel *pageModel;
@property (nonatomic,copy) NSString *uesrId;
@end
