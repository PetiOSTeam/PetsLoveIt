//
//  CheapProductCell.h
//  PetsLoveIt
//
//  Created by liubingyang on 15/12/26.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@protocol CheapProductCellDelegate <NSObject>

@optional
- (void)showGoodsDetailVC:(GoodsModel *)goods;

@end

@interface CheapProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UILabel *showDetailLabel;

@property (nonatomic,weak) id<CheapProductCellDelegate> delegate;
@property (nonatomic,strong) GoodsModel *goods;

- (void)loadViewWithModel:(GoodsModel *)goods;
@end
