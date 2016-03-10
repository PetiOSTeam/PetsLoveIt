//
//  MeViewController.h
//  PetsLoveIt
//
//  Created by liubingyang on 15/11/21.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "CommonViewController.h"

@interface MeViewController : CommonViewController
//{
//    NSNotificationCenter *center; 
//}
- (void) refreshremindWithTimer;
/** 是否显示新的消息*/
@property (assign,nonatomic) BOOL NewMsgFlag;
@end
