//
//  NewsCell.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/7.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ArticleTableCell.h"

@implementation ArticleTableCell

- (void)awakeFromNib {
    // Initialization code
}

/*
 *  数据填充
 */
-(void)dataFill{
    GoodsModel *article = (GoodsModel *)self.model;
    [self loadInfo:article];
}

- (void)loadCellWithModel:(GoodsModel*)article{
    [self loadInfo:article];
}

- (void)loadInfo:(GoodsModel *)article{
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:article.appMinpic] placeholderImage:kImagePlaceHolder];
    self.nameLabel.text = article.name;
    if ([article.mallName length]>0) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@-%@",article.typeName,article.mallName];
    }else{
        self.titleLabel.text = [NSString stringWithFormat:@"%@",article.typeName];
    }
       
    self.contentLabel.text = article.desc;
    self.dateLabel.text = article.dateTime;
    self.commentLabel.text = article.commentNum;
    self.favorNumLabel.text = article.favorNum;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
