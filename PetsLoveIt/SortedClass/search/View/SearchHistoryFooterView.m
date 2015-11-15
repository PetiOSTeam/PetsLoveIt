//
//  SearchHistoryFooterView.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/15.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "SearchHistoryFooterView.h"

@implementation SearchHistoryFooterView

- (void)awakeFromNib
{
    [self addTopBorderWithColor:kLineColor andWidth:.5];
    [self addBottomBorderWithColor:kLineColor andWidth:.5];
}


- (IBAction)clickActionWithClearHistory:(id)sender {
}

@end
