//
//  SysMsgCell.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/5.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "SysMsgCell.h"

@interface SysMsgCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak,nonatomic) UIImageView *dotOnCommentImage;
@end

@implementation SysMsgCell
- (void)awakeFromNib
{
    UIImageView *dotOnCommentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redDotIcon"]];
    dotOnCommentImage.backgroundColor = [UIColor clearColor];
    dotOnCommentImage.frame = CGRectMake(8 , 20, 6, 6);
    self.dotOnCommentImage = dotOnCommentImage;
    self.dotOnCommentImage.hidden = YES;
    [self addSubview:dotOnCommentImage];
}
-(void)dataFill{
    SysMsgModel *good = (SysMsgModel *)self.model;
    [self configUIWithModel:good];
}

- (void)configUIWithModel:(SysMsgModel *)model
{
    if ([model.hasread isEqualToString:@"0"]) {
        self.dotOnCommentImage.hidden = NO;
    }
    self.contentLabel.width = mScreenWidth-40;
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel setFont:[UIFont systemFontOfSize:15]];
    self.contentLabel.text = model.msgcontent;
    //[self.contentLabel setTextAlignment:NSTextAlignmentJustified];
    [self.contentLabel sizeToFit];
    NSLog(@"%f",self.contentLabel.height);
    self.timeLabel.top = self.contentLabel.bottom + 10;
    self.timeLabel.text = model.sendTime;
}

+ (CGFloat) heightForCell:(NSString *)text{
    CGFloat height=0;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, mScreenWidth-40, 17)];
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
