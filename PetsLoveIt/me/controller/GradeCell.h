//
//  GradeCell.h
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/5.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeModel.h"

typedef void(^GtadeExchangeBlock)(GradeModel *gradeModel);

typedef enum : NSUInteger {
    GradeStyleNew = 0,
    GradeStyleHistory,
} GradeStyle;

@interface GradeCell : UICollectionViewCell

- (void)setGradeModel:(GradeModel *)gradeModel
            withStyle:(GradeStyle)style
   GtadeExchangeBlock:(GtadeExchangeBlock)exchangeBlock;

@end
