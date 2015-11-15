//
//  SearchKeyWordsCell.h
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/15.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTagView.h"

@interface SearchKeyWordsCell : UITableViewCell

@property (nonatomic, copy) NSArray *keywords;

+ (CGFloat)heightFromArray:(NSArray *)keyWords;

@end
