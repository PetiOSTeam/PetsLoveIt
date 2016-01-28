//
//  MyBlCell.m
//  PetsLoveIt
//
//  Created by kongjun on 15/12/9.
//  Copyright © 2015年 kongjun. All rights reserved.
//

#import "MyBlCell.h"
#import "PetWebViewController.h"
@implementation MyBlCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}
// 增加了未审核的状态
-(void)dataFill{
    BLModel *model = (BLModel *)self.model;
    self.sourceTitle.text = model.title;
    CGSize Reasonsize = [self getframeWithTitle:model.shareReason andTitleFont:[UIFont systemFontOfSize:15]];
    self.sourceTitleview.text = model.shareReason;
    [self.sourceTitleview setContentOffset:CGPointMake(0,0) animated:NO];
    [self.sourceTitleview setTextContainerInset:UIEdgeInsetsMake(-2.5, 3, -2.5, 0)];//设置UITextView的内边距
    
    [self.sourceTitleview setTextAlignment:NSTextAlignmentLeft];//并设置左对齐
    if (Reasonsize.height < self.sourceTitleview.height) {
        CGFloat height = self.sourceTitleview.height - Reasonsize.height +8;
//        self.height = self.height - height;
        self.statename.top = self.statename.top - height;
        self.stateLabel.top = self.stateLabel.top - height;
        self.sourceTitleview.height = Reasonsize.height -5;
        self.sourceTitleview.showsVerticalScrollIndicator = NO;
        self.sourceTitleview.scrollEnabled = NO;
    }else{
       [self.sourceTitleview flashScrollIndicators];
    }
    self.maskView.layer.cornerRadius = 5;
    self.maskView.frame = CGRectMake(self.sourceTitleview.frame.origin.x, self.sourceTitleview.top - 8 , self.sourceTitleview.width, self.sourceTitleview.height + 16);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClicksourceTitle)];
    [self.sourceTitle addGestureRecognizer:tap];
    if ([model.status intValue] == 1) {
        self.stateLabel.text = @"已通过";
 
    }else if ([model.status intValue] == 2)
    {
       self.stateLabel.text = @"未通过";
    }
    else{
        self.stateLabel.text = @"未审核";
    }
}

- (void)ClicksourceTitle{
    BLModel *model = (BLModel *)self.model;
    PetWebViewController *vc = [PetWebViewController new];
    vc.htmlUrl = model.sourceLink;
    if(vc.htmlUrl.length == 0){
        return;
    }
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.viewController presentViewController:navi animated:YES completion:NULL];
}
+(CGFloat)heightForCellWithObject:(BLModel *)object{
    CGFloat maxW = mScreenWidth-53;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [object.shareReason sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:maxSize];
    if (textSize.height < 86) {
        return 261 - 86 + textSize.height - 8 ;
        
    }else
    {
        return 261;
    }
    
}
// 根据文字计算标签的高度
- (CGSize)getframeWithTitle:(NSString *)title andTitleFont:(UIFont *)titlefont
{
    CGFloat maxW = mScreenWidth-53;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [title sizeWithFont:titlefont constrainedToSize:maxSize];
    
    return textSize;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    return NO;
//}
@end
