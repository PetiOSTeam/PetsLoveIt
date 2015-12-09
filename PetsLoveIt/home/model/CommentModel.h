//
//  CommentModel.h
//  PetsLoveIt
//
//  Created by kongjun on 15/12/5.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CoreListCommonModel.h"

@interface CommentModel : CoreListCommonModel

@property (nonatomic,strong) NSString *commentId;
@property (nonatomic,strong) NSString *parentId;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *productId;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *commentTime;
@property (nonatomic,strong) NSString *timeFlag;
@property (nonatomic,strong) NSString *commentObject;
@property (nonatomic,strong) NSString *orderNo;
@property (nonatomic,strong) NSString *userIcon;
@property (nonatomic,strong) NSString *otherUserIcon;
@property (nonatomic,strong) NSString *userGrade;
@property (nonatomic,strong) NSString *userIntegral;
@property (nonatomic,strong) NSString *praiseNum;
@property (nonatomic,strong) NSString *praiseFlag;
@property (nonatomic,strong) NSString *stepNum;
@property (nonatomic,strong) NSString *stepFlag;
@property (nonatomic,strong) id parent_data;

@property (nonatomic,strong) NSString *otherContent;
@property (nonatomic,strong) NSString *otherNickName;
@property (nonatomic,strong) NSString *otherUserName;
@property (nonatomic,strong) NSString *prodName;

@end
