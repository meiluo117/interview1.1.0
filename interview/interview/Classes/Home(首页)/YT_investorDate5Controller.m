//
//  YT_investorDate5Controller.m
//  interview
//
//  Created by Mickey on 16/5/12.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_investorDate5Controller.h"
#import "HXTagsView.h"
#import "HXTagView.h"
#import "UIButton+YBExtension.h"
#import <MJExtension.h>
#import "YT_dateTimeAndPlaceController.h"
#import "YT_InvestorPersonInfoModel.h"
#import "YT_DateInvestorOrderRequestModel.h"
#import "YT_DateInvestorOrderDataModel.h"
#import "YT_DateInvestorOrderIndustryListModel.h"
#import "YT_ReadBPWebController.h"
#import "YT_Enum.h"
#import "NSString+YBExtension.h"

@interface YT_investorDate5Controller ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak,nonatomic) UIImageView *headerImageView;
@property (weak,nonatomic) UILabel *nameLable;
@property (weak,nonatomic) UILabel *companyLable;
@property (weak,nonatomic) UILabel *cityLable;
@property (weak,nonatomic) UILabel *itemStatusLable;
@property (weak,nonatomic) UILabel *itemIntroduceLable;
@property (weak,nonatomic) UILabel *teamIntroduceLable;
@property (strong,nonatomic) HXTagsView *tagsView;
@property (weak,nonatomic) UIImageView *iconImageV;//文档图标
@property (weak,nonatomic) UILabel *iconTitleLable;//文档图标
@property (weak,nonatomic) UIView *bgWhiteView;
@property (weak, nonatomic) UIButton *btnPhoneNumber;
@property (weak, nonatomic) UIButton *btnWechatNumber;
@property (weak,nonatomic) UILabel *commentLable;
@property (weak,nonatomic) UILabel *commentTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *orderLable;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *datePlaceLable;

@end

