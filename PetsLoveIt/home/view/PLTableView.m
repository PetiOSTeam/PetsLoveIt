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
        for (int i =0 ; i<3; i++) {
            GoodsModel *good = [GoodsModel new];
            good.imageUrl = @"http://am.zdmimg.com/201511/01/56362f724a9535919.jpg_d320.jpg";
            good.name = @"天猫狗粮优惠活动开始了";
            good.desc = @"双十一天猫优惠活动开始了，小样儿快行动吧...";
            good.prodDetail = @"100元包邮";
            good.commentNum = @"10";
            good.favorNum = @"80%";
            good.dateDesc = @"11-11";
            [self.dataArray1 addObject:good];
        }
        for (int i =0 ; i<3; i++) {
            ArticleModel *model = [ArticleModel new];
            model.imageUrl = @"http://a.zdmimg.com/201511/06/563c802c1fd044044.jpg_d320.jpg";
            model.name = @"实时心率监测：小米手环光感版将于双11上市 定价99元";
            model.title = @"京东精选";
            model.content = @"还记得去年小米发布的那款79元的智能手环一下将高高在上的智能可穿戴设备拉低到了百元以下，这一举动也让小米一举攻占智能手环市场。而从去年开始已经有不少国内厂商推出带有光学心率计的智能手环和手表，由此可以推测下一代小米手环也将会集成心率监测功能。果不其然小米今天宣布将在双11当天在小米官网和天猫旗舰店开卖全新的小米手环光感版，定价99元";
            model.commentNum = @"10";
            model.favorNum = @"80%";
            model.dateDesc = @"11-11";
            [self.dataArray2 addObject:model];
            [self reloadData];
            [self setContentSize:CGSizeMake(mScreenWidth, self.dataArray1.count*rowHeight1 + _dataArray2.count*rowHeight2 + sectionHeaderHeight*2)];
        }
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  [self goodsCell:tableView cellForRowAtIndexPath:indexPath];
    }else{
        return [self articleCell:tableView cellForRowAtIndexPath:indexPath];
    }
}

-(UITableViewCell *)goodsCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"GoodsCell";
    GoodsCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
    }
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
    ArticleModel *article = self.dataArray2[indexPath.row];
    [cell loadCellWithModel:article];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
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
