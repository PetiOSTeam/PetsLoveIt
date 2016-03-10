//
//  ShareOrderCell.m
//  PetsLoveIt
//
//  Created by liubingyang on 15/11/7.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "ShareOrderCell.h"

@implementation ShareOrderCell

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
- (void)dataFill {
    GoodsModel *order = (GoodsModel *)self.model;
    [self loadViewWithModel:order];
}

- (void)loadViewWithModel:(GoodsModel *)order{
    [self.orderPictureImageView sd_setImageWithURL:[NSURL URLWithString:order.appMinpic] placeholderImage:[UIImage imageNamed:@"shareOrder_default_load"] ];
    
    [self.orderPictureImageView setClipsToBounds:YES];
    self.ordeerTitleLabel.text = order.name;
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:order.publisherIcon] placeholderImage:kDefaultHeadImage];
    self.userNameLabel.text = order.publisher;
    self.shareTimeLabel.text = order.dateTime;
    self.commentNumLabel.text = order.commentNum;
    self.likeNumLabel.text = order.popularitystr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
