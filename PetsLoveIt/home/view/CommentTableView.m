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
#import "CommentCell.h"
@interface CommentTableView()
@property (nonatomic,assign) BOOL loadallFlag;
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
    if (([self.rootModel.maxOrderNo intValue] <= 6)||(self.rootModel.loadallFlag == YES)) {
        return self.dataArray.count;
    }else{
        return 7;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *identifier = @"CommentSubCell";
    if (self.rootModel.loadallFlag == NO) {
        if ([self.rootModel.maxOrderNo intValue] <= 6) {
            
            CommentSubCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
            }
            CommentModel *model = [self.dataArray objectAtIndex:indexPath.row];
            [cell loadCellWithModel:model];
            
            return cell;
        }else{
            CommentModel *model;
            if (indexPath.row != 5) {
                if (indexPath.row < 5) {
                    model = [self.dataArray objectAtIndex:indexPath.row];
                }
                else if (indexPath.row == 6)
                {
                    model = [self.dataArray lastObject];
                }
                CommentSubCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
                }
                
                [cell loadCellWithModel:model];
                
                return cell;
            }
            
            
            else{
                UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];

                cell.backgroundColor = mRGBToColor(0xf5f5f5);
               
                UIButton *clickButton = [[UIButton alloc]initWithFrame:cell.bounds];
                clickButton.width = self.width;
                [cell addSubview:clickButton];
                [clickButton setTitleColor:mRGBToColor(0x999999) forState:UIControlStateNormal];
//                [clickButton setTitleColor:mRGBToColor(0x666666) forState:UIControlStateHighlighted];
                [clickButton setTitle:@"显示隐藏楼层" forState:UIControlStateNormal];
                clickButton.titleLabel.font = [UIFont systemFontOfSize:14];
                [clickButton addTarget:self action:@selector(clickbutton) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            }
            
            
        }

    }else{
        CommentSubCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] firstObject];
        }
        if (indexPath.row < self.dataArray.count) {
            CommentModel *model = [self.dataArray objectAtIndex:indexPath.row];
            [cell loadCellWithModel:model];
            
        }
        
        return cell;
 
    }
    
}
- (void)clickbutton
{
   
    [self.dataArray removeAllObjects];
   // http:61.155.210.60:9090/petweb/actions/common.action?uid=getSubCommentByPId&commentId=1679
    NSDictionary *params = @{
                             @"uid": @"getSubCommentByPId",
                             @"commentId":self.rootModel.commentId,
                             };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            NSArray *tmpeArray = [[responseData objectForKey:@"rows"]objectForKey:@"rows"];
            for (NSMutableDictionary *tmpedict in tmpeArray) {
                CommentModel *model = [[CommentModel alloc]initWithDictionary:tmpedict];
                [self.dataArray addObject:model];
            }
            
            CommentModel *model = (CommentModel *)self.supercell.model;
            model.subComments = tmpeArray;
            model.loadallFlag = YES;
            self.supercell.model = model;
//            self.superview.height = self.contentSize.height - self.height + self.superview.height;
//            self.height = self.contentSize.height;


            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"refreshcommentcell" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }
    }];
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (([self.rootModel.maxOrderNo intValue] > 6)&&(self.rootModel.loadallFlag == NO)) {
        if (indexPath.row == 5) {
            
            return 43;
        }
        if (indexPath.row == 6) {
            
            CommentModel *model = [self.dataArray lastObject];
            CGFloat height = [CommentSubCell heightForCellWithObject:model];
            
            return height;
        }

    }
    CommentModel *model; if (indexPath.row < self.dataArray.count) {
        model = [self.dataArray objectAtIndex:indexPath.row];
        
    }
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
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        
        [cell setPreservesSuperviewLayoutMargins:NO];
        
    }
    
}


@end
