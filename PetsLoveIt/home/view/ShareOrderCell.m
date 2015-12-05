//
//  ShareOrderCell.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/7.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ShareOrderCell.h"
#import "GoodsModel.h"

@implementation ShareOrderCell

- (void)awakeFromNib {
    // Initialization code
}

/*
 *  数据填充
 */
- (void)dataFill {
    GoodsModel *order = (GoodsModel *)self.model;
    [self.orderPictureImageView sd_setImageWithURL:[NSURL URLWithString:order.appMinpic] placeholderImage:kImagePlaceHolder ];
    [self.orderPictureImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.orderPictureImageView setClipsToBounds:YES];
    self.ordeerTitleLabel.text = order.name;
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:kImagePlaceHolder];
    self.userNameLabel.text = order.nickName;
    self.shareTimeLabel.text = order.dateTime;
    self.commentNumLabel.text = order.commentNum;
    self.likeNumLabel.text = order.favorNum;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
