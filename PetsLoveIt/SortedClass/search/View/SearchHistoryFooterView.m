//
//  SearchHistoryFooterView.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/15.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "SearchHistoryFooterView.h"

@interface SearchHistoryFooterView () <UIAlertViewDelegate>

@end

@implementation SearchHistoryFooterView

- (void)awakeFromNib
{
    self.width = mScreenWidth;
//    [self addTopBorderWithColor:kLineColor andWidth:.5];
    [self addBottomBorderWithColor:kLineColor andWidth:.5];
}

- (IBAction)clickActionWithClearHistory:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定清除历史记录吗？"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"取消", @"确定", nil];
    [alertView show];
}

#pragma mark - *** alert delegate ***

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        saveArrayToDocument(@"hotwords.plist", [NSArray new]);
        if (self.clearCompletion) {
            
            self.clearCompletion();
        }
    }
}

@end
