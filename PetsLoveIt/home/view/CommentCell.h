//
//  CommentCell.h
//  PetsLoveIt
//
//  Created by kongjun on 15/12/5.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCell.h"
#import "MLEmojiLabel.h"
#import "CommentTableView.h"
#import "CommentModel.h"

@interface CommentCell : LTCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet MLEmojiLabel *commentLabel;
@property (weak, nonatomic) IBOutlet CommentTableView *tableView;
+(CGFloat)heightForCellWithObject:(CommentModel *)object;
@end
