//
//  YT_ForgetPwdSetPwdController.m
//  interview
//
//  Created by 于波 on 16/3/27.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_ForgetPwdSetPwdController.h"
#import "YBVerify.h"

@interface YT_ForgetPwdSetPwdController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *againPwdTextField;
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UILabel *warningLable;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
- (IBAction)finishBtnClick:(UIButton *)sender;

@end

@implementation YT_ForgetPwdSetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"重置密码";
    self.view.backgroundColor = bgColor;
    self.finishBtn.backgroundColor = btnColor;
    self.finishBtn.layer.cornerRadius = 8.0f;
    self.warningView.alpha = 0.0f;
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
    if (![YBVerify checkVerifyPassword:self.pwdTextField.text password:self.againPwdTextField.text]) {
        return NO;
    }
    return YES;
}

- (void)showWarning:(NSString *)warning
{
    self.warningLable.text = warning;
    self.warningView.alpha = 1.0f;
    [UIView animateWithDuration:WarningTime animations:^{
        self.warningView.alpha = 0.0f;
    }];
}

- (IBAction)finishBtnClick:(UIButton *)sender {
    if (self.pwdTextField.text.length == 0 || self.againPwdTextField.text.length == 0) {
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
}

- (void)sendRequest
{
    YT_WS(weakSelf);
    NSDictionary *params = @{@"password":self.pwdTextField.text,@"mobile":self.phoneNum};
    [YBHttpNetWorkTool post:Url_Forget_Pwd params:params success:^(id json) {
        YT_LOG(@"忘记密码:%@",json);
        NSInteger statusCode = [json[@"code"] integerValue];
        if (statusCode == 1) {
            [SVProgressHUD dismiss];
            [weakSelf alert];
        }else{
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSError *error) {
        YT_LOG(@"忘记密码error:%@",error);
    } header:@"" ShowWithStatusText:nil];
}

- (void)alert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"重置密码成功，请重新登录" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
