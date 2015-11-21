//
//  SearchKeyWordsCell.h
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/15.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTagView.h"
#import "KeywordsModel.h"

@class SearchKeyWordsCell;
@protocol SearchKeyWordsCellDelegate <NSObject>

- (void)reloadKeywordsWithCell:(SearchKeyWordsCell *)cell;

@end

@interface SearchKeyWordsCell : UITableViewCell

@property (nonatomic, assign) id<SearchKeyWordsCellDelegate> delegate;

@property (nonatomic, copy) NSArray *keywords;

- (void)startLoading;

- (void)stopTitle:(NSString *)title;

- (void)failLoading;

+ (CGFloat)heightFromArray:(NSArray *)keyWords;

@end
