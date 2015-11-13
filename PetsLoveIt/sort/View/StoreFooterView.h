//
//  StoreFooterView.h
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/13.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MoreAction)(void);

@interface StoreFooterView : UICollectionReusableView

@property (nonatomic, strong) NSString *title;

@property (nonatomic, copy) MoreAction moreAction;

@end
