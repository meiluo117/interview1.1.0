//
//  YT_SetPwdController.m
//  interview
//
//  Created by 于波 on 16/3/22.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_SetPwdController.h"
#import "YT_SetInvestorInfoController.h"
#import "YBVerify.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_InvestorPersonInfoModel.h"
#import "UMessage.h"
#import "YT_OtherUrl.h"

@interface YT_SetPwdController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdAgainTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)nextBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UILabel *warningLable;

@end

@implementation YT_SetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.warningView.alpha = 0.0f;
    self.navigationItem.title = @"设置密码";
    self.view.backgroundColor = bgColor;
    self.nextBtn.backgroundColor = btnColor;
    self.nextBtn.layer.cornerRadius = 8.0f;
    
    UITapGestureRecognizer *tapToCancelKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
    [self.view addGestureRecognizer:tapToCancelKeyboard];
}

-(void)cancelKeyboard{
    [self.view endEditing:YES];
}

- (void)showWarning:(NSString *)warning
{
    self.warningLable.text = warning;
    self.warningView.alpha = 1.0f;
    [UIView animateWithDuration:WarningTime animations:^{
        self.warningView.alpha = 0.0f;
    }];
}

//密码校验
- (BOOL)VerifyPwdNum
{
    if (![YBVerify checkLengthOfPassword:self.pwdTextField.text]) {
        return NO;
    }
    return YES;
}

//两次密码校验
- (BOOL)VerifyPwdAgain
{
    if (![YBVerify checkVerifyPassword:self.pwdTextField.text password:self.pwdAgainTextField.text]) {
        return NO;
    }
    return YES;
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    
    if (self.pwdTextField.text.length == 0 || self.pwdAgainTextField.text.length == 0) {
        [self showWarning:@"请输入正确的密码"];
        return;
    }else if (![self VerifyPwdNum]) {
        [self showWarning:@"密码长度为6-18位"];
        return;
    }else if (![self VerifyPwdAgain]){
        [self showWarning:@"两次密码不一致"];
        return;
    }
    [self sendRequest];
    
    
//    YT_SetInvestorInfoController *setInvestorInfoVc = [[YT_SetInvestorInfoController alloc] init];
//    [self.navigationController pushViewController:setInvestorInfoVc animated:YES];
    
//    YT_SetCreateInfoController *setCreateInfoVc = [[YT_SetCreateInfoController alloc] init];
//    [self.navigationController pushViewController:setCreateInfoVc animated:YES];
}

- (void)sendRequest
{
    YT_WS(weakSelf);
    NSString *type;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"ID"] isEqualToString:@"chuangye"]) {
        type = @"2";//创业者
    }else{
        type = @"1";//投资者
    }
    NSDictionary *params = @{@"username":self.phone,
                             @"type":type,
                             @"password":self.pwdTextField.text,
                             @"source":@"1"};
    
    [YBHttpNetWorkTool post:Url_Register params:params success:^(id json) {
        YT_LOG(@"setpwd:%@",json);
        NSInteger statusCode = [json[@"code"] integerValue];
        if (statusCode == 1) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDict = json[@"data"];
            
            [weakSelf registerUMengAliasWithUserId:dataDict[@"userId"]];
            
            if ([type isEqualToString:@"2"]) {//创业者
                [YT_CreatePersonInfoModel sharedPersonInfoModel].mobile = weakSelf.phone;
                [YT_CreatePersonInfoModel sharedPersonInfoModel].ticket = dataDict[@"ticket"];
                [YT_CreatePersonInfoModel sharedPersonInfoModel].projectId = dataDict[@"projectId"];
                
                YT_SetCreateInfoController *setCreateInfoVc = [[YT_SetCreateInfoController alloc] init];
                setCreateInfoVc.navTitleString = @"完善个人信息";
                setCreateInfoVc.isExistBtn = YES;
                [weakSelf.navigationController pushViewController:setCreateInfoVc animated:YES];
                
            }else if ([type isEqualToString:@"1"]){//投资者
                [YT_InvestorPersonInfoModel sharedPersonInfoModel].mobile = weakSelf.phone;
                [YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket = dataDict[@"ticket"];
//                [YT_InvestorPersonModel sharedModel].type = dataDict[@"type"];
                
                YT_SetInvestorInfoController *setInvestorInfoVc = [[YT_SetInvestorInfoController alloc] init];
                [weakSelf.navigationController pushViewController:setInvestorInfoVc animated:YES];
            }
        }else{
            [SVProgressHUD dismiss];
            [weakSelf showWarning:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        YT_LOG(@"error:%@",error);
    } header:@"" ShowWithStatusText:@"请稍等..."];
}

- (void)registerUMengAliasWithUserId:(NSString *)userId
{
    [UMessage addAlias:userId type:PushAlias response:^(id responseObject, NSError *error) {
        YT_LOG(@"addAlias_responseObject---%@",responseObject);
    }];
}
@end
