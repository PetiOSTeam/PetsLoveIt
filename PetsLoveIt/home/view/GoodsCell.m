//
//  GoodsCell.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/8.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "GoodsCell.h"
#import "GoodsModel.h"

@implementation GoodsCell

- (void)awakeFromNib {
    // Initialization code
}

/*
 *  数据填充
 */
-(void)dataFill{
    GoodsModel *good = (GoodsModel *)self.model;
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:good.imageUrl] placeholderImage:kImagePlaceHolder ];
    self.nameLabel.text = good.name;
    self.descLabel.text = good.desc;
    self.prodLabel.text = good.prodDetail;
    self.commentNumLabel.text = good.commentNum;
    self.favorNumLabel.text = good.favorNum;
    self.dateLabel.text = good.dateDesc;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
