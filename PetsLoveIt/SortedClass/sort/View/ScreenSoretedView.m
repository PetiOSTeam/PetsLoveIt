//
//  ScreenSoretedView.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/11/13.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "ScreenSoretedView.h"
#import "StoreModel.h"
#import "SoretedHeaderView.h"
#import "PLSoretedCell.h"

static NSString * CellIdentifier = @"GradientCell";
static NSString * ScreenStoreHeaderCellIdentifier = @"GradientHeader";

@interface ScreenSoretedView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ScreenSoretedView

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
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.width, 64);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        return [self headerFromIndexPath:indexPath];
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PLSoretedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 1 || indexPath.row % 4 == 1) {
        [cell addLineWithLeft:YES withRight:YES];
    }else if (indexPath.row == 2 || indexPath.row % 4 == 2) {
        [cell addLineWithLeft:NO withRight:YES];
    }else {
        [cell addLineWithLeft:NO withRight:NO];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.width / 4, 56);
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
    SoretedHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          withReuseIdentifier:ScreenStoreHeaderCellIdentifier
                                                                                 forIndexPath:indexPath];
//    if (indexPath.section == 0) {
//        headerView.title = @"国内商城";
//    }else {
//        headerView.title = @"国外商城";
//    }
    return headerView;
}


#pragma mark - *** getter ***

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"PLSoretedCell" bundle:nil]
          forCellWithReuseIdentifier:CellIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"SoretedHeaderView" bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:ScreenStoreHeaderCellIdentifier];
        
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
