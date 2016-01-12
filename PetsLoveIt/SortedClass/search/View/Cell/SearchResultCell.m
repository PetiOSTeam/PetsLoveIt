//
//  SearchResultCell.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/15.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "SearchResultCell.h"

@interface SearchResultCell ()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

@property (weak, nonatomic) IBOutlet UILabel *fromWebName;

@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *likesNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *collectNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *collecticon;

@end

@implementation SearchResultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProductModel:( GoodsModel *)productModel
{
    _productModel = productModel;
    if ([_productModel.appType isEqualToString:@"m04"]) {
        self.collectNumLabel.hidden = NO;
        self.collecticon.hidden =NO;
    }else{
        self.collectNumLabel.hidden = YES;
        self.collecticon.hidden =YES;
       
    }
    if ([productModel.appType isEqualToString:@"m100"]) {
        productModel.typeName = @"白菜";
    }
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:productModel.appMinpic]
                             placeholderImage:[UIImage imageNamed:@"timeline_image_loading"]];
    self.productTitleLabel.text = productModel.name;
    self.fromWebName.text = productModel.typeName;
    NSDate *date = [[NSDate alloc] convertStringToDate:productModel.dateTime format:@"yyyy-MM-dd HH:mm:ss"];
    self.timeLabel.text = [date convertDateToStringWithFormat:@"MM-dd"];
    self.priceLabel.text = [NSString stringWithFormat:@"%@元", productModel.price];
    self.commentNumLabel.text = productModel.commentNum;
    self.likesNumLabel.text = productModel.popularitystr;
    self.collectNumLabel.text = productModel.collectnum;
    [self.commentNumLabel sizeToFit];
    [self.likesNumLabel sizeToFit];
    [self.collectNumLabel sizeToFit];
}

@end
