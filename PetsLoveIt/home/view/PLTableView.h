//
//  PLTableView.h
//  PetsLoveIt
//
//  Created by kongjun on 15/11/14.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray1;
@property (nonatomic,strong) NSMutableArray *dataArray2;
@property (nonatomic,assign) BOOL hiddenSection;
@property (nonatomic,assign) BOOL isShareOrder;
@property (nonatomic,assign) Menutype apptypename;
-(instancetype)initWithFrame:(CGRect)frame hiddenSection:(BOOL)hiddenSection;
-(instancetype)initWithFrame:(CGRect)frame isShareOrder:(BOOL)isShareOrder;
- (id)initWithFrame:(CGRect)frame Withtype:(Menutype)type;
@end
