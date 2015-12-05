//
//  GoodsCell.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/8.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "GoodsCell.h"

@implementation GoodsCell

- (void)awakeFromNib {
    // Initialization code
}

/*
 *  数据填充
 */
-(void)dataFill{
    GoodsModel *good = (GoodsModel *)self.model;
    [self loadInfo:good];
}

- (void)loadCellWithGoodsModel:(GoodsModel *)good{
    [self loadInfo:good];
}

- (void)loadInfo:(GoodsModel *)good{
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:good.appMinpic] placeholderImage:kImagePlaceHolder ];
    if ([good.mallName length]>0)
    {
      self.nameLabel.text = [NSString stringWithFormat:@"%@-%@",good.typeName,good.mallName];
    }else{
       self.nameLabel.text = [NSString stringWithFormat:@"%@",good.typeName];
    }
    self.descLabel.text = good.name;
    self.prodLabel.text = good.desc;
    self.commentNumLabel.text = good.commentNum;
    self.favorNumLabel.text = good.favorNum;
    self.dateLabel.text = good.dateDesc;
    
    self.commentImageView.image = [UIImage imageNamed:@"listcommentIcon"];
    self.favorImageView.image = [UIImage imageNamed:@"listfavorIcon"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
