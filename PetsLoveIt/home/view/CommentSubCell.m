//
//  CommentSubCell.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/5.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CommentSubCell.h"

@implementation CommentSubCell

- (void)awakeFromNib {
    // Initialization code
    _commentLabel.font = [UIFont systemFontOfSize:14];
    _commentLabel.textColor = mRGBToColor(0x666666);
    _commentLabel.disableEmoji = NO;
    _commentLabel.backgroundColor = [UIColor clearColor];
    _commentLabel.isNeedAtAndPoundSign = YES;
    _commentLabel.numberOfLines = 0;
    _commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _commentLabel.customEmojiRegex = kEmojiReg;
    _commentLabel.customEmojiPlistName = @"expression.plist";
    [self setBackgroundColor:mRGBToColor(0xf5f5f5)];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)loadCellWithModel:(CommentModel*)comment{
    
    
    NSString *commentStr = [NSString stringWithFormat:@"%@:%@",comment.nickName,comment.content];
    NSMutableAttributedString *commentContent=[[NSMutableAttributedString alloc] initWithString:commentStr];
    NSString *userNameAndBlankCharStr = [NSString stringWithFormat:@"%@:",comment.nickName];
    
    NSRange allRange = {0,[commentStr length]};
    NSRange selectedRange = {0, [userNameAndBlankCharStr length]};
    NSRange selectedRange2 = {[userNameAndBlankCharStr length],[comment.content length]};
    [commentContent addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:allRange];
    [commentContent addAttribute:NSForegroundColorAttributeName
                       value:mRGBToColor(0x333333) // 添加颜色
                       range:selectedRange];
    [commentContent addAttribute:NSForegroundColorAttributeName
                       value:mRGBToColor(0x666666) // 添加颜色
                       range:selectedRange2];
    
    _commentLabel.attributedText = commentContent;
    //_commentLabel.emojiText = commentStr;
    _floorLabel.text = comment.orderNo;
}

+(CGFloat)heightForCellWithObject:(CommentModel *)object
{
    MLEmojiLabel *_textLabel = [[MLEmojiLabel alloc]init];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.customEmojiRegex = kEmojiReg;
    _textLabel.customEmojiPlistName = @"expression.plist";
    [_textLabel setEmojiText:object.content];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.isNeedAtAndPoundSign = YES;
    _textLabel.numberOfLines = 0;
    _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize rSize = [_textLabel preferredSizeWithMaxWidth:mScreenWidth-12-25-56-10];
    
    return rSize.height + 20 ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
