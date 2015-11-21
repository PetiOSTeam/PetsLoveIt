//
//  SearchHeaderView.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/15.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "SearchHeaderView.h"

@interface SearchHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation SearchHeaderView

- (void)awakeFromNib
{
    self.width = mScreenWidth;
    [self addBottomBorderWithColor:kLineColor andWidth:.5];
}


- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (IBAction)changekeywordsAction:(id)sender
{
    if (self.changeAction) {
        self.changeAction();
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
