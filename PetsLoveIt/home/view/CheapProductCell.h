//
//  CheapProductCell.h
//  PetsLoveIt
//
//  Created by 123 on 15/12/23.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsModel;
@interface CheapProductCell : UITableViewCell
/**
 数据模型
 */
@property (nonatomic,strong) GoodsModel *goods;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
