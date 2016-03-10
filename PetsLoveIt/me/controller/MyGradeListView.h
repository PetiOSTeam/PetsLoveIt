//
//  MyGradeListView.h
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/5.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeCell.h"

@interface MyGradeListView : UIView

@property (nonatomic, weak) UINavigationController *navigation;
@property (nonatomic,copy) NSString *userintegral;
- (id)initWithFrame:(CGRect)frame
          withStyle:(GradeStyle)style;

@end
