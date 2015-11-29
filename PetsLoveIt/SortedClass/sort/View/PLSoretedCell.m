//
//  PLSoretedCell.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/13.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "PLSoretedCell.h"

@interface PLSoretedCell ()

@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;

@end

@implementation PLSoretedCell

- (void)awakeFromNib
{
    self.classNameLabel.layer.borderColor = kLineColor.CGColor;
    self.classNameLabel.layer.borderWidth = .5;
}

- (void)setSubsortsEntity:(SubsortsEntity *)subsortsEntity
{
    _subsortsEntity = subsortsEntity;
    self.classNameLabel.text = _subsortsEntity.name;
}

@end
