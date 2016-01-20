//
//  CheapTableView.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/26.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CheapTableView.h"

#import "CheapProductCell.h"
#import "PetWebViewController.h"
#import "GoodsDetailViewController.h"

#define cheapCellHeight 150

@interface CheapTableView ()<UITableViewDelegate,UITableViewDataSource,CheapProductCellDelegate>
@end

@implementation CheapTableView

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.tableFooterView = [UIView new];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

#pragma mark - CheapProductCellDelegate
-(void)showGoodsDetailVC:(GoodsModel *)goods{
    GoodsDetailViewController *vc =[GoodsDetailViewController new];
    vc.goods = goods;
    vc.apptypename = TypeCheap;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CheapProductCell";
    CheapProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    GoodsModel *goods = self.dataArray[indexPath.row];
    [cell loadViewWithModel:goods];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cheapCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsModel *goods = self.dataArray[indexPath.row];

    PetWebViewController *vc = [PetWebViewController new];
    //            vc.isProduct = YES;
    vc.htmlUrl = goods.goUrl;
    if(vc.htmlUrl.length == 0){
        return;
    }
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [[self viewController] presentViewController:navi animated:YES completion:NULL];
}





@end
