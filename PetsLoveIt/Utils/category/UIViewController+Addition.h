//
//  UIViewController+Addition.h
//  smartcity
//
//  Created by junfrost on 13-12-25.
//  Copyright (c) 2013年 junfrost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Addition)

@property (strong, nonatomic)  UIView *navigationBarView;
@property (strong, nonatomic)  UILabel *navBarTitleLabel;

- (void)showNaviBarView;
- (void)adjustForIOS7;

-(CGSize)autoAjustedSizeAccordingToString:(NSString *)str font:(UIFont *)font  constrainedSize:(CGSize) contrainedSize;

-(UIView *) drawSeparatorWithX:(NSInteger)x Y:(NSInteger) y width:(CGFloat) w height:(CGFloat) h;


@end
