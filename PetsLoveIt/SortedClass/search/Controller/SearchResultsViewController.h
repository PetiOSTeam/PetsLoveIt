//
//  SearchResultsViewController.h
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/15.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsViewController : UIViewController

@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end
