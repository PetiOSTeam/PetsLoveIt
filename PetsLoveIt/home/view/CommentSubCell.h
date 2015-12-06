//
//  CommentSubCell.h
//  PetsLoveIt
//
//  Created by kongjun on 15/12/5.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
#import "CommentModel.h"

@interface CommentSubCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MLEmojiLabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;

-(void)loadCellWithModel:(CommentModel*)comment;
+(CGFloat)heightForCellWithObject:(CommentModel *)object;
@end
