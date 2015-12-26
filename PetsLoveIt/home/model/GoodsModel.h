//
//  selectGoodModel.h
//  PetsLoveIt
//
//  Created by kongjun on 15/11/8.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "JSONModel.h"
#import "CoreListCommonModel.h"
typedef NS_ENUM(NSUInteger, Userpopularity) {
    ISclick = 1,
    NOclick
};
@interface GoodsModel : CoreListCommonModel
@property (nonatomic,strong) NSString *appMall;
@property (nonatomic,strong) NSString *appMinpic;
@property (nonatomic,strong) NSString *appPic;
@property (nonatomic,strong) NSString *appSort;
@property (nonatomic,strong) NSString *appType;
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *isCheap;
@property (nonatomic,strong) NSString *isGoods;
@property (nonatomic,strong) NSString *isLimitedTime;
@property (nonatomic,strong) NSString *isShake;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *order;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *prodDetail;
@property (nonatomic,strong) NSString *prodId;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *mallName;
@property (nonatomic,strong) NSString *goUrl;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *typeName;
@property (nonatomic,strong) NSString *isUserShare;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *commentNum;
@property (nonatomic,strong) NSString *favorNum;
@property (nonatomic,strong) NSString *dateDesc;
@property (nonatomic,strong) NSString *usercollectnum;
@property (nonatomic,strong) NSString *cheapPeriods;
@property (nonatomic,strong) NSString *dateTime;
@property (nonatomic,strong) NSString *isTop;
@property (nonatomic,strong) NSString *nodeUid;
@property (nonatomic,strong) NSString *collectnum;
@property (nonatomic,strong) NSString *publisher;
@property (nonatomic,strong) NSString *publisherIcon;
@property (nonatomic,strong) NSString *notworthnum;
/**产品的喜爱度 */
@property (nonatomic, copy) NSString* popularitystr;
/**用户对产品是否评价*/
@property (assign,nonatomic)  Userpopularity isclick;

@end
