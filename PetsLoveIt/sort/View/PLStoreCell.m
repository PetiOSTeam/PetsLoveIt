//
//  PLStoreCell.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/13.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "PLStoreCell.h"

@interface PLStoreCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic, strong) UIView *leftLine;

@property (nonatomic, strong) UIView *rightLine;

@end

@implementation PLStoreCell

- (void)awakeFromNib {
    // Initialization code
    CALayer *border = [CALayer layer];
    border.backgroundColor = kLineColor.CGColor;
    border.frame = CGRectMake(0, 0, mScreenWidth, .5);
    [self.layer  addSublayer:border];

}

- (void)setIsLandscapeLine:(BOOL)isLandscapeLine
{
    _isLandscapeLine = isLandscapeLine;
    if (isLandscapeLine) {
        [self leftLine];
        [self rightLine];
    }else {
        if (_leftLine) {
            [_leftLine removeFromSuperview];
            _leftLine = nil;
        }
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
