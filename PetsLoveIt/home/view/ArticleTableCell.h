//
//  NewsCell.h
//  PetsLoveIt
//
//  Created by kongjun on 15/11/7.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCell.h"
#import "GoodsModel.h"

@protocol GoodsCellDelegate <NSObject>

@optional
-(void) selectCollect:(NSString *)proId isSelect:(BOOL)isSelect;

@end


@interface ArticleTableCell : LTCell
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favorImageView;
@property (weak, nonatomic) IBOutlet UILabel *favorNumLabel;

@property (weak,nonatomic) id<GoodsCellDelegate> delegate;

- (void)showSelectView:(BOOL)show;
- (void)loadCellWithModel:(GoodsModel*)article;

@end
