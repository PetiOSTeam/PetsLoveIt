//
//  StoreFooterView.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/13.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "StoreFooterView.h"

@interface StoreFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation StoreFooterView

- (void)awakeFromNib {
    // Initialization code
    [self addTopBorderWithColor:kLineColor andWidth:.5];
    [self addBottomBorderWithColor:kLineColor andWidth:.5];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (IBAction)clickMoreAction:(id)sender {
    
    if (self.moreAction) {
        self.moreAction();
    }
}

@end
