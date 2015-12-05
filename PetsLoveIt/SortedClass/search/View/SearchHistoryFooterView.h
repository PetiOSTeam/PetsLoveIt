//
//  SearchHistoryFooterView.h
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/15.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClearHistoryActionCompletion)(void);

@interface SearchHistoryFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (nonatomic, copy) ClearHistoryActionCompletion clearCompletion;

@end