@implementation YT_investorDate5Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self readOrderRequest];
}
- (void)createData
{
    YT_WS(weakSelf);
    NSDictionary *params = @{@"orderId":self.orderID};
    [YBHttpNetWorkTool post:Url_Date_CreateOrder params:params success:^(id json) {
        YT_LOG(@"order:%@",json);
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            [YT_DateInvestorOrderRequestModel mj_objectWithKeyValues:json];
            [weakSelf createUI];
            YT_LOG(@"-----");
        }else{
            
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    } header:[YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:@"正在加载..."];
}
//确认订单已读
- (void)readOrderRequest
{
    NSDictionary *params = @{@"orderId":self.orderID,@"type":@"1",@"source":@"1"};
    [YBHttpNetWorkTool post:Url_ReadOrder params:params success:^(id json) {
        
    } failure:^(NSError *error) {
        
    } header:[YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(self.commentTimeLable.frame) + 50);
}

- (void)createUI
{
    YT_DateInvestorOrderRequestModel *model = [YT_DateInvestorOrderRequestModel sharedModel];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view1.layer.cornerRadius = 4.5;
    self.view2.layer.cornerRadius = 4.5;
    self.view3.layer.cornerRadius = 4.5;
    self.view4.layer.cornerRadius = 4.5;
    self.view5.layer.cornerRadius = 4.5;
    self.NavTitle = @"已评价";
    
    NSString *order = [NSString orderNumberStringWithFormat:model.data.orderNo];
    self.orderLable.attributedText = [NSString orderNumberLableTextAttributedWithString:order];
    self.orderTimeLable.text = [NSString orderTimeStringWithFormat:model.data.orderTime];
    self.dateTimeLable.text = model.data.time;
    self.datePlaceLable.text = model.data.address;
    
    //背景白色view
    UIView *bgWhiteView = [[UIView alloc] initWithFrame:CGRectMake(10, 210, ScreenWidth - 20, 500)];
    //    UIView *bgWhiteView = [[UIView alloc] init];
    bgWhiteView.backgroundColor = [UIColor whiteColor];
    bgWhiteView.layer.cornerRadius = 6;
    self.bgWhiteView = bgWhiteView;
    [self.scrollV addSubview:self.bgWhiteView ];
    
    //头像
    UIImageView *headerImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
    headerImageV.layer.cornerRadius = 70 / 2;
    headerImageV.layer.masksToBounds = YES;
    if (model.data.headImg.length == 0) {
        headerImageV.image = [UIImage imageNamed:@"morentouxiang"];
    }else{
        [headerImageV sd_setImageWithURL:[NSURL URLWithString:model.data.headImg]];
    }
    self.headerImageView = headerImageV;
    [self.bgWhiteView  addSubview:self.headerImageView];
    
    //姓名
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 10, 20, 100, 30)];
    nameL.font = [UIFont systemFontOfSize:20];
    nameL.textColor = titleColor;
    nameL.textAlignment = NSTextAlignmentLeft;
    nameL.text = model.data.founderName;
    self.nameLable = nameL;
    [self.nameLable sizeToFit];
    [self.bgWhiteView  addSubview:self.nameLable];
    
    //灰色分割线
    UIView *grayLineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.headerImageView.frame) + 5, bgWhiteView.width - 20, 1)];
    grayLineView.backgroundColor = YT_Color(228, 228, 228, 1);
    [self.bgWhiteView  addSubview:grayLineView];
    
    //手机文字
    UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(grayLineView.frame) + 5, 50, 20)];
    phone.font = [UIFont systemFontOfSize:14];
    phone.textColor = [UIColor grayColor];
    phone.textAlignment = NSTextAlignmentLeft;
    phone.text = @"手机";
    [self.bgWhiteView addSubview:phone];
    
    //手机号
    UIButton *btnPhone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPhone.frame = CGRectMake(CGRectGetMaxX(phone.frame) + 5, CGRectGetMaxY(grayLineView.frame) + 5, 130, 20);
    [btnPhone setTitleColor:btnColor forState:UIControlStateNormal];
    btnPhone.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnPhone setTitle:model.data.founderMobile forState:UIControlStateNormal];
    btnPhone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnPhone addTarget:self action:@selector(callForMe) forControlEvents:UIControlEventTouchUpInside];
    self.btnPhoneNumber = btnPhone;
    [self.bgWhiteView addSubview:self.btnPhoneNumber];
    
    //微信文字
    UILabel *wechat = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(phone.frame) + 5, 50, 20)];
    wechat.font = [UIFont systemFontOfSize:14];
    wechat.textColor = [UIColor grayColor];
    wechat.textAlignment = NSTextAlignmentLeft;
    wechat.text = @"微信";
    [self.bgWhiteView addSubview:wechat];
    
    //微信号
    UIButton *btnWechat = [UIButton buttonWithType:UIButtonTypeCustom];
    btnWechat.frame = CGRectMake(CGRectGetMaxX(wechat.frame) + 5, CGRectGetMaxY(self.btnPhoneNumber.frame) + 5, 250, 20);
    [btnWechat setTitleColor:btnColor forState:UIControlStateNormal];
    btnWechat.titleLabel.font = [UIFont systemFontOfSize:14];
    btnWechat.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnWechat setTitle:model.data.founderWechat forState:UIControlStateNormal];
    [btnWechat addTarget:self action:@selector(copyWechatNumber) forControlEvents:UIControlEventTouchUpInside];
    self.btnWechatNumber = btnWechat;
    [self.bgWhiteView addSubview:self.btnWechatNumber];
    
    //灰色分割线
    UIView *grayLine3View = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(wechat.frame) + 5, self.bgWhiteView.width - 20, 1)];
    grayLine3View.backgroundColor = YT_Color(228, 228, 228, 1);
    [self.bgWhiteView  addSubview:grayLine3View];
    
    //公司
    UILabel *companyL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(grayLine3View.frame) + 10, 200, 30)];
    companyL.textColor = [UIColor blackColor];
    companyL.textAlignment = NSTextAlignmentLeft;
    companyL.font = [UIFont systemFontOfSize:22];
    companyL.text = model.data.proName;
    [companyL sizeToFit];
    self.companyLable = companyL;
    [self.bgWhiteView  addSubview:self.companyLable];
    
    //城市
    UILabel *cityL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.companyLable.frame) + 5, CGRectGetMaxY(grayLine3View.frame) + 17, 50, 20)];
    cityL.textColor = [UIColor grayColor];
    cityL.textAlignment = NSTextAlignmentLeft;
    cityL.font = [UIFont systemFontOfSize:14];
    cityL.text = [YT_Enum productItemStatus:[model.data.stage integerValue]];
    self.cityLable = cityL;
    [self.bgWhiteView  addSubview:self.cityLable];
    
    //项目状态
    UILabel *itemStatusL = [[UILabel alloc] initWithFrame:CGRectMake(self.bgWhiteView .width - 10 - 60, CGRectGetMaxY(grayLine3View.frame) + 17, 60, 20)];
    itemStatusL.textColor = [UIColor grayColor];
    itemStatusL.textAlignment = NSTextAlignmentRight;
    itemStatusL.font = [UIFont systemFontOfSize:14];
    itemStatusL.text = model.data.proCity;
    self.itemStatusLable = itemStatusL;
    [self.bgWhiteView  addSubview:self.itemStatusLable];
    
    //行业标签
    NSMutableArray *tagAry = [NSMutableArray array];
    
    for (YT_DateInvestorOrderIndustryListModel *listModel in model.data.industryList) {
        [tagAry addObject:listModel.value];
    }
    NSArray *arr = [tagAry copy];
    NSDictionary *propertyDic = @{@"type":@"0"};//可添加多个属性
    float height = [HXTagsView getTagsViewHeight:tagAry dic:propertyDic];
    self.tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.companyLable.frame) + 1,self.bgWhiteView .width - 10,height)];
    //以下2种方式皆可或者不设置,默认为单行
    self.tagsView.type = 0;
    //tagsView.propertyDic = propertyDic;
    self.tagsView.tagAry = arr;
    self.tagsView.normalBackgroundColor = titleColor;
    self.tagsView.selectedBackgroundColor = titleColor;
    self.tagsView.borderNormalColor = titleColor;
    self.tagsView.borderSelectedColor = titleColor;
    self.tagsView.titleNormalColor = [UIColor whiteColor];
    self.tagsView.titleSelectedColor = [UIColor whiteColor];
    self.tagsView.backgroundColor = [UIColor whiteColor];
    self.tagsView.titleSize = 12;
    self.tagsView.tagHeight = 20;
    self.tagsView.cornerRadius = 10;
    [self.bgWhiteView  addSubview:self.tagsView];
    
    //项目简介文字
    UILabel *itemIntroduceL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tagsView.frame) + 1, 100, 20)];
    itemIntroduceL.textColor = [UIColor grayColor];
    itemIntroduceL.textAlignment = NSTextAlignmentLeft;
    itemIntroduceL.font = [UIFont systemFontOfSize:12];
    itemIntroduceL.text = @"项目简介";
    [self.bgWhiteView  addSubview:itemIntroduceL];
    
    //项目简介
    UILabel *item = [[UILabel alloc] init];
    item.font = [UIFont systemFontOfSize:14];
    if (model.data.proIntroduce.length == 0) {
        item.text = @"暂无";
    }else{
        item.text = model.data.proIntroduce;
    }
    item.numberOfLines = 0;
    item.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(self.bgWhiteView .width - 30, 9999);
    CGSize expectSize = [item sizeThatFits:maximumLabelSize];
    item.frame = CGRectMake(15, CGRectGetMaxY(itemIntroduceL.frame) + 5, expectSize.width, expectSize.height);
    self.itemIntroduceLable = item;
    [self.bgWhiteView  addSubview:self.itemIntroduceLable];
    
    //团队介绍文字
    UILabel *teamIntroduceL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.itemIntroduceLable.frame) + 5, 100, 20)];
    teamIntroduceL.textColor = [UIColor grayColor];
    teamIntroduceL.textAlignment = NSTextAlignmentLeft;
    teamIntroduceL.font = [UIFont systemFontOfSize:12];
    teamIntroduceL.text = @"团队介绍";
    [self.bgWhiteView  addSubview:teamIntroduceL];
    
    //团队介绍
    UILabel *team = [[UILabel alloc] init];
    team.font = [UIFont systemFontOfSize:14];
    team.font = [UIFont systemFontOfSize:14];
    if (model.data.teamIntroduce.length == 0) {
        team.text = @"暂无";
    }else{
        team.text = model.data.teamIntroduce;
    }
    team.numberOfLines = 0;
    team.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSizeTeam = CGSizeMake(self.bgWhiteView .width - 30, 9999);
    CGSize expectSizeTeam = [team sizeThatFits:maximumLabelSizeTeam];
    team.frame = CGRectMake(15, CGRectGetMaxY(teamIntroduceL.frame) + 5, expectSizeTeam.width, expectSizeTeam.height);
    self.teamIntroduceLable = team;
    [self.bgWhiteView  addSubview:self.teamIntroduceLable];
    
    //灰色分割线
    UIView *grayLine2View = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.teamIntroduceLable.frame) + 5, self.bgWhiteView .width - 20, 1)];
    grayLine2View.backgroundColor = YT_Color(228, 228, 228, 1);
    [self.bgWhiteView  addSubview:grayLine2View];
    
    //文档图片
    UIImageView *iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(grayLine2View.frame) + 10, 50, 50)];
    iconImageV.layer.cornerRadius = 5;
    iconImageV.image = [UIImage imageNamed:@"word"];
    self.iconImageV = iconImageV;
    [self.bgWhiteView  addSubview:self.iconImageV];
    
    //文档标题
    UILabel *iconTitleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageV.frame) + 8, CGRectGetMaxY(grayLine2View.frame) + 8, self.bgWhiteView .width - 75, 20)];
    iconTitleL.textColor = [UIColor grayColor];
    iconTitleL.textAlignment = NSTextAlignmentLeft;
    iconTitleL.font = [UIFont systemFontOfSize:13];
    self.iconTitleLable = iconTitleL;
    [self.bgWhiteView  addSubview:self.iconTitleLable];
    
    //点击阅读button
    UIButton *readBtn = [UIButton otherBtnWithTarget:self Action:@selector(readBtnClick:) btnTitle:@"点击阅读" andBtnFrame:CGRectMake(CGRectGetMaxX(self.iconImageV.frame) + 5, CGRectGetMaxY(self.iconTitleLable.frame) + 5, 60, 20)];
    [self.bgWhiteView  addSubview:readBtn];
    
    //若无商业计划书 隐藏点击阅读按钮
    if (model.data.bpNameFont.length == 0) {
        self.iconTitleLable.text = @"暂无商业计划书";
        readBtn.hidden = YES;
    }else{
        self.iconTitleLable.text = model.data.bpNameFont;
    }
    
    //重新计算bgWhiteView.height
    self.bgWhiteView .height = CGRectGetMaxY(readBtn.frame) + 20;
    
    //团队评价文字
    UILabel *comment = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 100) / 2, CGRectGetMaxY(self.bgWhiteView.frame) + 20, 100, 20)];
    comment.textColor = [UIColor grayColor];
    comment.textAlignment = NSTextAlignmentCenter;
    comment.font = [UIFont systemFontOfSize:12];
    comment.text = @"团队评价";
    [self.scrollV  addSubview:comment];
    
    //评论内容
    UILabel *commentLable = [[UILabel alloc] init];
    commentLable.font = [UIFont systemFontOfSize:14];
    if (model.data.evaluate.length == 0) {
        commentLable.text = @"暂无评论";
    }else{
        commentLable.text = model.data.evaluate;
    }
    commentLable.numberOfLines = 0;
    commentLable.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSizeComment = CGSizeMake(ScreenWidth - 40, 9999);
    CGSize expectSizeComment = [commentLable sizeThatFits:maximumLabelSizeComment];
    commentLable.frame = CGRectMake(20, CGRectGetMaxY(comment.frame) + 20, expectSizeComment.width, expectSizeComment.height);
    self.commentLable = commentLable;
    [self.scrollV  addSubview:self.commentLable];
    
    //评论时间
    UILabel *commentTime = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 250) / 2, CGRectGetMaxY(self.commentLable.frame) + 10, 250, 20)];
    commentTime.textColor = YT_Color(221, 221, 221, 1);
    commentTime.textAlignment = NSTextAlignmentCenter;
    commentTime.font = [UIFont systemFontOfSize:12];
    if (model.data.evaluateTime.length == 0) {
        commentTime.text = @"无";
    }else{
        commentTime.text = model.data.evaluateTime;
    }
    self.commentTimeLable = commentTime;
    [self.scrollV addSubview:self.commentTimeLable];
    
}

