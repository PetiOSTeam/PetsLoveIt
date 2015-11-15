//
//  SearchKeyWordsCell.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/15.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "SearchKeyWordsCell.h"
#import <Masonry/Masonry.h>

@interface SearchKeyWordsCell ()

@property (nonatomic, strong) SKTagView *tagView;

@end

@implementation SearchKeyWordsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setKeywords:(NSArray *)keywords
{
    _keywords = keywords;
    [self.tagView removeAllTags];
    [keywords enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SKTag *tag = [SKTag tagWithText:obj];
        tag.textColor = kOrangeColor;
        tag.fontSize = 14;
        tag.padding = UIEdgeInsetsMake(6, 10, 6, 12);
        tag.borderColor = kLineColor;
        tag.borderWidth = .5;
        tag.cornerRadius = 14;
        
        [self.tagView addTag:tag];
        NSLog(@"frame:%@", NSStringFromCGRect(self.contentView.frame));
        
    }];
}


#pragma mark - *** getter ***

- (SKTagView *)tagView
{
    if (!_tagView) {
        _tagView = [SKTagView new];
        _tagView.backgroundColor = [UIColor whiteColor];
        _tagView.padding    = UIEdgeInsetsMake(15, 15, 15, 15);
        _tagView.insets    = 10;
        _tagView.lineSpace = 10;
        _tagView.didClickTagAtIndex = ^(NSUInteger index){
        };
        [self.contentView addSubview:_tagView];
        [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            UIView *superView = self.contentView;
            make.centerY.equalTo(superView.mas_centerY).with.offset(0);
            make.leading.equalTo(superView.mas_leading).with.offset(0);
            make.trailing.equalTo(superView.mas_trailing);
        }];
    }
    return _tagView;
}

#pragma mark - *** class

+ (CGFloat)heightFromArray:(NSArray *)keyWords
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 50)];
    SKTagView *tagView = [SKTagView new];
    tagView.preferredMaxLayoutWidth = mScreenWidth;
    tagView.padding    = UIEdgeInsetsMake(15, 15, 15, 15);
    tagView.insets    = 10;
    tagView.lineSpace = 10;
    [contentView addSubview:tagView];
    
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superView = contentView;
        make.centerY.equalTo(superView.mas_centerY).with.offset(0);
        make.leading.equalTo(superView.mas_leading).with.offset(0);
        make.trailing.equalTo(superView.mas_trailing);
    }];

    [tagView removeAllTags];
    
    //Add Tags
    [keyWords enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         SKTag *tag = [SKTag tagWithText:obj];
         tag.fontSize = 14;
         tag.padding = UIEdgeInsetsMake(6, 10, 6, 12);
         tag.enable = NO;
         [tagView addTag:tag];
         
     }];
    CGSize size = [tagView intrinsicContentSize];
    return size.height;//[contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

@end
