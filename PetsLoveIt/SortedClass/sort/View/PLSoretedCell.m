//
//  PLSoretedCell.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/13.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "PLSoretedCell.h"

@interface PLSoretedCell ()

@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;

@property (nonatomic, strong) UIView *rightLine;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation PLSoretedCell

- (void)awakeFromNib
{
    [self rightLine];
    [self bottomLine];
}

- (void)setSubsortsEntity:(SubsortsEntity *)subsortsEntity
{
    _subsortsEntity = subsortsEntity;
    self.classNameLabel.text = _subsortsEntity.name;
}

- (void)setIsBottom:(BOOL)isBottom
{
    _isBottom = isBottom;
    if (_isBottom) {
        [self bottomLine];
    }else {
        if (_bottomLine) {
            [_bottomLine removeFromSuperview];
            _bottomLine = nil;
        }
    }
}

#pragma mark - *** getter ***

- (UIView *)rightLine
{
    if (!_rightLine) {
        _rightLine = [[UIView alloc] initForAutoLayout];
        _rightLine.backgroundColor = kLineColor;
        [self.contentView addSubview:_rightLine];
        [self.contentView bringSubviewToFront:_rightLine];
        [_rightLine autoSetDimension:ALDimensionWidth toSize:.5];
        [_rightLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_rightLine autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_rightLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
    }
    return _rightLine;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initForAutoLayout];
        _bottomLine.backgroundColor = kLineColor;
        [self.contentView addSubview:_bottomLine];
        [self.contentView bringSubviewToFront:_bottomLine];
        [_bottomLine autoSetDimension:ALDimensionHeight toSize:.5];
        [_bottomLine autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.5];
        [_bottomLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_bottomLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
    }
    return _bottomLine;
}

@end
