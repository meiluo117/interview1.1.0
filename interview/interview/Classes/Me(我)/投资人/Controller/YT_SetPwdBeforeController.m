//
//  YT_SetPwdBeforeController.m
//  interview
//
//  Created by 于波 on 16/4/12.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_SetPwdBeforeController.h"
#import "YBVerify.h"
#import "YT_InvestorPersonInfoModel.h"
#import "YT_CreatePersonInfoModel.h"

@interface YT_SetPwdBeforeController ()
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UILabel *warningLable;
@property (weak, nonatomic) IBOutlet UITextField *pwdBeforeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdNewTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdNewAgainTextField;

@end

@implementation YT_SetPwdBeforeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.warningView.alpha = 0.0f;
    self.NavTitle = @"修改密码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    UITapGestureRecognizer *tapToCancelKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
    [self.view addGestureRecognizer:tapToCancelKeyboard];
}

-(void)cancelKeyboard{
    [self.view endEditing:YES];
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save
{
    if (self.pwdBeforeTextField.text.length == 0 || self.pwdNewTextField.text.length == 0) {
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
    NSDictionary *params = @{@"password":self.pwdBeforeTextField.text,@"newPwd":self.pwdNewTextField.text};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ticket = nil;
    if ([[defaults objectForKey:@"ID"] isEqualToString:@"touzi"]) {
        ticket = [YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket;
    }else{
        ticket = [YT_CreatePersonInfoModel sharedPersonInfoModel].ticket;
    }
    [YBHttpNetWorkTool post:Url_Set_ResetNewPwd params:params success:^(id json) {
        NSInteger status = [json[@"code"] integerValue];
        
        if (status == 1) {
            [SVProgressHUD showSuccessWithStatus:json[@"msg"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    } header:ticket ShowWithStatusText:@"正在提交..."];
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
    if (![YBVerify checkLengthOfPassword:self.pwdNewTextField.text] || ![YBVerify checkLengthOfPassword:self.pwdBeforeTextField.text]) {
        
        return NO;
    }
    return YES;
}

//两次密码校验
- (BOOL)VerifyPwdAgain
{
    if (![YBVerify checkVerifyPassword:self.pwdNewTextField.text password:self.pwdNewAgainTextField.text]) {
        return NO;
    }
    return YES;
}
@end
