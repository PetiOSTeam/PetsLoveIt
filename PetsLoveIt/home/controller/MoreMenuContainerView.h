//
//  MoreMenuContainerView.h
//  PetsLoveIt
//
//  Created by 123 on 15/12/27.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "RichEditView.h"
@interface MoreMenuContainerView : UIView
@property (nonatomic,strong) RichEditToolBar *editToolBar;
@property (nonatomic,strong)CommentModel *selectedComment;
@property (nonatomic,strong) UIButton *popButton2;
@property (nonatomic,strong) UIButton *popButton1;
@property (nonatomic,assign)  BOOL isReply;//纪录是回复评论
@end
