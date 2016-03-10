//
//  CommentSubCell.m
//  PetsLoveIt
//
//  Created by liubingyang on 15/12/5.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "CommentSubCell.h"

@implementation CommentSubCell

- (void)awakeFromNib {
    // Initialization code
    _commentLabel.font = [UIFont systemFontOfSize:14];
    _commentLabel.textColor = mRGBToColor(0x666666);
    _commentLabel.disableEmoji = NO;
//    _commentLabel.backgroundColor = [UIColor redColor];
    _commentLabel.isNeedAtAndPoundSign = YES;
    _commentLabel.numberOfLines = 0;

    _commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _commentLabel.customEmojiRegex = kEmojiReg;
    _commentLabel.customEmojiPlistName = @"expression.plist";
    [_commentLabel setTextAlignment:NSTextAlignmentJustified];

    [self setBackgroundColor:mRGBToColor(0xf5f5f5)];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)loadCellWithModel:(CommentModel*)comment{
    
    
    NSString *commentStr = [NSString stringWithFormat:@"%@：%@",comment.nickName,comment.content];
    _commentLabel.emojiText = commentStr;
    NSString *userNameAndBlankCharStr = [NSString stringWithFormat:@"%@:",comment.nickName];
   
    NSRange selectedRange = {0, [userNameAndBlankCharStr length]};
 
    CGSize rSize = [_commentLabel preferredSizeWithMaxWidth:mScreenWidth-12-25-56-10];
    _commentLabel.height = rSize.height;
    
    [_commentLabel setEmojiAddAttri:(NSString *)kCTForegroundColorAttributeName value:mRGBToColor(0x333333) rang:selectedRange];
    
    [self.commentLabel setWidth:(mScreenWidth-56-12-25-10)];
   
    _floorLabel.text = comment.orderNo;
}

+(CGFloat)heightForCellWithObject:(CommentModel *)object
{
    MLEmojiLabel *_textLabel = [[MLEmojiLabel alloc]init];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.customEmojiRegex = kEmojiReg;
//    _textLabel.lineSpacing = 6;
    _textLabel.customEmojiPlistName = @"expression.plist";
    [_textLabel setEmojiText:[NSString stringWithFormat:@"%@：%@",object.nickName,object.content]];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.isNeedAtAndPoundSign = YES;
    _textLabel.numberOfLines = 0;
    _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize rSize = [_textLabel preferredSizeWithMaxWidth:mScreenWidth-12-25-56-10];
    
    return rSize.height + 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
