//
//  ShakeremindView.m
//  PetsLoveIt
//
//  Created by 123 on 15/12/22.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ShakeremindView.h"
#import "UIView+MJExtension.h"

@interface ShakeremindView()

@end

@implementation ShakeremindView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
        
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.width-20, 25)];

        [lable1 setTextAlignment:NSTextAlignmentCenter];
        [lable1 setFont:[UIFont systemFontOfSize:15]];
        [lable1 setTextColor:mRGBToColor(0x333333)];
        [lable1 setNumberOfLines:1];
        [self addSubview:lable1];
        self.lable1 = lable1;
        UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(10, lable1.bottom+5, self.width-20, 25)];

        [lable2 setTextAlignment:NSTextAlignmentCenter];
        [lable2 setFont:[UIFont systemFontOfSize:15]];
        [lable2 setTextColor:mRGBToColor(0xff4401)];
        [self addSubview:lable2];
        self.lable2 = lable2;
        lable2.textAlignment = NSTextAlignmentCenter;
        
        UIButton *lelftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        lelftButton.frame = CGRectMake(0, lable2.bottom+10, 150, 35);
        lelftButton.center = CGPointMake(self.width/2, lelftButton.center.y);
        lelftButton.layer.cornerRadius = 5;
        [lelftButton setBackgroundColor:mRGBToColor(0xff4401)];
        [self addSubview:lelftButton];
        self.lelftButton = lelftButton;
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, lable2.bottom+10, 150, 35);
        rightButton.center = CGPointMake(self.width/2, lelftButton.center.y);
        rightButton.layer.cornerRadius = 5;
        [rightButton setBackgroundColor:mRGBToColor(0xff4401)];
        [self addSubview:rightButton];
        self.rightButton = rightButton;
        self.rightButton.hidden = YES;
        

    }
    return self;
}
- (void)setHidesrightButton:(BOOL)hidesrightButton
{
        _hidesrightButton = hidesrightButton;
    if (!hidesrightButton){
        self.rightButton.hidden = NO;

        self.lelftButton.mj_size = CGSizeMake(75, 30);
        self.lelftButton.center = CGPointMake(self.width/4+10, self.lelftButton.center.y);
        self.rightButton.mj_size = CGSizeMake(75, 30);
        self.rightButton.center = CGPointMake((self.width/4)*3-10, self.lelftButton.center.y);
        
    }
}
@end
