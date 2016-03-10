//
//  BaoliaoView.m
//  PetsLoveIt
//
//  Created by 123 on 16/1/6.
//  Copyright © 2016年 liubingyang. All rights reserved.
//
typedef NS_ENUM(NSUInteger, Buttontype) {
    youhui = 0,
    haitao,
    taochong,
};
#import "BaoliaoView.h"
@interface BaoliaoView ()
- (IBAction)youhuiButtonClick:(id)sender;
- (IBAction)HaitaoButtonClick:(id)sender;
- (IBAction)TaochongButtonClick:(id)sender;
/**
 *  按钮类型
 */
@property (assign,nonatomic) Buttontype buttontype;
@end

@implementation BaoliaoView

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
    [self addBottomBorderWithColor:mRGBToColor(0xcccccc) andWidth:0.5];
     self.youhuiButton.selected = YES;
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

- (IBAction)youhuiButtonClick:(UIButton *)sender {
    self.youhuiButton.selected = YES;
    self.haitaoButton.selected = NO;
    self.taochongButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(clickButtonWithtype:)]) {
        [self.delegate clickButtonWithtype:@"m02"];
    }
    
}
-(void)setDetailsNums:(NSArray *)detailsNums
{
    _detailsNums = detailsNums;
    if (detailsNums.count==3) {
        [self.youhuiButton setTitle:[NSString stringWithFormat:@"优惠(%@)",detailsNums[0]] forState:UIControlStateNormal];
        [self.haitaoButton setTitle:[NSString stringWithFormat:@"海淘(%@)",detailsNums[1]] forState:UIControlStateNormal];
        [self.taochongButton setTitle:[NSString stringWithFormat:@"淘宠(%@)",detailsNums[2]] forState:UIControlStateNormal];
        
    }
   
    
}
- (IBAction)HaitaoButtonClick:(UIButton *)sender {
    self.haitaoButton.selected = YES;
    self.youhuiButton.selected = NO;
    self.taochongButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(clickButtonWithtype:)]) {
        [self.delegate clickButtonWithtype:@"m03"];
    }
}

- (IBAction)TaochongButtonClick:(UIButton *)sender {
    self.taochongButton.selected = YES;
    self.haitaoButton.selected = NO;
    self.youhuiButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(clickButtonWithtype:)]) {
        [self.delegate clickButtonWithtype:@"m04"];
    }
}
@end
