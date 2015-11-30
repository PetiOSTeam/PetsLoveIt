//
//  StoreHeaderView.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/13.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "StoreHeaderView.h"

@interface StoreHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation StoreHeaderView

- (void)awakeFromNib
{
    self.width = mScreenWidth;
    [self addBottomBorderWithColor:kLineColor andWidth:.5f];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

@end
