//
//  ShareOrderCell.h
//  PetsLoveIt
//
//  Created by liubingyang on 15/11/7.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCell.h"
#import "GoodsModel.h"
@protocol GoodsCellDelegate <NSObject>

@optional
-(void) selectCollect:(NSString *)proId isSelect:(BOOL)isSelect;

@end
@interface ShareOrderCell : LTCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIImageView *orderPictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *ordeerTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeNumLabel;

@property (weak,nonatomic) id<GoodsCellDelegate> delegate;
- (void)showSelectView:(BOOL)show;
- (void)loadViewWithModel:(GoodsModel *)order;


@end
