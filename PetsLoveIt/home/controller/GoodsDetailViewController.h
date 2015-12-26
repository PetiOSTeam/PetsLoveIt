//
//  GoodsDetailViewController.h
//  PetsLoveIt
//
//  Created by kongjun on 15/11/13.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CommonViewController.h"
#import "GoodsModel.h"

@class KMDetailsPageView;
@interface GoodsDetailViewController : CommonViewController
@property (nonatomic,strong) NSString *goodsId;
@property (nonatomic,strong) GoodsModel *goods;
@property (nonatomic,assign) DetailPageType pageType;
@property (nonatomic,assign) BOOL isCheapProduct;
@property (strong, nonatomic)  KMDetailsPageView * detailsPageView;

@end
