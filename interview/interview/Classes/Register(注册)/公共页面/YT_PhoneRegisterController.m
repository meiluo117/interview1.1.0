//
//  YT_PhoneRegisterController.m
//  interview
//
//  Created by 于波 on 16/3/21.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_PhoneRegisterController.h"
#import "YT_PhoneVerificationCodeController.h"
#import "YBVerify.h"
#import "YT_serviceWebController.h"

@interface YT_PhoneRegisterController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *warningLable;
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)nextBtnClick:(UIButton *)sender;
- (IBAction)sureBtnClick:(UIButton *)sender;
- (IBAction)serviceBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *smallBgView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation YT_PhoneRegisterController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.sureBtn.selected = YES;
    self.warningView.alpha = 0.0;
}

- (void)createUI
{
    self.view.backgroundColor = bgColor;
    self.smallBgView.backgroundColor = bgColor;
    self.navigationItem.title = @"手机注册";
    self.nextBtn.backgroundColor = btnColor;
    self.nextBtn.layer.cornerRadius = 8.0f;
    [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"duigoulvse"] forState:UIControlStateSelected];
    [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"duigouhuise"] forState:UIControlStateNormal];
    
    //点击消除键盘
    UITapGestureRecognizer *tapToCancelKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
    [self.view addGestureRecognizer:tapToCancelKeyboard];
    
    self.phoneTextField.delegate = self;
    self.phoneTextField.tag = 10000;
}
//消除键盘
-(void)cancelKeyboard{
    [self.view endEditing:YES];
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//限制手机号码11位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@""]) return YES;
    
    if (textField.tag == 10000 && textField.text.length >= 11) {
        return NO;
    }else{
        return YES;
    }
}

//手机号校验
- (BOOL)verifyTextField{
    //检验手机号是否为空
    if([YBVerify isPobileNumEmpty:self.phoneTextField.text]) return NO;
    //检验手机号是否合法
    if(![YBVerify isPhoneNumAvailability:self.phoneTextField.text]) return NO;
    
    return YES;
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    if(![self verifyTextField]){
        [self showWarning:@"请输入正确的手机号"];
        return;
    }

    if (!self.sureBtn.selected) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"请勾选《约谈服务条款》" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVc animated:YES completion:nil];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            return ;
        }];
        [alertVc addAction:alertAction];
        
    }else{
        self.nextBtn.enabled = NO;
        [self sendVerRequest];
//        YT_PhoneVerificationCodeController *verCodeVc = [[YT_PhoneVerificationCodeController alloc] init];
//        verCodeVc.phoneNumber = self.phoneTextField.text;
//        [self.navigationController pushViewController:verCodeVc animated:YES];
    }
}

- (void)showWarning:(NSString *)warning
{
    self.warningLable.text = warning;
    self.warningView.alpha = 1.0f;
    [UIView animateWithDuration:WarningTime animations:^{
        self.warningView.alpha = 0.0f;
    }];
}

- (IBAction)sureBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)serviceBtnClick:(UIButton *)sender {
    YT_serviceWebController *serviceVc = [[YT_serviceWebController alloc] init];
    serviceVc.navTitle = @"约谈服务条款";
    serviceVc.url = Url_Terms_of_Service;
    [self.navigationController pushViewController:serviceVc animated:YES];
}

//发送验证码到手机
- (void)sendVerRequest
{
    YT_WS(weakSelf);
    NSDictionary *params = @{@"mobile":self.phoneTextField.text,
                             @"source":@"1"};
    
    [YBHttpNetWorkTool post:Url_SendVerificationCode_NOTVerificationPhoneExist params:params success:^(id json) {
        YT_LOG(@"注册发送验证码到手机:%@",json);
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            self.nextBtn.enabled = YES;
            YT_PhoneVerificationCodeController *verCodeVc = [[YT_PhoneVerificationCodeController alloc] init];
            verCodeVc.phoneNumber = weakSelf.phoneTextField.text;
            [weakSelf.navigationController pushViewController:verCodeVc animated:YES];
        }else{
            [SVProgressHUD dismiss];
            self.nextBtn.enabled = YES;
            [weakSelf showWarning:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        self.nextBtn.enabled = YES;
        YT_LOG(@"注册发送验证码到手机error:%@",error);
    } header:@"" ShowWithStatusText:@"请稍等..."];
}
@end
