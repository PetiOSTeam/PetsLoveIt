//
//  CheapProductCell.m
//  PetsLoveIt
//
//  Created by 123 on 15/12/23.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CheapProductCell.h"
#import "UIView+MJExtension.h"
#import "GoodsModel.h"
#import "CheapProductViewController.h"
@interface CheapProductCell ()
@property (nonatomic,weak) UIView *maskview;
/**
  cell上半部分
 */
@property (nonatomic,weak) UIView *topview;
/**
 cell下半部分
 */
@property (nonatomic,weak) UIButton *bottombutton;
/**
 图片
 */
@property (nonatomic,weak) UIImageView *pic;
/**
 大标题
 */
@property (nonatomic,weak) UILabel *firstlable;
/**
 小标题
 */
@property (nonatomic,weak) UILabel *secondlable;
/**
 去抢购
 */
@property (nonatomic,weak) UIView *snapupview;
@end

@implementation CheapProductCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CheapProduct";
    CheapProductCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CheapProductCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *maskview = [[UIView alloc]init ];
        self.maskview = maskview;
        [self addSubview:maskview];

    }
    return self;
    
}
- (void)setupmaskview
{
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.maskview.mj_width , self.mj_height- 40)];
    self.topview = topview;
    [self setuptopview];
    [self.maskview addSubview:topview];
    UIButton *bottombutton = [[UIButton alloc]initWithFrame:CGRectMake(0, topview.bottom, self.mj_width , 44)];
    self.bottombutton = bottombutton;
    [self setupbottomview];
    [self.maskview addSubview:bottombutton];
    
}
- (void)setuptopview
{
    UIImageView *pic = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 85)];
    self.pic = pic;
    [self.topview addSubview:pic];
    
    UILabel *firstlable = [[UILabel alloc]initWithFrame:CGRectMake(pic.right+10, 10, self.maskview.mj_width - 130, 40)];
     firstlable.font = [UIFont systemFontOfSize:15];
    firstlable.numberOfLines = 2 ;
    firstlable.textColor = mRGBToColor(0x3333333);
    firstlable.textAlignment = NSTextAlignmentLeft;
    [self.topview addSubview:firstlable];
    self.firstlable = firstlable;

    
    UILabel *secondlable = [[UILabel alloc]init];
    secondlable.mj_x = firstlable.mj_x;
    secondlable.bottom = pic.bottom;
    secondlable.mj_size = CGSizeMake(self.maskview.mj_width - 180, 30);
    secondlable.font = [UIFont systemFontOfSize:14];
    secondlable.textColor = mRGBToColor(0xFF4401);
    secondlable.textAlignment = NSTextAlignmentLeft;
    secondlable.numberOfLines = 1;
    [self.topview addSubview:secondlable];
    self.secondlable = secondlable;
    
    UIView *snapupview = [[UIView alloc]init];
    snapupview.right = self.firstlable.right;
    snapupview.bottom = self.pic.bottom;
    snapupview.mj_size = CGSizeMake(50, 20);
    snapupview.backgroundColor = mRGBToColor(0xFF4401);
    UILabel *snapuplable = [[UILabel alloc]initWithFrame:snapupview.bounds];
    snapuplable.font = [UIFont systemFontOfSize:14];
    snapuplable.text  =  @"去抢购";
    [snapupview addSubview:snapuplable];
    snapuplable.textColor = [UIColor whiteColor];
    snapuplable.textAlignment = NSTextAlignmentCenter;
    self.snapupview = snapupview;
    [self.topview addSubview:snapupview];
    
}
- (void)setupbottomview
{
    [self.bottombutton setTitle:@"查看详情" forState:UIControlStateNormal];
    [self.bottombutton setTitleColor:mRGBToColor(0x3333333) forState:UIControlStateNormal];
    [self.bottombutton addTarget:self action:@selector(pushtoCheapProductViewController) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)pushtoCheapProductViewController
{
    CheapProductViewController *vc = [[CheapProductViewController alloc]init];
    vc.goods = self.goods;
}
- (void)setGoods:(GoodsModel *)goods
{
    self.maskview.frame =  CGRectMake(10, 0, mScreenWidth-20, 140);
    [self setupmaskview];
    self.userInteractionEnabled = YES;
    self.maskview.userInteractionEnabled = YES;
    NSLog(@"%@%@%@00",NSStringFromCGRect(self.topview.frame),NSStringFromCGRect(self.bottombutton.frame),NSStringFromCGRect(self.snapupview.frame));
    _goods = goods;
    self.firstlable.text = goods.name;
    self.secondlable.text = goods.desc;
    NSData *picdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:goods.appPic]];
    self.pic.image = [UIImage imageWithData:picdata];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
