//
//  GoodsCell.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/8.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "GoodsCell.h"
@interface GoodsCell  ()

@end
@implementation GoodsCell


- (void)awakeFromNib {
    // Initialization code
}

/*
 *  数据填充
 */
-(void)dataFill{
    GoodsModel *good = (GoodsModel *)self.model;
    [self loadInfo:good];
}

- (void)loadCellWithGoodsModel:(GoodsModel *)good{
    [self loadInfo:good];
    
}

- (void)loadInfo:(GoodsModel *)good{
    
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:good.appMinpic] placeholderImage:kImagePlaceHolder ];
    if ([good.mallName length]>0)
    {
      self.nameLabel.text = [NSString stringWithFormat:@"%@-%@",good.typeName,good.mallName];
    }else{
       self.nameLabel.text = [NSString stringWithFormat:@"%@",good.typeName];
    }
    if (self.isTaopet) {
        self.collectionView.hidden = NO;
        self.collectionLabel.text = good.collectnum;
        self.collectionImage.image = [UIImage imageNamed:@"collectIcon"];
    }else
    {
        self.collectionView.hidden = YES;
    }
    NSString *popularitystr = good.popularitystr;
    self.descLabel.text = good.name;
    self.prodLabel.text = good.desc;
    self.commentNumLabel.text = good.commentNum;
    self.favorNumLabel.text = popularitystr;
    self.dateLabel.text = good.dateTime;
    
    self.commentImageView.image = [UIImage imageNamed:@"listcommentIcon"];
    self.favorImageView.image = [UIImage imageNamed:@"listfavorIcon"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (NSString *)productpopularityWithobjectId:(GoodsModel *)good
//{
//    float zancount = [good.favorNum floatValue];
//    if (good.favorNum == nil) {
//        zancount = 0;
//    }
//    
//    
//    float caicount = [good.notworthnum floatValue];
//    if (good.notworthnum == nil) {
//        caicount = 0;
//    }
//    float popularityF = zancount/(caicount+zancount)*100;
//    if (zancount == 0) {
//        popularityF =0;
//    }
//   
//    return [[NSString alloc]initWithFormat:@"%.0f%@",popularityF,@"%" ];
//    
//}
@end
