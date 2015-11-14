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
    ArticleModel *article = (ArticleModel *)self.model;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:article.imageUrl] placeholderImage:kImagePlaceHolder];
    self.nameLabel.text = article.name;
    self.titleLabel.text = article.title;
    self.contentLabel.text = article.content;
    self.dateLabel.text = article.dateDesc;
    self.commentLabel.text = article.commentNum;
    self.favorNumLabel.text = article.favorNum;
}

- (void)loadCellWithModel:(ArticleModel*)article{
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:article.imageUrl] placeholderImage:kImagePlaceHolder];
    self.nameLabel.text = article.name;
    self.titleLabel.text = article.title;
    self.contentLabel.text = article.content;
    self.dateLabel.text = article.dateDesc;
    self.commentLabel.text = article.commentNum;
    self.favorNumLabel.text = article.favorNum;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
