//
//  MyBlCell.h
//  PetsLoveIt
//
//  Created by kongjun on 15/12/9.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCell.h"
#import "BLModel.h"

@interface MyBlCell : LTCell
@property (weak, nonatomic) IBOutlet UILabel *sourceTitle;

@property (weak, nonatomic) IBOutlet UILabel *statename;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UITextView *sourceTitleview;
@end
