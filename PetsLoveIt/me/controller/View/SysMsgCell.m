//
//  SysMsgCell.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/5.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "SysMsgCell.h"

@interface SysMsgCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation SysMsgCell

-(void)dataFill{
    SysMsgModel *good = (SysMsgModel *)self.model;
    [self configUIWithModel:good];
}

- (void)configUIWithModel:(SysMsgModel *)model
{
    self.contentLabel.text = model.msgcontent;
    self.timeLabel.text = model.sendTime;
    [self.contentLabel sizeToFit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
