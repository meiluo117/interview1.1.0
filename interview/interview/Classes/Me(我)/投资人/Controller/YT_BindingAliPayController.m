//
//  YT_BindingAliPayController.m
//  interview
//
//  Created by 于波 on 16/4/11.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_BindingAliPayController.h"
#import "YT_InvestorGetMoneyController.h"
#import "YBVerify.h"
#import "YT_InvestorPersonInfoModel.h"
#import "YT_InvestorPayModel.h"
#import <MJExtension.h>

@interface YT_BindingAliPayController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *personIDCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *personAliPayAccountTextField;
@property (weak, nonatomic) IBOutlet UILabel *warningLable;
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
- (IBAction)finishBtnClick:(UIButton *)sender;


@end

@implementation YT_BindingAliPayController

- (void)setFinishBtn:(UIButton *)finishBtn
{
    finishBtn.layer.cornerRadius = 8.0f;
    finishBtn.backgroundColor = btnColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)showWarning:(NSString *)warning
{
    self.warningLable.text = warning;
    self.warningView.alpha = 1.0f;
    [UIView animateWithDuration:WarningTime animations:^{
        self.warningView.alpha = 0.0f;
    }];
}

- (void)createUI
{
    //点击消除键盘
    UITapGestureRecognizer *tapToCancelKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
    [self.view addGestureRecognizer:tapToCancelKeyboard];
    
    self.warningView.alpha = 0.0f;
    
    self.view.backgroundColor = bgColor;
    self.navigationItem.title = @"绑定支付宝";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.nameTextField.delegate = self;
    self.personIDCardTextField.delegate = self;
    self.personAliPayAccountTextField.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)cancelKeyboard{
    [self.view endEditing:YES];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)finishBtnClick:(UIButton *)sender {
//    [self showWarning:@"请输入正确的用户名"];
//    YT_InvestorGetMoneyController *getMoneyVc = [[YT_InvestorGetMoneyController alloc] init];
//    [self.navigationController pushViewController:getMoneyVc animated:YES];
    if (![self isPersonIDCard]) {
        [self showWarning:@"请输入正确的身份证件号"];
        return;
    }
    [self sendSetAliAccountRequest];
}

- (void)sendSetAliAccountRequest
{
    YT_WS(weakSelf);
    NSDictionary *params = @{@"cardNo":@"0",@"realName":self.nameTextField.text,@"aliAccount":self.personAliPayAccountTextField.text,@"idCard":self.personIDCardTextField.text};
    [YBHttpNetWorkTool post:Url_Set_AliAccount params:params success:^(id json) {
        NSInteger status = [json[@"code"] integerValue];
        YT_LOG(@"提现----%@====%@",json,json[@"msg"]);
        if (status == 1) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDict = json[@"data"];
            YT_InvestorPayModel *model = [YT_InvestorPayModel sharedPayModel];
            [model mj_setKeyValues:dataDict];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }else{
            [SVProgressHUD dismiss];
            [weakSelf showWarning:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    } header:[YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:@"正在提交..."];
}

- (BOOL)isPersonIDCard
{
    if ([YBVerify validateIdentityCard:self.personIDCardTextField.text]) return YES;
    return NO;
}
@end
