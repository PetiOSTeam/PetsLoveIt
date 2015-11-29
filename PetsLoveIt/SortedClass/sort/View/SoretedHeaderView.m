//
//  SoretedHeaderView.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/13.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "SoretedHeaderView.h"

@interface SoretedHeaderView ()

@end

@implementation SoretedHeaderView

- (void)awakeFromNib
{
    self.width = mScreenWidth;
    self.headerImageView.layer.cornerRadius = self.headerImageView.height / 2;
    self.headerImageView.layer.masksToBounds = YES;
    
    
    [self addBottomBorderWithColor:kLineColor andWidth:.5f];
}

@end
