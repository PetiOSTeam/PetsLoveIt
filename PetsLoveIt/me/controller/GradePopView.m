//
//  GradePopView.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/7.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "GradePopView.h"

@interface GradePopView ()

@property (weak, nonatomic) IBOutlet UIButton *adressBtn;

@property (weak, nonatomic) IBOutlet UIButton *lookBtn;

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceCodeLabel;

@end

@implementation GradePopView

- (void)awakeFromNib
{
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.lookBtn.layer.cornerRadius = self.adressBtn.layer.cornerRadius = self.adressBtn.height / 2;
    self.lookBtn.layer.masksToBounds = self.adressBtn.layer.masksToBounds = YES;
}

- (void)setModel:(GradeExchangeModel *)model
{
    _model = model;
    self.msgLabel.text = [NSString stringWithFormat:@"扣除%@积分", model.bean.changeIntegral];
    self.priceCodeLabel.text = [NSString stringWithFormat:@"领奖码：%@", model.bean.discountId];
}

- (IBAction)golookAction:(id)sender
{
    if (self.cellbackAction) {
        self.cellbackAction(0);
    }
}

- (IBAction)perfectAddres:(id)sender
{
    if (self.cellbackAction) {
        self.cellbackAction(1);
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
