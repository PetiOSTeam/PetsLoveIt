//
//  GoodsCell.h
//  PetsLoveIt
//
//  Created by liubingyang on 15/11/8.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCell.h"
#import "GoodsModel.h"

@protocol GoodsCellDelegate <NSObject>

@optional
-(void) selectCollect:(NSString *)proId isSelect:(BOOL)isSelect;

@end

@interface GoodsCell : LTCell
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *prodLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favorImageView;
@property (weak, nonatomic) IBOutlet UILabel *favorNumLabel;
@property (weak, nonatomic) IBOutlet UIView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *collectionImage;
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *isToplabel;

@property (weak,nonatomic) id<GoodsCellDelegate> delegate;

- (void)loadCellWithGoodsModel:(GoodsModel *)good;
- (void)showSelectView:(BOOL)show;

@end