- (void)readBtnClick:(UIButton *)btn
{
    YT_ReadBPWebController *web = [[YT_ReadBPWebController alloc] init];
    web.bpUrl = [YT_DateInvestorOrderRequestModel sharedModel].data.bpUrl;
    [self.navigationController pushViewController:web animated:YES];
}

- (void)callForMe
{
    [self showAlertWithTitleString:self.btnPhoneNumber.titleLabel.text andIsPhoneNum:YES];
}

- (void)copyWechatNumber
{
    [self showAlertWithTitleString:self.btnWechatNumber.titleLabel.text andIsPhoneNum:NO];
}

- (void)showAlertWithTitleString:(NSString *)titleStr andIsPhoneNum:(BOOL)isPhoneNumber
{
    if (isPhoneNumber) {
        UIAlertView *alertPhone = [[UIAlertView alloc] initWithTitle:@"是否拨打电话?" message:titleStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        alertPhone.tag = 10000;
        [alertPhone show];
    }else{
        UIAlertView *alertWechat = [[UIAlertView alloc] initWithTitle:@"是否复制微信号?" message:titleStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"复制", nil];
        alertWechat.tag = 10001;
        [alertWechat show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            
            NSString *call = [NSString stringWithFormat:@"tel://%@",self.btnPhoneNumber.titleLabel.text];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:call]];
        }
    }else if (alertView.tag == 10001){
        if (buttonIndex == 1) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.btnWechatNumber.titleLabel.text;
        }
    }
}

@end
