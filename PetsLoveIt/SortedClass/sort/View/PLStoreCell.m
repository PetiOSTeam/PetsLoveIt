//
//  PLStoreCell.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/13.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "PLStoreCell.h"

@interface PLStoreCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation PLStoreCell

- (void)awakeFromNib {
    
    UIView *line1 = [[UIView alloc] initForAutoLayout];
    UIView *line2 = [[UIView alloc] initForAutoLayout];
    UIView *line3 = [[UIView alloc] initForAutoLayout];

    line1.backgroundColor = kLineColor;
    line2.backgroundColor = kLineColor;
    line3.backgroundColor = kLineColor;

    [self.contentView addSubview:line1];
    [self.contentView addSubview:line2];
    [self.contentView addSubview:line3];

    [line1 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [line1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [line1 autoSetDimension:ALDimensionHeight toSize:.5];
    [line1 autoPinEdgeToSuperviewEdge:ALEdgeBottom];

    [line2 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [line2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [line2 autoSetDimension:ALDimensionHeight toSize:.5];
    [line2 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    
    [line3 autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [line3 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [line3 autoSetDimension:ALDimensionWidth toSize:.5];
    [line3 autoPinEdgeToSuperviewEdge:ALEdgeRight];
}

- (void)setModel:(StoreModel *)model
{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"icon_test"]];
}


@end
