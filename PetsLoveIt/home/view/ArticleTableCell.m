//
//  NewsCell.m
//  PetsLoveIt
//
//  Created by liubingyang on 15/11/7.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "ArticleTableCell.h"

@implementation ArticleTableCell

- (void)awakeFromNib {
    // Initialization code
    self.containerView.width = mScreenWidth;
    [self.selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)selectAction:(id)sender{
    GoodsModel *good = (GoodsModel *)self.model;
    
    UIButton *button = sender;
    button.selected = !button.selected;
    BOOL selected = button.selected;
    if ([self.delegate respondsToSelector:@selector(selectCollect:isSelect:)]) {
        [self.delegate selectCollect:good.collectId isSelect:selected];
    }
}
- (void)showSelectView:(BOOL)show{
    if (show) {
        [UIView animateWithDuration:0.3 animations:^{
            self.selectBtn.hidden = NO;
            self.containerView.frame = CGRectMake(49, 0, mScreenWidth-49, self.contentView.height);
        } completion:^(BOOL finished) {
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.selectBtn.hidden = YES;
            self.containerView.frame = CGRectMake(0, 0, mScreenWidth, self.contentView.height);
        }completion:^(BOOL finished) {
            
        }];
    }
    
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
    self.favorNumLabel.text = article.popularitystr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
