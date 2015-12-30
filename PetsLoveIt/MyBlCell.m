//
//  MyBlCell.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/9.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "MyBlCell.h"

@implementation MyBlCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
// 增加了未审核的状态
-(void)dataFill{
    BLModel *model = (BLModel *)self.model;
    self.sourceTitle.text = model.title;
    self.sourceReason.text = model.shareReason;
    if ([model.status intValue] == 1) {
        self.stateLabel.text = @"已通过";
 
    }else if ([model.status intValue] == 2)
    {
       self.stateLabel.text = @"未通过";
    }
    else{
        self.stateLabel.text = @"未审核";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
