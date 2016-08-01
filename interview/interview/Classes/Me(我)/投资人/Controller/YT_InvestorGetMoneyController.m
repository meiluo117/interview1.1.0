//
//  YT_InvestorGetMoneyController.m
//  interview
//
//  Created by 于波 on 16/4/11.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_InvestorGetMoneyController.h"
#import "YT_InvestorAliPayInfoController.h"
#import "YT_InvestorPayModel.h"
#import "YT_InvestorGetMoneyInfoController.h"
#import "YT_InvestorPersonInfoModel.h"

@interface YT_InvestorGetMoneyController ()
@property (weak, nonatomic) IBOutlet UIView *AliPayView;
@property (weak, nonatomic) IBOutlet UITextField *personAliPayAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *getMoneyNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *getMoneyBtn;
- (IBAction)getMoneyBtnClick:(UIButton *)sender;
@end

@implementation YT_InvestorGetMoneyController

- (void)setGetMoneyBtn:(UIButton *)getMoneyBtn
{
    getMoneyBtn.layer.cornerRadius = 8.0f;
    getMoneyBtn.backgroundColor = btnColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.NavTitle = @"提现金额";
//    self.navigationItem.hidesBackButton = YES;
    self.personAliPayAccountTextField.enabled = NO;
    
    //点击消除键盘
    UITapGestureRecognizer *tapToCancelKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
    [self.view addGestureRecognizer:tapToCancelKeyboard];
    
    //点击消除键盘
    UITapGestureRecognizer *AliPayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpAliPayInfo)];
    [self.AliPayView addGestureRecognizer:AliPayTap];
    
    self.personAliPayAccountTextField.text = [YT_InvestorPayModel sharedPayModel].aliAccount;
    self.getMoneyNumTextField.placeholder = [NSString stringWithFormat:@"本次最多可提现%@元",[YT_InvestorPayModel sharedPayModel].balance];
}

- (void)jumpAliPayInfo
{
    YT_InvestorAliPayInfoController *aliPayVc = [[YT_InvestorAliPayInfoController alloc] init];
    [self.navigationController pushViewController:aliPayVc animated:YES];
}

-(void)cancelKeyboard{
    [self.view endEditing:YES];
}

- (IBAction)getMoneyBtnClick:(UIButton *)sender {
    CGFloat moneySum = [[YT_InvestorPayModel sharedPayModel].sum floatValue];
    CGFloat getMoney = [self.getMoneyNumTextField.text floatValue];
    if (getMoney > moneySum || getMoney <= 0) {
        [self showAlertWithWarnString:@"请输入正确的提现金额"];
    }else{
        [self sendGetMoneyRequest];
    
    }
}

- (void)sendGetMoneyRequest
{
    YT_WS(weakSelf);
    NSDictionary *params = @{@"money":self.getMoneyNumTextField.text};
    [YBHttpNetWorkTool post:Url_Investor_GetMoney params:params success:^(id json) {
        NSInteger status = [json[@"code"] integerValue];
        YT_LOG(@"提现----%@====%@",json,json[@"msg"]);
        if (status == 1) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDict = json[@"data"];
            YT_InvestorGetMoneyInfoController *getMoneyInfoVc = [[YT_InvestorGetMoneyInfoController alloc] init];
            getMoneyInfoVc.navigationItem.hidesBackButton = YES;
            getMoneyInfoVc.time = dataDict[@"time"];
            getMoneyInfoVc.balance = dataDict[@"balance"];
            getMoneyInfoVc.money = dataDict[@"money"];
            [weakSelf.navigationController pushViewController:getMoneyInfoVc animated:YES];
        }else{
            [SVProgressHUD dismiss];
            [weakSelf showAlertWithWarnString:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    } header:[YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:@"正在提交..."];
}

- (void)showAlertWithWarnString:(NSString *)warnString
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:warnString delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}
@end
