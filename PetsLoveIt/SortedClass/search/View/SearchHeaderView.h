//
//  SearchHeaderView.h
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/15.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeKeyWordsAction)(void);

@interface SearchHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *changeKeyworksButton;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, copy) ChangeKeyWordsAction changeAction;

@end
