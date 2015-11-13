//
//  ScreenStoreView.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/12.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ScreenStoreView.h"
#import "StoreModel.h"
#import "StoreHeaderView.h"
#import "StoreFooterView.h"
#import "PLStoreCell.h"

static NSString * CellIdentifier = @"GradientCell";
static NSString * ScreenStoreHeaderCellIdentifier = @"GradientHeader";
static NSString * ScreenStoreFooterCellIdentifier = @"GradientFooter";

#define DefaultNum 9

@interface ScreenStoreView ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    BOOL _moreStoreInter;
    BOOL _moreStoreOuter;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation ScreenStoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadDataFromSever];
    }
    return self;
}

- (void)loadDataFromSever
{
    for (int i = 0; i < 20; i++) {
        StoreModel *storeModel = [[StoreModel alloc] init];
        //        storeModel.mallIcon
        [self.dataSource addObject:storeModel];
    }
    [self.collectionView reloadData];
}

#pragma mark - *** collectionView Delegate ***

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        NSInteger num = (self.dataSource.count - 1) % 3;
        return !_moreStoreInter ? DefaultNum : self.dataSource.count + num;
    }
    NSInteger num = (self.dataSource.count - 1) % 3;
    return !_moreStoreOuter ? DefaultNum : self.dataSource.count + num;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.width, 48);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (self.dataSource.count <= DefaultNum) {
        return CGSizeMake(self.width, 1);
    }
    return CGSizeMake(self.width, 45);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        return [self headerFromIndexPath:indexPath];
    }else {
        return [self footerFromIndexPath:indexPath];
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PLStoreCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 1 || indexPath.row % 3 == 1) {
        cell.isLandscapeLine = YES;
    }else {
        cell.isLandscapeLine = NO;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.width / 3, 56);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - *** inter header and footer action ***

- (UICollectionReusableView *)headerFromIndexPath:(NSIndexPath *)indexPath
{
    StoreHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          withReuseIdentifier:ScreenStoreHeaderCellIdentifier
                                                                                 forIndexPath:indexPath];
    if (indexPath.section == 0) {
        headerView.title = @"国内商城";
    }else {
        headerView.title = @"国外商城";
    }
    return headerView;
}

- (UICollectionReusableView *)footerFromIndexPath:(NSIndexPath *)indexPath
{
    StoreFooterView *footerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                     withReuseIdentifier:ScreenStoreFooterCellIdentifier
                                                                            forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (_moreStoreInter) {
            footerView.title = @"收起";
        }else {
            footerView.title = @"查看更多国内商城";
        }
        WEAKSELF
        footerView.moreAction = ^{
            _moreStoreInter = !_moreStoreInter;
            [weakSelf.collectionView reloadData];
        };
    }else {
        if (_moreStoreOuter) {
            footerView.title = @"收起";
        }else {
            footerView.title = @"查看更多国外商城";
        }
        WEAKSELF
        footerView.moreAction = ^{
            _moreStoreOuter = !_moreStoreOuter;
            [weakSelf.collectionView reloadData];
        };
        
    }
    return footerView;
}


#pragma mark - *** getter ***

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = -.5;
        flowLayout.minimumInteritemSpacing = -.5;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"PLStoreCell" bundle:nil]
          forCellWithReuseIdentifier:CellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"StoreHeaderView" bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:ScreenStoreHeaderCellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"StoreFooterView" bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                 withReuseIdentifier:ScreenStoreFooterCellIdentifier];
        
        [self addSubview:_collectionView];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [_collectionView autoPinEdgesToSuperviewEdges];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

@end
