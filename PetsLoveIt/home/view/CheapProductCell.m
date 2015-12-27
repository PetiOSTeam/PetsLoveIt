//
//  CheapProductCell.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/26.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CheapProductCell.h"

@implementation CheapProductCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.mainContainerView.layer.cornerRadius = 3;
    self.mainContainerView.layer.borderColor = kLayerBorderColor.CGColor;
    self.mainContainerView.layer.borderWidth = kLayerBorderWidth;
    self.mainContainerView.backgroundColor = mRGBToColor(0xfdfdfd);
    self.buyBtn.layer.cornerRadius = 15;
    self.buyBtn.enabled = NO;
    self.showDetailLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGoodsDetailVC)];
    [self.showDetailLabel addGestureRecognizer:tap];
}

- (void)showGoodsDetailVC{
    if ([self.delegate respondsToSelector:@selector(showGoodsDetailVC:)]) {
        [self.delegate showGoodsDetailVC:_goods];
    }
}

- (void)loadViewWithModel:(GoodsModel *)goods{
    self.goods = goods;
    self.descLabel.text = goods.name;
    self.tipLabel.text = goods.desc;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goods.appMinpic] placeholderImage:kImagePlaceHolder completed:NULL];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
