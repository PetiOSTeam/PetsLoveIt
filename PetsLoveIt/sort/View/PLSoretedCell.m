//
//  PLSoretedCell.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/13.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "PLSoretedCell.h"

@interface PLSoretedCell ()

@property (nonatomic, strong) UIView *leftLine;

@property (nonatomic, strong) UIView *rightLine;

@end

@implementation PLSoretedCell

- (void)awakeFromNib {
    
    CALayer *border = [CALayer layer];
    border.backgroundColor = kLineColor.CGColor;
    border.frame = CGRectMake(0, 0, mScreenWidth, .5);
    [self.layer  addSublayer:border];
}

- (void)addLineWithLeft:(BOOL)isLeft withRight:(BOOL)isRight
{
    if (isLeft) {
        [self leftLine];
    }else {
        if (_leftLine) {
            [_leftLine removeFromSuperview];
            _leftLine = nil;
        }
    }
    
    if (isRight) {
        [self rightLine];
    }else {
        if (_rightLine) {
            [_rightLine removeFromSuperview];
            _rightLine = nil;
        }
    }
}

- (UIView *)leftLine
{
    if (!_leftLine) {
        _leftLine = [[UIView alloc] initForAutoLayout];
        _leftLine.backgroundColor = kLineColor;
        [self.contentView addSubview:_leftLine];
        [_leftLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_leftLine autoSetDimension:ALDimensionWidth toSize:.5];
        [_leftLine autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_leftLine autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.5];
    }
    return _leftLine;
}


- (UIView *)rightLine
{
    if (!_rightLine) {
        _rightLine = [[UIView alloc] initForAutoLayout];
        _rightLine.backgroundColor = kLineColor;
        [self.contentView addSubview:_rightLine];
        [_rightLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_rightLine autoSetDimension:ALDimensionWidth toSize:.5];
        [_rightLine autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_rightLine autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.5];
    }
    return _leftLine;
}


@end
