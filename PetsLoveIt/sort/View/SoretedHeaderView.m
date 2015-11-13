//
//  SoretedHeaderView.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/13.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "SoretedHeaderView.h"

@interface SoretedHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SoretedHeaderView

- (void)awakeFromNib
{
    [self addTopBorderWithColor:kLineColor andWidth:.5f];
    self.headerImageView.layer.cornerRadius = self.headerImageView.height / 2;
    self.headerImageView.layer.masksToBounds = YES;
}

@end
