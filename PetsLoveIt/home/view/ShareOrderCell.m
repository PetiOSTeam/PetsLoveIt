//
//  ShareOrderCell.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/7.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ShareOrderCell.h"
#import "OrderModel.h"

@implementation ShareOrderCell

- (void)awakeFromNib {
    // Initialization code
}

/*
 *  数据填充
 */
- (void)dataFill {
    OrderModel *order = (OrderModel *)self.model;
    [self.orderPictureImageView sd_setImageWithURL:[NSURL URLWithString:order.orderPictureUrl] placeholderImage:kImagePlaceHolder ];
    [self.orderPictureImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.orderPictureImageView setClipsToBounds:YES];
    self.ordeerTitleLabel.text = order.orderTitle;
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:order.userIconUrl] placeholderImage:kImagePlaceHolder];
    self.userNameLabel.text = order.userName;
    self.shareTimeLabel.text = order.shareTime;
    self.commentNumLabel.text = order.commentNum;
    self.likeNumLabel.text = order.likeNum;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
