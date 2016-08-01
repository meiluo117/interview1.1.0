//
//  YT_InvestorYueController.m
//  interview
//
//  Created by 于波 on 16/4/11.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_InvestorYueController.h"
#import "UIButton+YBExtension.h"
#import "YT_BindingAliPayController.h"
#import "YT_NavigationController.h"
#import "UIButton+YBExtension.h"
#import "YT_InvestorPayModel.h"
#import "YT_InvestorGetMoneyController.h"
#import "YT_getMoneyExplainWeb.h"
#import "YT_InvestorPersonInfoModel.h"
#import "YT_serviceWebController.h"
#import <MJExtension.h>
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface YT_InvestorYueController ()<UIAlertViewDelegate>
@property (nonatomic,weak)UILabel *yueNumLable;
@property (nonatomic,weak)UILabel *totalLable;
@end

@implementation YT_InvestorYueController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self sendPayRequest];
}

- (void)sendPayRequest
{
    YT_WS(weakSelf);
    [YBHttpNetWorkTool post:Url_Investor_PayInfo params:nil success:^(id json) {
        NSInteger status = [json[@"code"] integerValue];
        YT_LOG(@"%@",json);
        if (status == 1) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDict = json[@"data"];
            YT_InvestorPayModel *model = [YT_InvestorPayModel mj_objectWithKeyValues:dataDict];
            weakSelf.yueNumLable.text = model.balance;
            weakSelf.totalLable.text = [NSString stringWithFormat:@"累计收入%@元",[YT_InvestorPayModel sharedPayModel].sum];
        }else{
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSError *error) {
        
    } header:[YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.fd_interactivePopDisabled = YES;
}

- (void)createUI
{
    self.NavTitle = @"余额";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提现明细" style:UIBarButtonItemStylePlain target:self action:@selector(money)];
    
    //橘黄色 圆
    UIImageView *orangerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 120) / 2, 94, 120, 120)];
    orangerImageView.userInteractionEnabled = YES;
    orangerImageView.backgroundColor = YT_Color(240, 111, 48, 1);
    orangerImageView.layer.cornerRadius = 120 / 2;
    [self.view addSubview:orangerImageView];
    //橘黄色内 余额 文字
    UILabel *orangerYueLable = [[UILabel alloc] initWithFrame:CGRectMake(35, 30, 30, 20)];
    orangerYueLable.text = @"余额";
    orangerYueLable.textColor = [UIColor whiteColor];
    orangerYueLable.font = [UIFont systemFontOfSize:14];
    orangerYueLable.textAlignment = NSTextAlignmentCenter;
    [orangerImageView addSubview:orangerYueLable];
    //橘黄色内 (元) 文字
    UILabel *orangerYuanLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(orangerYueLable.frame), 32, 20, 20)];
    orangerYuanLable.text = @"(元)";
    orangerYuanLable.textColor = [UIColor whiteColor];
    orangerYuanLable.font = [UIFont systemFontOfSize:10];
    orangerYuanLable.textAlignment = NSTextAlignmentCenter;
    [orangerImageView addSubview:orangerYuanLable];
    //橘黄色内 余额1000 文字
    UILabel *orangerYuanNumLable = [[UILabel alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(orangerYueLable.frame) + 5, 80, 20)];
    orangerYuanNumLable.text = [YT_InvestorPayModel sharedPayModel].balance;
    orangerYuanNumLable.textColor = [UIColor whiteColor];
    orangerYuanNumLable.font = [UIFont systemFontOfSize:22];
    orangerYuanNumLable.textAlignment = NSTextAlignmentCenter;
    self.yueNumLable = orangerYuanNumLable;
    [orangerImageView addSubview:self.yueNumLable];
    //灰色 余额提现 文字
    UILabel *totalLable = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 150) / 2, CGRectGetMaxY(orangerImageView.frame) + 10, 150, 20)];
    totalLable.textAlignment = NSTextAlignmentCenter;
    totalLable.textColor = YT_ColorFromRGB(0x878787);
    totalLable.font = [UIFont systemFontOfSize:13];
    self.totalLable = totalLable;
    self.totalLable.text = [NSString stringWithFormat:@"累计收入%@元",[YT_InvestorPayModel sharedPayModel].sum];
    [self.view addSubview:self.totalLable];
    
    UIButton *getMoneyBtn = [UIButton greenBtnWithTarget:self Action:@selector(getMoneyBtnClick:) btnTitle:@"提现" btnX:20 btnY:CGRectGetMaxY(totalLable.frame) + 30 andBtnWidth:ScreenWidth - 40];
    [self.view addSubview:getMoneyBtn];
    //常见问题
    UIButton *questionBtn = [UIButton otherBtnWithTarget:self Action:@selector(questionBtnClick) btnTitle:@"常见问题" andBtnFrame:CGRectMake((ScreenWidth - 100) / 2, ScreenHeight - 50, 100, 20)];
    [self.view addSubview:questionBtn];
}
- (void)questionBtnClick
{
    YT_serviceWebController *upBPVc = [[YT_serviceWebController alloc] init];
    upBPVc.navTitle = @"常见问题";
    upBPVc.url = Url_CommonQuestion;
    [self.navigationController pushViewController:upBPVc animated:YES];
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)money
{
    YT_getMoneyExplainWeb *Vc = [[YT_getMoneyExplainWeb alloc] init];
    Vc.userID = [YT_InvestorPersonInfoModel sharedPersonInfoModel].userId;
    [self.navigationController pushViewController:Vc animated:YES];
}

- (void)getMoneyBtnClick:(UIButton *)btn
{
//    YT_BindingAliPayController *bindingAliPayVc = [[YT_BindingAliPayController alloc] init];
//    bindingAliPayVc.totalMoney = self.totalMoney;
//    [self.navigationController pushViewController:bindingAliPayVc animated:YES];
    
    if ([YT_InvestorPayModel sharedPayModel].aliAccount.length == 0) {
        [self showAlert];
    }else{
        YT_InvestorGetMoneyController *getMoneyVc = [[YT_InvestorGetMoneyController alloc] init];
        getMoneyVc.yueVc = self;
        [self.navigationController pushViewController:getMoneyVc animated:YES];
    }
    
}

- (void)showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"首次使用提现功能请添加支付宝账号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即添加", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        YT_BindingAliPayController *bindingAliPayVc = [[YT_BindingAliPayController alloc] init];
        YT_NavigationController *nav = [[YT_NavigationController alloc] initWithRootViewController:bindingAliPayVc];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        
    }
}
@end
