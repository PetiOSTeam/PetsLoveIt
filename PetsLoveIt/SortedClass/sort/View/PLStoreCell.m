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

- (void)awakeFromNib
{
    self.iconImageView.layer.borderColor = kLineColor.CGColor;
    self.iconImageView.layer.borderWidth = .5;

}

- (void)setModel:(StoreModel *)model
{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.mallIcon] placeholderImage:[UIImage imageNamed:@"timeline_image_loading"]];
}


@end
