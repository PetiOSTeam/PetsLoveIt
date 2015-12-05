//
//  CommentTableView.h
//  PetsLoveIt
//
//  Created by kongjun on 15/12/5.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataArray;

@end
