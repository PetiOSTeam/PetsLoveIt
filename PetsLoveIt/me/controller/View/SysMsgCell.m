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
    self.contentLabel.width = mScreenWidth-40;
    [self.contentLabel sizeToFit];
    NSLog(@"%f",self.contentLabel.height);
    //self.contentLabel.height = self.contentLabel.height;
    self.timeLabel.top = self.contentLabel.bottom + 10;
    self.timeLabel.text = model.sendTime;
}

+ (CGFloat) heightForCell:(NSString *)text{
    CGFloat height=0;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, mScreenWidth-40, 17)];
    label.numberOfLines = 0;
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setText:text];
    [label sizeToFit];
    height = label.height + 16+17+10 + 13;
    return height;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
