//
//  Shaidanauthor.m
//  viewview
//
//  Created by 123 on 16/1/7.
//  Copyright © 2016年 liubingyang. All rights reserved.
//

#import "Shaidanauthor.h"
#import "YYText.h"
#import "UserpageModel.h"
#import "UserpageViewController.h"
@interface Shaidanauthor ()
@property (strong, nonatomic)  YYLabel *usersex;
@property (strong,nonatomic) UserpageModel *pageModel;
@property (weak,nonatomic) UILabel *pinglunnum;
@property (weak,nonatomic) UILabel *shaidannum;
@property (weak,nonatomic) UILabel *jingyannum;
@property (weak,nonatomic) UILabel *baoliaonum;

@end

@implementation Shaidanauthor

-(void)awakeFromNib
{
    
    self.mainView.layer.cornerRadius = 5;
    self.mainView.layer.borderWidth = 1;
    self.mainView.layer.borderColor = mRGBToColor(0xeeeeee).CGColor;
    self.iconImage.layer.cornerRadius = 35;
    self.iconImage.layer.borderWidth = 1;
    self.iconImage.layer.borderColor = mRGBToColor(0xffffff).CGColor;
//    self.detailsView.frame = CGRectMake(0, 105, [UIScreen mainScreen].bounds.size.width-40, 60);
    [self addViewWithLabelname:@"评论" andlabelNum:@"0" and:0];
    [self addViewWithLabelname:@"晒单" andlabelNum:@"0" and:1];
    [self addViewWithLabelname:@"经验" andlabelNum:@"0" and:2];
    [self addViewWithLabelname:@"爆料" andlabelNum:@"0" and:3];
    
    YYLabel *usersex = [YYLabel new];
    self.usersex =usersex;
    self.usersex.font = [UIFont systemFontOfSize:15];
    self.usersex.numberOfLines = 0;
    [self.usersex setTextAlignment:NSTextAlignmentRight];
    self.usersex.frame = CGRectMake(85+15, 30, mScreenWidth-155   ,20);
    [self.mainView addSubview:self.usersex];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickShaidanauthor)];
    [self addGestureRecognizer:tap];
}

- (void)addViewWithLabelname:(NSString *)labelname andlabelNum:(NSString *)labelnum and:(int)num
{
    UIView *tmpeview = [[UIView alloc]initWithFrame:CGRectMake(num*([UIScreen mainScreen].bounds.size.width - 40)/4, 0, ([UIScreen mainScreen].bounds.size.width - 40)/4, self.detailsView.frame.size.height)];
    [self.detailsView addSubview:tmpeview];
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, tmpeview.frame.size.width-15, 12)];
    [namelabel setTextColor:mRGBToColor(0x999999)];
    namelabel.font = [UIFont systemFontOfSize:12];
    namelabel.textAlignment = NSTextAlignmentLeft;
    namelabel.text = labelname;
    UILabel *numlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tmpeview.frame.size.width-15, 17)];
    [numlabel setTextColor:mRGBToColor(0xff4401)];
    numlabel.font = [UIFont systemFontOfSize:17];
    numlabel.textAlignment = NSTextAlignmentLeft;
    numlabel.text = labelnum;
    [tmpeview addSubview:numlabel];
    [tmpeview addSubview:namelabel];
    [self.detailsView addSubview:tmpeview];
    if (num == 0) {
        self.pinglunnum = numlabel;
    }else if (num == 1) {
        self.shaidannum = numlabel;
    }else if (num == 2){
        self.jingyannum = numlabel;
    }else if (num == 3){
        self.baoliaonum = numlabel;
    }
    if (num <3) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = mRGBToColor(0xebebeb).CGColor;
        
        border.frame = CGRectMake(tmpeview.frame.size.width - 0.5, 0, 0.5, tmpeview.frame.size.height-20);
        
        [tmpeview.layer addSublayer:border];
    }
   
    
}
// 加载数据
- (void)setUesrId:(NSString *)uesrId
{
    _uesrId = uesrId;
   if((![uesrId isEqualToString:@"0"])&&(uesrId)) {
        NSDictionary *params = @{
                                 @"uid":@"getUserInfosWithnums",
                                 @"userId":uesrId
                                 };
        [APIOperation GET:@"getCoreSv.action" parameters:params onCompletion:^(id responseData, NSError *error) {
            if (!error) {
                NSDictionary *jsondata = responseData[@"bean"];
                NSMutableDictionary *userdata = [NSMutableDictionary dictionaryWithDictionary:jsondata];
                UserpageModel *usermodel = [[UserpageModel alloc]initWithDictionary:userdata];
                self.pageModel = usermodel;
                [self.iconImage sd_setImageWithURL:[NSURL URLWithString:usermodel.userIcon] placeholderImage:kDefaultHeadImage];
                NSDictionary *attrsDic = @{NSForegroundColorAttributeName: mRGBToColor(0x666666)
                                                                      };
                NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@  ",usermodel.nickName] attributes:attrsDic];
                
                UIFont *font = [UIFont systemFontOfSize:14];
                NSMutableAttributedString *attachment = nil;
                int grade = [usermodel.userGrade intValue];
                
                int kingNum = grade/64;
                int sunNum = grade%64==0?0:grade%64/16;
                int moonNum = (grade%64==0||grade%16==0)?0:grade%16/4;
                int starNum = (grade%64==0||grade%16==0||grade%4==0)?0:grade%4;
                //如果等级为0，显示一个星星
                if (starNum == 0&&grade ==0) {
                    starNum = 1;
                }
                for (int i=0; i<kingNum; i++) {
                    UIImage *image = [UIImage imageNamed:@"kingIcon"];
                    attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                    [text appendAttributedString: attachment];
                }
                for (int i=0; i<sunNum; i++) {
                    UIImage *image = [UIImage imageNamed:@"sunIcon"];
                    attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                    [text appendAttributedString: attachment];
                }
                for (int i=0; i<moonNum; i++) {
                    UIImage *image = [UIImage imageNamed:@"moonIcon"];
                    attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                    [text appendAttributedString: attachment];
                }
                for (int i=0; i<starNum; i++) {
                    // UIImage attachment
                    UIImage *image = [UIImage imageNamed:@"starIcon"];
                    attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                    [text appendAttributedString: attachment];
                }
                
                [self.usersex setTextAlignment:NSTextAlignmentCenter];
                self.usersex.attributedText = text;
                CGSize size = CGSizeMake(mScreenWidth-155, 20);
                YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:text];
                self.usersex.width = layout.textBoundingSize.width;
                if (usermodel.commentnum) {
                    self.pinglunnum.text =  usermodel.commentnum;
                }
                if (usermodel.experienceNum) {
                    self.jingyannum.text =  usermodel.experienceNum;
                }
                if (usermodel.shareNum) {
                    self.shaidannum.text =  usermodel.shareNum;
                }
                if (usermodel.discloseNum) {
                    self.baoliaonum.text =  usermodel.discloseNum;
                }
                
                
                
                
                
            }else{
                mAlertAPIErrorInfo(error);
                
            }}];

    }
   
    
}
// 点击事件
- (void)ClickShaidanauthor
{
   
    if (self.pageModel) {
        UserpageViewController *vc = [[UserpageViewController alloc]init];
        vc.uesrId = self.uesrId;
        vc.pageModel = self.pageModel;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    
}
@end
