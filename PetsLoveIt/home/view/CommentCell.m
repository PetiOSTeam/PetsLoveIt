//
//  CommentCell.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/5.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "CommentCell.h"
#import "UserpageViewController.h"

@implementation CommentCell{

}

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
    [_commentLabel setTextAlignment:NSTextAlignmentJustified];

    
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 18;
    
    self.tableView.width = mScreenWidth - 56 -10;
    self.tableView.layer.borderColor = mRGBToColor(0xd2d2d2).CGColor;
    self.tableView.layer.borderWidth = kLayerBorderWidth;
    self.tableView.layer.cornerRadius = 2;
    
    
}
- (void)setupHotcommentCellFrameWith:(NSInteger)index andpraiseNum:(NSString *)praisenum{
    self.avatarImageView.left = 20;
    self.IocnButton.frame = self.avatarImageView.frame;
    self.nameLabel.left = self.avatarImageView.right+10;
    self.nameLabel.top = 15;
    self.dateLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom, 100, self.dateLabel.height);
    self.commentLabel.left = 20;
    
    _zanImage.hidden = NO;
    _zanImage.image = [UIImage imageNamed:@"upIcon"];
    _zanImage.frame =CGRectMake(0, 0, 25, 25);
    _zanImage.right = self.width- 10;
    _zanImage.center = CGPointMake(_zanImage.center.x, self.avatarImageView.center.y);
    
    _zanLabel.hidden = NO;
    _zanLabel.right = _zanImage.left ;
    _zanLabel.center = CGPointMake(_zanLabel.center.x, _zanImage.center.y+2);
    
    // 设置label的格式和内容
    NSString *datalabeltitle = [NSString stringWithFormat:@"TOP%li  %@",index+1,self.dateLabel.text];
    self.dateLabel.text = datalabeltitle;
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    self.dateLabel.font = [UIFont systemFontOfSize:10];
    [self.dateLabel setTextColor:mRGBColor(153, 153, 153)];
    _zanLabel.text = [NSString stringWithFormat:@" %@",praisenum];
;
    _zanLabel.textAlignment = NSTextAlignmentRight;
    _zanLabel.font = [UIFont systemFontOfSize:10];
    [_zanLabel setTextColor:mRGBColor(153, 153, 153)];
    
}
-(void)dataFill{
    CommentModel *comment = (CommentModel *)self.model;
    [self loadViewWithModel:comment];
    if (self.isHotcomment) {
        [self setupHotcommentCellFrameWith:self.Hotcomenindex andpraiseNum:comment.praiseNum];
    }
}

- (void)loadViewWithModel:(CommentModel *)comment{
    //显示parent评论
    
    
    if (comment.subComments) {
        self.tableView.rootModel = comment;
        self.tableView.supercell = self;
        [self.tableView.dataArray removeAllObjects];
        
        [comment.subComments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView.dataArray  addObject:[[CommentModel alloc] initWithDictionary:obj]];
        }];
//        //按orderNO排序
//        [self.tableView.dataArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            CommentModel *model1 = obj1;
//            CommentModel *model2 = obj2;
//            return [model1.orderNo intValue]<[model2.orderNo intValue];
//        }];
        [self.tableView reloadData];
        self.tableView.height = self.tableView.contentSize.height;
    }else{
        self.tableView.height = 0;
    }
    self.commentLabel.top = self.tableView.bottom + 10;
    self.commentLabel.emojiText = comment.content;
    //自适应titleLabel的高度
    [self.commentLabel setWidth:(mScreenWidth-self.commentLabel.left-10)];
    [self.commentLabel sizeToFit];
    if (self.commentLabel.height < 21) {
        self.commentLabel.height = 21;
    }
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:comment.userIcon] placeholderImage:kDefaultHeadImage];
    self.nameLabel.text = comment.nickName;
    self.dateLabel.text = comment.timeFlag;
    self.floorLabel.text = [NSString stringWithFormat:@"%@楼",comment.orderNo];
}

+ (CGFloat)heightForCellWithObject:(CommentModel *)object
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
    CGSize rSize = [_textLabel preferredSizeWithMaxWidth:mScreenWidth-10-56];
    
   __block CGFloat tableHeight = 0;

    if (object.subComments) {
        [object.subComments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CommentModel *parentComment = [[CommentModel alloc] initWithDictionary:obj];
            MLEmojiLabel *_textLabel = [[MLEmojiLabel alloc]init];
            _textLabel.font = [UIFont systemFontOfSize:14];
//            _textLabel.lineSpacing = 6;
            _textLabel.customEmojiRegex = kEmojiReg;
            _textLabel.customEmojiPlistName = @"expression.plist";
            [_textLabel setEmojiText:[NSString stringWithFormat:@"%@：%@",parentComment.nickName,parentComment.content]];
            _textLabel.backgroundColor = [UIColor clearColor];
            _textLabel.isNeedAtAndPoundSign = YES;
            _textLabel.numberOfLines = 0;
            _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize rSize = [_textLabel preferredSizeWithMaxWidth:mScreenWidth-56-12-25-10];
            tableHeight+=rSize.height+20;
        }];
    }
    
    if (([object.maxOrderNo intValue] <= 6)||(object.loadallFlag == YES)) {
        return rSize.height + 30 +51 + tableHeight;
    }else
    {
        return rSize.height + 30 +51 + tableHeight+43;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickIocn {
//        CommentModel *comment = (CommentModel *)self.model;
//    NSLog(@"clickIocn%@",comment.userName);
//    UserpageViewController *vc = [[UserpageViewController alloc]init];
//    vc.uesrId = comment.userId;
//    
//    [self.viewController.navigationController pushViewController:vc animated:YES];
}
@end
