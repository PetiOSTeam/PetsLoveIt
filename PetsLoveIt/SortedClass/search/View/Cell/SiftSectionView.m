//
//  SiftSectionView.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/4.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "SiftSectionView.h"

@implementation SiftSectionView

- (void)awakeFromNib
{
    self.width = mScreenWidth;
    [self addBottomBorderWithColor:kLineColor andWidth:.5];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
