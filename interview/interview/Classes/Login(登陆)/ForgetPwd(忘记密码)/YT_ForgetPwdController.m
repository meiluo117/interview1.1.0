//
//  YT_ForgetPwdController.m
//  interview
//
//  Created by 于波 on 16/3/27.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_ForgetPwdController.h"
#import "YT_ForgetPwdVerificationCodeController.h"
#import "YBVerify.h"

@interface YT_ForgetPwdController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *forgetPhoneTextField;
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UILabel *warningLable;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)nextBtnClick:(UIButton *)sender;

@end

@implementation YT_ForgetPwdController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.NavTitle = @"忘记密码";
    self.nextBtn.backgroundColor = btnColor;
    self.nextBtn.layer.cornerRadius = 8.0f;
    self.warningView.alpha = 0.0;
    
    //点击消除键盘
    UITapGestureRecognizer *tapToCancelKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
    [self.view addGestureRecognizer:tapToCancelKeyboard];
    
    self.forgetPhoneTextField.delegate = self;
    self.forgetPhoneTextField.tag = 10000;
}

//手机号校验
- (BOOL)verifyTextField{
    //检验手机号是否为空
    if([YBVerify isPobileNumEmpty:self.forgetPhoneTextField.text]) return NO;
    //检验手机号是否合法
    if(![YBVerify isPhoneNumAvailability:self.forgetPhoneTextField.text]) return NO;
    
    return YES;
}

//消除键盘
-(void)cancelKeyboard{
    [self.view endEditing:YES];
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    if(![self verifyTextField]){
        [self showWarning:@"请输入正确的手机号"];
        return;
    }
    
    [self sendRequest];
}

//发送验证码
- (void)sendRequest
{
    YT_WS(weakSelf);
    NSDictionary *params = @{@"mobile":self.forgetPhoneTextField.text,@"source":@"1"};
    [YBHttpNetWorkTool post:Url_SendVerificationCode_PhoneExist params:params success:^(id json) {
        
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            YT_ForgetPwdVerificationCodeController *forgetPwdVerificationCodeVc = [[YT_ForgetPwdVerificationCodeController alloc] init];
            forgetPwdVerificationCodeVc.phone = weakSelf.forgetPhoneTextField.text;
            [weakSelf.navigationController pushViewController:forgetPwdVerificationCodeVc animated:YES];
            
        }else{
            [SVProgressHUD dismiss];
            YT_LOG(@"检测手机号是否注册失败:%@",json[@"msg"]);
            [weakSelf showWarning:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        YT_LOG(@"检测手机号是否注册error:%@",error);
    } header:@"" ShowWithStatusText:@"请稍等..."];
}

- (void)showWarning:(NSString *)warning
{
    self.warningLable.text = warning;
    self.warningView.alpha = 1.0f;
    [UIView animateWithDuration:WarningTime animations:^{
        self.warningView.alpha = 0.0f;
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@""]) return YES;
    
    if (textField.tag == 10000 && textField.text.length >= 11) {
        return NO;
    }else{
        return YES;
    }
}
@end
