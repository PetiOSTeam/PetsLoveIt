//
//  CommentTableView.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/5.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentSubCell.h"
#import "CommentModel.h"

@interface CommentTableView()
@end

@implementation CommentTableView


-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
        self.dataSource = self;
        self.delegate = self;
        self.scrollEnabled = NO;
    }
    return _dataArray;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count <= 6) {
        return self.dataArray.count;
    }else{
        return 6;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.dataArray.count<=4) {
    
        NSString *identifier = @"CommentSubCell";
        CommentSubCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
        }
        CommentModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [cell loadCellWithModel:model];
        
        return cell;
//    }else{
//        CommentModel *model;
//        if (indexPath.row != 4) {
//            if (indexPath.row < 4) {
//                model = [self.dataArray objectAtIndex:indexPath.row];
//            }
//                else if (indexPath.row == 5)
//            {
//                model = [self.dataArray lastObject];
//            }
//            NSString *identifier = @"CommentSubCell";
//            CommentSubCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (!cell) {
//                cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
//            }
//            
//            [cell loadCellWithModel:model];
//           
//            return cell;
//        }
//       
//        
//        else{
//            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
//            cell.textLabel.text = @"点击加载更多";
//            
//            return cell;
//        }
//       
//      
//    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 5) {
//        CommentModel *model = [self.dataArray lastObject];
//        CGFloat height = [CommentSubCell heightForCellWithObject:model];
//        return height;
//    }
    CommentModel *model = [self.dataArray objectAtIndex:indexPath.row];
    CGFloat height = [CommentSubCell heightForCellWithObject:model];
    
    return height;
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


@end
