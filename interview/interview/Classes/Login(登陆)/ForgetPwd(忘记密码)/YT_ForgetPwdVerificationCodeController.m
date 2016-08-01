//
//  YT_ForgetPwdVerificationCodeController.m
//  interview
//
//  Created by 于波 on 16/3/27.
//  Copyright © 2016年 于波. All rights reserved.
//
#define timeOut 60 //倒计时时间
#import "YT_ForgetPwdVerificationCodeController.h"
#import "YT_ForgetPwdSetPwdController.h"

@interface YT_ForgetPwdVerificationCodeController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
@property (weak, nonatomic) IBOutlet UITextField *verCodeTextField;
- (IBAction)sendVerCodeClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)nextBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendVerCodeBtn;

@end

@implementation YT_ForgetPwdVerificationCodeController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getServercodeTimer];
//    [self sendVerRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.NavTitle = @"忘记密码";
    self.nextBtn.backgroundColor = btnColor;
    self.nextBtn.layer.cornerRadius = 8.0f;
    self.phoneLable.text = self.phone;
}

//发送验证码到手机
- (void)sendVerRequest
{
    NSDictionary *params = @{@"mobile":self.phoneLable.text,
                             @"source":@"1"};
    [YBHttpNetWorkTool post:Url_SendVerificationCode_PhoneExist params:params success:^(id json) {
        YT_LOG(@"忘记密码发送验证码到手机:%@",json);
        NSInteger statusCode = [json[@"code"] integerValue];
        if (statusCode == 1) {
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        YT_LOG(@"error:%@",error);
    } header:@"" ShowWithStatusText:@"请稍等..."];
}

-(void)getServercodeTimer{
    YT_WS(weakSelf);
    __block int timeout = timeOut;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            //            dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.sendVerCodeBtn setTitle:@"重新发送" forState: UIControlStateNormal];
                [weakSelf.sendVerCodeBtn setTitleColor:titleColor forState:UIControlStateNormal];
                [weakSelf.sendVerCodeBtn setEnabled:YES];
                
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新获取", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.sendVerCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [weakSelf.sendVerCodeBtn setTitle:strTime forState:UIControlStateNormal];
                [weakSelf.sendVerCodeBtn setEnabled:NO];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)sendVerCodeClick:(UIButton *)sender {
    [self getServercodeTimer];
    [self sendVerRequest];
}
- (IBAction)nextBtnClick:(UIButton *)sender {
    [self verCode];
}

//校验验证码
- (void)verCode
{
    YT_WS(weakSelf);
    NSDictionary *params = @{@"mobile":self.phoneLable.text,@"code":self.verCodeTextField.text};
    [YBHttpNetWorkTool post:Url_VerificationCode_PhoneExist params:params success:^(id json) {
        YT_LOG(@"忘记密码发送验证码:%@",json);
        NSInteger statusCode = [json[@"code"] integerValue];
        if (statusCode == 1) {
            [SVProgressHUD dismiss];
            YT_ForgetPwdSetPwdController *forgetPwdSetPwd = [[YT_ForgetPwdSetPwdController alloc] init];
            forgetPwdSetPwd.phoneNum = weakSelf.phoneLable.text;
            [weakSelf.navigationController pushViewController:forgetPwdSetPwd animated:YES];
        }else{
            YT_LOG(@"忘记密码发送验证码失败:%@",json[@"msg"]);
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        YT_LOG(@"忘记密码发送验证码error:%@",error);
    } header:@"" ShowWithStatusText:@"正在校验..."];
}
@end
