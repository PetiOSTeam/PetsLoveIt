//
//  SearchResultsViewController.h
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/15.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ResultStyle_Search,
    ResultStyle_Sift,
} ResultStyle;

@interface SearchResultsViewController : UIViewController

@property (nonatomic, assign) ResultStyle resyltStyle;

@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end
