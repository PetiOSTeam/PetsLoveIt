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
}

- (void)tapOnProductView{
    SysMsgModel *msg = (SysMsgModel *)self.model;
    if ([self.delegate respondsToSelector:@selector(showProductVC:)]) {
        [self.delegate showProductVC:msg.productId];
    }
}

-(void)dataFill{
    SysMsgModel *msg = (SysMsgModel *)self.model;
    self.titleLabel.text = msg.msgcontent;
    [self.titleLabel setWidth:mScreenWidth-40];
    [self.titleLabel sizeToFit];
    
    self.productView.top = self.titleLabel.bottom + 10;
    if ([msg.prodName length]>0) {
        self.productLabel.text = [NSString stringWithFormat:@"原文:%@",msg.prodName];
    }else{
        self.productView.height = 0;
    }
    self.dateLabel.top = self.productLabel.bottom+13;
    self.dateLabel.text = msg.sendTime;
    
}

+(CGFloat)heightForCellWithObject:(SysMsgModel *)object
{
    UILabel *_textLabel = [[UILabel alloc]init];
    _textLabel.font = [UIFont systemFontOfSize:15];
    [_textLabel setText:object.msgcontent];
    _textLabel.numberOfLines = 0;
    _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_textLabel sizeToFit];
    
    return _textLabel.height + 20+10+40+13+10;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
