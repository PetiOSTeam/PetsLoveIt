//
//  MyCommentCell.h
//  PetsLoveIt
//
//  Created by liubingyang on 15/12/9.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCell.h"
#import "MLEmojiLabel.h"
#import "CommentModel.h"


@protocol MyCommentCellDelegate <NSObject>

@optional
- (void) showProductVC:(NSString *)proId;

@end

@interface MyCommentCell : LTCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *originalProductView;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UIView *myCommentView;
@property (weak, nonatomic) IBOutlet MLEmojiLabel *myCommentLabel;
@property (weak, nonatomic) IBOutlet MLEmojiLabel *otherCommentLabel;
@property (weak, nonatomic)  UIImageView *dotOnCommentImage;
@property (strong,nonatomic) NSString *userIcon;
@property (nonatomic,assign) id<MyCommentCellDelegate> delegate;
@property (nonatomic,assign) BOOL isSentComment;

+(CGFloat)heightForCellWithObject:(CommentModel *)object;
+(CGFloat)heightForSentCellWithObject:(CommentModel *)object;

@end
