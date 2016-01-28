//
//  MyMsgCell.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/9.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "MyMsgCell.h"

@implementation MyMsgCell

- (void)awakeFromNib {
    // Initialization code
    self.productView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnProductView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnProductView)];
    [self.productView addGestureRecognizer:tapOnProductView];
    
    self.productView.width = mScreenWidth - 66;
    self.productView.layer.borderColor = mRGBToColor(0xd8d6c9).CGColor;
    self.productView.layer.borderWidth = 0.5;
    UIImageView *dotOnCommentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redDotIcon"]];
    dotOnCommentImage.backgroundColor = [UIColor clearColor];
    dotOnCommentImage.frame = CGRectMake(8 , 25, 6, 6);
    self.dotOnCommentImage = dotOnCommentImage;
    self.dotOnCommentImage.hidden = YES;
    [self addSubview:dotOnCommentImage];

}

- (void)tapOnProductView{
    SysMsgModel *msg = (SysMsgModel *)self.model;
    if ([self.delegate respondsToSelector:@selector(showProductVC:)]) {
        [self.delegate showProductVC:msg.productId];
    }
}

-(void)dataFill{
    SysMsgModel *msg = (SysMsgModel *)self.model;
    if ([msg.hasread isEqualToString:@"0"]) {
        self.dotOnCommentImage.hidden = NO;
    }
    self.titleLabel.text = msg.msgcontent;
    [self.titleLabel setWidth:mScreenWidth-40];
    [self.titleLabel sizeToFit];
    
    if ([msg.prodName length]>0) {
        self.productView.top = self.titleLabel.bottom + 10;

        self.productLabel.text = [NSString stringWithFormat:@"原文:%@",msg.prodName];
    }else{
        self.productView.top = self.titleLabel.bottom;
        self.productView.height = 0;
    }
    self.dateLabel.top = self.productView.bottom+13;
    self.dateLabel.text = msg.sendTime;
    
}

+(CGFloat)heightForCellWithObject:(SysMsgModel *)object
{
    UILabel *_textLabel = [[UILabel alloc]init];
    _textLabel.font = [UIFont systemFontOfSize:15];
    [_textLabel setText:object.msgcontent];
    _textLabel.numberOfLines = 0;
    _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_textLabel setWidth:mScreenWidth-40];
    [_textLabel sizeToFit];
    if ([object.prodName length]>0){
        return _textLabel.height + 20+10+40+13+10+13;
    }else
        return _textLabel.height + 20+10+10+13;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
