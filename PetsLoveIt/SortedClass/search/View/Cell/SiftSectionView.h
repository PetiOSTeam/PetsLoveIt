//
//  SiftSectionView.h
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/4.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didSelectSiftWithIndex)(NSInteger index);

@interface SiftSectionView : UIView

@property (nonatomic, copy) didSelectSiftWithIndex selectSiftIndex;

@end
