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
/**
 *  产品的id
 */
@property (nonatomic,strong) NSString *goodsId;
/**
 *  产品的模型
 */
@property (nonatomic,strong) GoodsModel *goods;
/**
 *  产品发布者的id等于0的时候表示没有发布者
 */
@property (nonatomic,strong) NSString *goodsuid;
/**
 *  用来判断进入此页页面的方法 present或者push
 */
@property (nonatomic,assign) BOOL ispresent;



@end
