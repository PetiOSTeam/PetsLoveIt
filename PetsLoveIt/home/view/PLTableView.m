//
//  PLTableView.m
//  PetsLoveIt
//
//  Created by kongjun on 15/11/14.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "PLTableView.h"
#import "GoodsCell.h"
#import "ArticleTableCell.h"
#import "GoodsDetailViewController.h"
#import "ShareOrderCell.h"

#define rowHeight1 110
#define rowHeight2 136
#define sectionHeaderHeight 47

@implementation PLTableView{
    NSString *sectionTitle1;
    NSString *sectionTitle2;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.tableFooterView = [UIView new];
        sectionTitle1 = @"猜你喜欢";
        sectionTitle2 = @"相关原创";
        
        [self setContentSize:CGSizeMake(mScreenWidth, self.dataArray1.count*rowHeight1 + sectionHeaderHeight)];
        }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame hiddenSection:(BOOL)hiddenSection{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.tableFooterView = [UIView new];
        self.hiddenSection = hiddenSection;
        [self setContentSize:CGSizeMake(mScreenWidth, self.dataArray1.count*rowHeight1)];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame isShareOrder:(BOOL)isShareOrder{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.tableFooterView = [UIView new];
        sectionTitle1 = @"猜你喜欢";
        self.isShareOrder = isShareOrder;
        [self setContentSize:CGSizeMake(mScreenWidth, self.dataArray1.count*rowHeight1)];
    }
    
    return self;
}


-(NSMutableArray *)dataArray1{
    if (!_dataArray1) {
        _dataArray1 = [NSMutableArray new];
    }
    return _dataArray1;
}

-(NSMutableArray *)dataArray2{
    if (!_dataArray2) {
        _dataArray2 = [NSMutableArray new];
    }
    return _dataArray2;
}
#pragma mark -
#pragma mark UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _dataArray1.count;
            break;
        case 1:
            return _dataArray2.count;
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.hiddenSection) {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShareOrder) {
        return [self shareOrderCell:tableView cellForRowAtIndexPath:indexPath];
    }else
        return  [self goodsCell:tableView cellForRowAtIndexPath:indexPath];

}

-(UITableViewCell *)goodsCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"GoodsCell";
    GoodsCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
    }
    cell.isTaopet = NO;
    GoodsModel *good = self.dataArray1[indexPath.row];
    [cell loadCellWithGoodsModel:good];
    return cell;
}
-(UITableViewCell *)articleCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"ArticleTableCell";
    ArticleTableCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
    }
    GoodsModel *article = self.dataArray2[indexPath.row];
    [cell loadCellWithModel:article];
    return cell;
}

-(UITableViewCell *)shareOrderCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"ShareOrderCell";
    ShareOrderCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
    }
    GoodsModel *article = self.dataArray1[indexPath.row];
    [cell loadViewWithModel:article];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsModel *good = self.dataArray1[indexPath.row];
    UIViewController *parentVC = [self viewController];
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
    vc.goods = good;
    [parentVC.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.isShareOrder) {
            return 255;
        }
        return rowHeight1;
    }else{
        return rowHeight2;
    }
        
    
}

- (void)tableView:(UITableView*)tableView
  willDisplayCell:(UITableViewCell*)cell
forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, sectionHeaderHeight)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, sectionHeaderHeight-0.5, mScreenWidth, 0.5)];
    [lineView setBackgroundColor:kCellSeparatorColor];
    [headerView addSubview:lineView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, mScreenWidth-30, sectionHeaderHeight)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [titleLabel setTextColor:mRGBToColor(0x333333)];
    [headerView addSubview:titleLabel];
    switch (section) {
        case 0:
            [titleLabel setText:sectionTitle1];
            break;
        case 1:
             [titleLabel setText:sectionTitle2];
            break;
        default:
            break;
    }
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return sectionHeaderHeight;
}

@end
