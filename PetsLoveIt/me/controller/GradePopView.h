//
//  GradePopView.h
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/7.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeExchangeModel.h"

typedef void(^CellbackAction)(NSInteger index);

@interface GradePopView : UIView

@property (nonatomic, strong) GradeExchangeModel *model;

@property (nonatomic, copy) CellbackAction cellbackAction;

@end
