//
//  BaoliaoTableViewCell.m
//  PetsLoveIt
//
//  Created by 123 on 16/1/6.
//  Copyright © 2016年 kongjun. All rights reserved.
//

#import "BaoliaoTableViewCell.h"
@interface BaoliaoTableViewCell ()
- (IBAction)youhuiButtonClick:(id)sender;
- (IBAction)HaitaoButtonClick:(id)sender;
- (IBAction)TaochongButtonClick:(id)sender;

@end

@implementation BaoliaoTableViewCell

- (void)awakeFromNib {
    self.menuView.layer.cornerRadius = 5;
    UIImage *buttonImage = [self buttonImageFromColor:mRGBToColor(0xcccccc)];
    [self.youhuiButton addLeftBorderWithColor:mRGBToColor(0xcccccc) andWidth:0.5];
    [self.haitaoButton addLeftBorderWithColor:mRGBToColor(0xcccccc) andWidth:0.5];
    [self.taochongButton addLeftBorderWithColor:mRGBToColor(0xcccccc) andWidth:0.5];
    self.menuView.layer.borderWidth = 0.5;
    self.menuView.layer.borderColor = mRGBToColor(0xcccccc).CGColor;
    [self.youhuiButton setBackgroundImage:buttonImage forState:UIControlStateSelected];
    [self.haitaoButton setBackgroundImage:buttonImage forState:UIControlStateSelected];
    [self.taochongButton setBackgroundImage:buttonImage forState:UIControlStateSelected];

}
- (UIImage *)buttonImageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)youhuiButtonClick:(UIButton *)sender {
    self.youhuiButton.selected = YES;
    self.haitaoButton.selected = NO;
    self.taochongButton.selected = NO;
    
}

- (IBAction)HaitaoButtonClick:(UIButton *)sender {
    self.haitaoButton.selected = YES;
    self.youhuiButton.selected = NO;
    self.taochongButton.selected = NO;
}

- (IBAction)TaochongButtonClick:(UIButton *)sender {
    self.taochongButton.selected = YES;
    self.haitaoButton.selected = NO;
    self.youhuiButton.selected = NO;
}
@end
