//
//  GradeDetailViewController.h
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/6.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeModel.h"
@interface GradeDetailViewController : UIViewController

@property (nonatomic, strong) GradeModel *gradeModel;
@property (nonatomic,copy) NSString *userintegral;

@end
