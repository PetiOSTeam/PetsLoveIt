//
//  GradeCell.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/5.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "GradeCell.h"

@interface GradeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;

@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;

@property (nonatomic, strong) GradeModel *gradeModel;

@property (nonatomic, assign) GradeStyle gradeStyle;

@property (nonatomic, copy) GtadeExchangeBlock exchangeBlock;

@end

@implementation GradeCell

- (void)awakeFromNib {
    
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    
    self.exchangeButton.layer.cornerRadius = self.exchangeButton.height / 2;
    self.exchangeButton.layer.masksToBounds = YES;
}

- (void)setGradeModel:(GradeModel *)gradeModel
            withStyle:(GradeStyle)style
   GtadeExchangeBlock:(GtadeExchangeBlock)exchangeBlock
{
    _gradeModel = gradeModel;
    _gradeStyle = style;
    _exchangeBlock = exchangeBlock;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:gradeModel.discountPic]
                          placeholderImage:[UIImage imageNamed:@"timeline_image_loading"]];
    self.titleLabel.text = gradeModel.name;
    [self.titleLabel sizeToFit];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: mRGBToColor(0xF52E0A),
                                 NSFontAttributeName: [UIFont systemFontOfSize:16]};
    NSString *str = [NSString stringWithFormat:@"%@ 积分", gradeModel.integral];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str
                                                                                      attributes:attributes];
    NSRange range = NSMakeRange(str.length - 2, 2);
    NSDictionary *attributes1 = @{NSForegroundColorAttributeName: mRGBToColor(0x9E9E9E),
                                  NSFontAttributeName: [UIFont systemFontOfSize:12]};
    [attributedStr addAttributes:attributes1 range:range];
    self.gradeLabel.attributedText  = attributedStr;
    
    if (self.gradeStyle == GradeStyleHistory) {
        [self.exchangeButton setBackgroundColor:[UIColor colorWithWhite:0.459 alpha:1.000]];
        self.exchangeButton.userInteractionEnabled = YES;
        [self.exchangeButton setTitle:@"已兑换" forState:UIControlStateNormal];
    }
}

- (IBAction)exchangeAction:(id)sender
{
    if (self.exchangeBlock) {
        self.exchangeBlock(self.gradeModel);
    }
}


@end
