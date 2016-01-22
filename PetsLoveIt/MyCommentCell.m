//
//  MyCommentCell.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/9.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "MyCommentCell.h"
#import "GoodsDetailViewController.h"

@implementation MyCommentCell

- (void)awakeFromNib {
    // Initialization code
    
    _myCommentLabel.font = [UIFont systemFontOfSize:14];
    _myCommentLabel.textColor = mRGBToColor(0x666666);
    
    _myCommentLabel.disableEmoji = NO;
    _myCommentLabel.backgroundColor = [UIColor clearColor];
    _myCommentLabel.isNeedAtAndPoundSign = YES;
    _myCommentLabel.numberOfLines = 0;
    _myCommentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _myCommentLabel.customEmojiRegex = kEmojiReg;
    _myCommentLabel.customEmojiPlistName = @"expression.plist";
    [_myCommentLabel setTextAlignment:NSTextAlignmentJustified];
    
    _otherCommentLabel.font = [UIFont systemFontOfSize:14];
    _otherCommentLabel.textColor = mRGBToColor(0x666666);
    _otherCommentLabel.disableEmoji = NO;
    _otherCommentLabel.backgroundColor = [UIColor clearColor];
    _otherCommentLabel.isNeedAtAndPoundSign = YES;
    _otherCommentLabel.numberOfLines = 0;
    _otherCommentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _otherCommentLabel.customEmojiRegex = kEmojiReg;
    _otherCommentLabel.customEmojiPlistName = @"expression.plist";
    [_otherCommentLabel setTextAlignment:NSTextAlignmentJustified];

    
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 18;
    
    self.originalProductView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnProductView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnProductView)];
    [self.originalProductView addGestureRecognizer:tapOnProductView];
    
    self.myCommentView.width = mScreenWidth - 66;
    self.myCommentView.layer.borderColor = mRGBToColor(0xd2d2d2).CGColor;
    self.myCommentView.layer.borderWidth = 0.5;
   
    self.originalProductView.width = mScreenWidth - 66;
    self.originalProductView.layer.borderColor = mRGBToColor(0xd8d6c9).CGColor;
    self.originalProductView.layer.borderWidth = 0.5;
    
   UIImageView *dotOnCommentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redDotIcon"]];
    dotOnCommentImage.backgroundColor = [UIColor clearColor];
    dotOnCommentImage.frame = CGRectMake(self.avatarImageView.center.x - 3 , self.avatarImageView.bottom + 10, 6, 6);
    [self.contentView addSubview:dotOnCommentImage];
    self.dotOnCommentImage = dotOnCommentImage;
    self.dotOnCommentImage.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

-(void)dataFill{
    
    CommentModel *comment = (CommentModel *)self.model;
    if (self.isSentComment == NO) {
        if ([comment.hasread isEqualToString:@"0"]) {
            self.dotOnCommentImage.hidden = NO;
        }
    }
   
    self.nameLabel.text = self.isSentComment==NO?comment.otherNickName:@"发出评论";
    self.dateLabel.text = comment.timeFlag;
    
    if (self.isSentComment) {
        self.myCommentView.height = 0 ;
    
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.userIcon] placeholderImage:kDefaultHeadImage];
    }else{
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:comment.otherUserIcon] placeholderImage:kDefaultHeadImage];
        self.myCommentLabel.emojiText = [NSString stringWithFormat:@"%@：%@",[AppCache getUserName],comment.otherContent] ;
        //自适应titleLabel的高度
        [self.myCommentLabel setWidth:(mScreenWidth-self.myCommentView.left-30)];
        [self.myCommentLabel sizeToFit];
        self.myCommentView.height = self.myCommentLabel.bottom +10;
        if (self.myCommentLabel.height < 21) {
            self.myCommentLabel.height = 21;
        }
    }
    
    if (self.isSentComment) {
        self.otherCommentLabel.top = self.avatarImageView.bottom + 10;
        self.otherCommentLabel.emojiText = comment.content;

    }else{
        self.otherCommentLabel.top = self.myCommentView.bottom + 15;
        self.otherCommentLabel.emojiText = comment.content;

    }
    //自适应titleLabel的高度
    [self.otherCommentLabel setWidth:(mScreenWidth-self.otherCommentLabel.left-10)];
    [self.otherCommentLabel sizeToFit];
    
    if (self.otherCommentLabel.height < 21) {
        self.otherCommentLabel.height = 21;
    }
    
    self.originalProductView.top = self.otherCommentLabel.bottom + 12;
    self.productLabel.text = [NSString stringWithFormat:@"原文:%@",comment.prodName];
}

- (void)tapOnProductView{
    CommentModel *comment = (CommentModel *)self.model;
    if ([self.delegate respondsToSelector:@selector(showProductVC:)]) {
        [self.delegate showProductVC:comment.productId];
    }
}

+(CGFloat)heightForSentCellWithObject:(CommentModel *)object
{
    
    MLEmojiLabel *_textLabel2 = [[MLEmojiLabel alloc]init];
    _textLabel2.font = [UIFont systemFontOfSize:14];
    [_textLabel2 setEmojiText:object.content];
    _textLabel2.customEmojiRegex = kEmojiReg;
    _textLabel2.customEmojiPlistName = @"expression.plist";
    _textLabel2.backgroundColor = [UIColor clearColor];
    _textLabel2.isNeedAtAndPoundSign = YES;
    _textLabel2.numberOfLines = 0;
    _textLabel2.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize rSize2 = [_textLabel2 preferredSizeWithMaxWidth:mScreenWidth-10-56 ];
    if (rSize2.height <21) {
        rSize2 = CGSizeMake(rSize2.width, 21);
    }
    
    return rSize2.height +51+15+12+28+20;
}


+(CGFloat)heightForCellWithObject:(CommentModel *)object
{
    MLEmojiLabel *_textLabel = [[MLEmojiLabel alloc]init];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.customEmojiRegex = kEmojiReg;
    _textLabel.customEmojiPlistName = @"expression.plist";
    [_textLabel setEmojiText:[NSString stringWithFormat:@"%@：%@",[AppCache getUserName],object.otherContent]];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.isNeedAtAndPoundSign = YES;
    _textLabel.numberOfLines = 0;
    _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize rSize = [_textLabel preferredSizeWithMaxWidth:mScreenWidth-30-56];
    if (rSize.height <21) {
        rSize = CGSizeMake(rSize.width, 21);
    }
    
    MLEmojiLabel *_textLabel2 = [[MLEmojiLabel alloc]init];
    _textLabel2.font = [UIFont systemFontOfSize:14];
    [_textLabel2 setEmojiText:object.content];
    _textLabel2.customEmojiRegex = kEmojiReg;
    _textLabel2.customEmojiPlistName = @"expression.plist";
    _textLabel2.backgroundColor = [UIColor clearColor];
    _textLabel2.isNeedAtAndPoundSign = YES;
    _textLabel2.numberOfLines = 0;
    _textLabel2.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize rSize2 = [_textLabel2 preferredSizeWithMaxWidth:mScreenWidth-10-56 ];
    if (rSize2.height <21) {
        rSize2 = CGSizeMake(rSize2.width, 21);
    }
    
    return rSize.height + rSize2.height +20+51+15+12+28+ 22;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
