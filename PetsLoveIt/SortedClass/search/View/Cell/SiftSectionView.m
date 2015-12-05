//
//  SiftSectionView.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/4.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "SiftSectionView.h"

@interface SiftSectionView ()

@property (weak, nonatomic) IBOutlet UIButton *salesVolumeBtn;

@property (weak, nonatomic) IBOutlet UIButton *priceBtn;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

@implementation SiftSectionView

- (void)awakeFromNib
{
    self.width = mScreenWidth;
    [self addBottomBorderWithColor:kLineColor andWidth:.5];
    
    self.salesVolumeBtn.tag = 0;
    self.priceBtn.tag = 1;
    self.commentBtn.tag = 2;
    [self.salesVolumeBtn addTarget:self
                            action:@selector(clickActionWithSales:)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.priceBtn addTarget:self
                            action:@selector(clickActionWithPrice:)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.commentBtn addTarget:self
                            action:@selector(clickActionWithComment:)
                  forControlEvents:UIControlEventTouchUpInside];
    self.salesVolumeBtn.selected = YES;
}

- (void)clickActionWithSales:(id)sender
{
    self.salesVolumeBtn.selected = YES;
    self.priceBtn.selected = NO;
    self.commentBtn.selected = NO;
    if (self.selectSiftIndex) {
        self.selectSiftIndex(self.salesVolumeBtn.tag);
    }
}

- (void)clickActionWithPrice:(id)sender
{
    self.salesVolumeBtn.selected = NO;
    self.priceBtn.selected = YES;
    self.commentBtn.selected = NO;
    if (self.selectSiftIndex) {
        self.selectSiftIndex(self.priceBtn.tag);
    }
}

- (void)clickActionWithComment:(id)sender
{
    self.salesVolumeBtn.selected = NO;
    self.priceBtn.selected = NO;
    self.commentBtn.selected = YES;
    if (self.selectSiftIndex) {
        self.selectSiftIndex(self.commentBtn.tag);
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
