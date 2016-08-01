//
//  YT_investorDateController.m
//  interview
//
//  Created by Mickey on 16/5/11.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_investorDateController.h"
#import "HXTagsView.h"
#import "HXTagView.h"
#import <MJExtension.h>
#import "UIButton+YBExtension.h"
#import "YT_dateTimeAndPlaceController.h"
#import "YT_InvestorPersonInfoModel.h"
#import "YT_DateInvestorOrderRequestModel.h"
#import "YT_DateInvestorOrderDataModel.h"
#import "YT_DateInvestorOrderIndustryListModel.h"
#import "YT_ReadBPWebController.h"
#import "YT_Enum.h"
#import "YT_investorDate22Controller.h"
#import "NSString+YBExtension.h"
#import "YT_InvestorDateTableController.h"

@interface YT_investorDateController ()<UIAlertViewDelegate>
@property (weak,nonatomic) UIView *bgWhiteView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
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
@property (weak, nonatomic) IBOutlet UIButton *noBtn;
- (IBAction)noBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderLable;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLable;
- (IBAction)yesBtnClick:(id)sender;
@end

@implementation YT_investorDateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self readOrderRequest];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"zuojiantou"];
}

- (void)back
{
//    if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[NSClassFromString(@"YT_HomeController") class]] || [[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[NSClassFromString(@"YT_InvestorForMeController") class]]) {
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
//    }else{
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//    }
    if ([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[YT_InvestorDateTableController class]]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else{
        if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[NSClassFromString(@"YT_HomeController") class]] || [[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[NSClassFromString(@"YT_InvestorForMeController") class]]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(self.bgWhiteView.frame) + 20);
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
        YT_LOG(@"error---%@",error);
    } header:[YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:nil];
}

- (void)createUI
{
    YT_DateInvestorOrderRequestModel *model = [YT_DateInvestorOrderRequestModel sharedModel];

    self.NavTitle = @"待投资人接受";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.noBtn.backgroundColor = YT_Color(228, 228, 228, 1);
    self.noBtn.layer.cornerRadius = 6;
    self.yesBtn.backgroundColor = titleColor;
    self.yesBtn.layer.cornerRadius = 6;
    
    NSString *order = [NSString orderNumberStringWithFormat:model.data.orderNo];
    self.orderLable.attributedText = [NSString orderNumberLableTextAttributedWithString:order];
    self.orderTimeLable.text = [NSString orderTimeStringWithFormat:model.data.orderTime];
    
    //背景白色view
    UIView *bgWhiteView = [[UIView alloc] initWithFrame:CGRectMake(10, 180, ScreenWidth - 20, 500)];
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
    
    //公司
    UILabel *companyL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(grayLineView.frame) + 10, 200, 30)];
    companyL.textColor = [UIColor blackColor];
    companyL.textAlignment = NSTextAlignmentLeft;
    companyL.font = [UIFont systemFontOfSize:22];
    companyL.text = model.data.proName;
    [companyL sizeToFit];
    self.companyLable = companyL;
    [self.bgWhiteView  addSubview:self.companyLable];
    
    //城市
    UILabel *cityL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.companyLable.frame) + 5, CGRectGetMaxY(grayLineView.frame) + 17, 50, 20)];
    cityL.textColor = [UIColor grayColor];
    cityL.textAlignment = NSTextAlignmentLeft;
    cityL.font = [UIFont systemFontOfSize:14];
    cityL.text = [YT_Enum productItemStatus:[model.data.stage integerValue]];
    self.cityLable = cityL;
    [self.bgWhiteView  addSubview:self.cityLable];
    
    //项目状态
    UILabel *itemStatusL = [[UILabel alloc] initWithFrame:CGRectMake(self.bgWhiteView .width - 10 - 60, CGRectGetMaxY(grayLineView.frame) + 17, 60, 20)];
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
    [self.bgWhiteView addSubview:self.iconTitleLable];
    
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
}

- (void)readBtnClick:(UIButton *)btn
{
    YT_ReadBPWebController *web = [[YT_ReadBPWebController alloc] init];
    web.bpUrl = [YT_DateInvestorOrderRequestModel sharedModel].data.bpUrl;
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)noBtnClick:(UIButton *)sender {//拒绝
    
    [self showAlertWithTitleString:@"确认拒绝约见申请?"];
}
- (IBAction)yesBtnClick:(id)sender {//接受
    YT_dateTimeAndPlaceController *timeAndPlaceVc = [[YT_dateTimeAndPlaceController alloc] init];
    timeAndPlaceVc.orderId = self.orderID;
    [self.navigationController pushViewController:timeAndPlaceVc animated:YES];
}

- (void)showAlertWithTitleString:(NSString *)titleStr
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:titleStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拒绝", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        YT_WS(weakSelf);
        NSDictionary *params = @{@"accept":@"2",
                                 @"orderId":self.orderID,
                                 @"time":@"",
                                 @"address":@""};
        
        [YBHttpNetWorkTool post:Url_Date_InvestorAccept params:params success:^(id json) {
            
            NSInteger status = [json[@"code"] integerValue];
            if (status == 1) {
                [SVProgressHUD dismiss];
                YT_investorDate22Controller *investorDate22Vc = [[YT_investorDate22Controller alloc] init];
                investorDate22Vc.orderID = weakSelf.orderID;
                [weakSelf.navigationController pushViewController:investorDate22Vc animated:YES];
            }else{
                
                [SVProgressHUD showErrorWithStatus:json[@"msg"]];
            }
            
        } failure:^(NSError *error) {
            
        } header:[YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:@"正在提交信息..."];
    }
}

@end
