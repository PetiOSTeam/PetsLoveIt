//
//  ShareOrderCell.h
//  PetsLoveIt
//
//  Created by kongjun on 15/11/7.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCell.h"

@interface ShareOrderCell : LTCell



@property (weak, nonatomic) IBOutlet UIImageView *orderPictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *ordeerTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeNumLabel;




@end
