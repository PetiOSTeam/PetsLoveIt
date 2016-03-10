//
//  GradePopView.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/7.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "GradePopView.h"

@interface GradePopView ()

@property (weak, nonatomic)  UIButton *adressBtn;

@property (weak, nonatomic)  UIButton *lookBtn;

@property (weak, nonatomic)  UILabel *msgLabel;

@property (weak, nonatomic)  UILabel *priceCodeLabel;
@property (weak, nonatomic)  UILabel *secmsgLabel;

@end

@implementation GradePopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *succeessLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 13, 224, 21)];
        succeessLabel.textColor = mRGBToColor(0xff4401);
        succeessLabel.textAlignment = NSTextAlignmentCenter;
        succeessLabel.font = [UIFont systemFontOfSize:15];
        succeessLabel.text = @"恭喜您，兑换成功";
        [self addSubview:succeessLabel];
        UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 43, 224, 21)];
        msgLabel.textColor = mRGBToColor(0x999999);
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:msgLabel];
        self.msgLabel = msgLabel;
        UILabel *priceCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 71, 224, 21)];
        priceCodeLabel.textColor = mRGBToColor(0x666666);
        priceCodeLabel.textAlignment = NSTextAlignmentCenter;
        priceCodeLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:priceCodeLabel];
        self.priceCodeLabel = priceCodeLabel;
        UILabel *secmsgLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 101, 224, 21)];
        secmsgLabel.textColor = mRGBToColor(0x999999);
        secmsgLabel.textAlignment = NSTextAlignmentCenter;
        secmsgLabel.font = [UIFont systemFontOfSize:12];
        secmsgLabel.text = @"您可在“兑换记录”中查看具体领奖形式";
        [self addSubview:secmsgLabel];
        self.secmsgLabel = secmsgLabel;
        UIButton *lookBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 135, 91, 26)];
        [lookBtn setBackgroundColor:mRGBToColor(0x666666)];
        lookBtn.titleLabel.font =[UIFont systemFontOfSize:12];
        [lookBtn setTitle:@"去看看" forState:UIControlStateNormal];
        [lookBtn addTarget:self action:@selector(golookAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:lookBtn];
        self.lookBtn = lookBtn;
        UIButton *adressBtn = [[UIButton alloc]initWithFrame:CGRectMake( 107, 135, 125, 26)];
        [adressBtn setBackgroundColor:mRGBToColor(0xff4401)];
        adressBtn.titleLabel.font =[UIFont systemFontOfSize:12];
        [adressBtn setTitle:@"立即完善收货地址" forState:UIControlStateNormal];
        [adressBtn addTarget:self action:@selector(perfectAddres) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:adressBtn];
        self.adressBtn = adressBtn;
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.lookBtn.layer.cornerRadius = self.adressBtn.layer.cornerRadius = self.adressBtn.height / 2;
        self.lookBtn.layer.masksToBounds = self.adressBtn.layer.masksToBounds = YES;
        
            }
    return self;
}
//- (void)awakeFromNib
//{
//    self.layer.cornerRadius = 5;
//    self.layer.masksToBounds = YES;
//    self.lookBtn.layer.cornerRadius = self.adressBtn.layer.cornerRadius = self.adressBtn.height / 2;
//    self.lookBtn.layer.masksToBounds = self.adressBtn.layer.masksToBounds = YES;
//     self.secmsgLabel.bottom = self.secmsgLabel.bottom -30 ;
//}

- (void)setModel:(GradeExchangeModel *)model
{
    _model = model;
   
    if (model.bean.awardCode == nil) {
        self.priceCodeLabel.hidden = YES;
        self.secmsgLabel.bottom = self.secmsgLabel.bottom - 30 ;
        self.lookBtn.bottom = self.lookBtn.bottom - 30;
        self.adressBtn.bottom = self.adressBtn.bottom - 30;
        self.height = self.height - 30;
        
    }else{
       self.priceCodeLabel.text = [NSString stringWithFormat:@"领奖码：%@", model.bean.discountId]; 
    }
   
    self.msgLabel.text = [NSString stringWithFormat:@"扣除%@积分", model.bean.changeIntegral];
    
    
}

- (IBAction)golookAction
{
    if (self.cellbackAction) {
        self.cellbackAction(0);
    }
}

- (IBAction)perfectAddres
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
