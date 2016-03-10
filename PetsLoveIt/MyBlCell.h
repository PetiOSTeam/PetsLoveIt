//
//  MyBlCell.h
//  PetsLoveIt
//
//  Created by liubingyang on 15/12/9.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCell.h"
#import "BLModel.h"

@interface MyBlCell : LTCell
@property (weak, nonatomic) IBOutlet UILabel *sourceTitle;

@property (weak, nonatomic) IBOutlet UILabel *statename;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UITextView *sourceTitleview;
@property (weak, nonatomic) IBOutlet UIView *maskView;
+(CGFloat)heightForCellWithObject:(BLModel *)object;
@end
