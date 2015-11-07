//
//  NewsListCell.m
//  CorePagesView
//
//  Created by junfrost on 15/5/26.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NewsListCell.h"
#import "NewsListModel.h"
#import "YBImageView.h"

@interface NewsListCell ()



@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet YBImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end



@implementation NewsListCell


/*
 *  数据填充
 */
-(void)dataFill{
    
    //类型强转
    NewsListModel *model =(NewsListModel *) self.model;
    
    
//    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:kDefaultAppImage];
    _infoLabel.text = [NSString stringWithFormat:@"%@",model.sort_name];
    
    _titleLabel.text = model.title;
    
    _dateLabel.text = model.article_time;
}

@end
