//
//  YT_PhoneVerificationCodeController.m
//  interview
//
//  Created by 于波 on 16/3/22.
//  Copyright © 2016年 于波. All rights reserved.
//
#define timeOut 60 //倒计时时间
#import "YT_PhoneVerificationCodeController.h"
#import "YT_SetPwdController.h"
#import "YBVerify.h"
#import "UIBarButtonItem+YBExtension.h"

@interface YT_PhoneVerificationCodeController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
@property (weak, nonatomic) IBOutlet UITextField *verCodeTextFiled;
- (IBAction)sendVerCodeBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendVerCodeBtn;
- (IBAction)nextBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation YT_PhoneVerificationCodeController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getServercodeTimer];
}

- (void)alert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"验证码短信可能稍有延迟,确定返回并重新注册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"返回", nil];
    [alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.navigationItem.title = @"手机注册";
    self.view.backgroundColor = bgColor;
    self.nextBtn.backgroundColor = btnColor;
    self.nextBtn.layer.cornerRadius = 10.0f;
    self.phoneLable.text = self.phoneNumber;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(backVc) image:@"zuojiantou"];
}

- (void)backVc
{
    [self alert];
}

//验证码校验
- (BOOL)verifyCode {
    //检验验证码是否合法
    if([YBVerify checkVerificationCodeLength:self.verCodeTextFiled.text]) return YES;
    
    return NO;
}
//发送验证码到手机
- (void)sendVerRequest
{
    NSDictionary *params = @{@"mobile":self.phoneLable.text,
                             @"source":@"1"};
    [YBHttpNetWorkTool post:Url_SendVerificationCode_NOTVerificationPhoneExist params:params success:^(id json) {
        YT_LOG(@"发送验证码到手机:%@",json);
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

- (IBAction)sendVerCodeBtnClick:(UIButton *)sender {
    [self getServercodeTimer];
    [self sendVerRequest];
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    if(![self verifyCode]) return;
    [self sendVerCode];
//    YT_SetPwdController *setPwdVc = [[YT_SetPwdController alloc] init];
//    setPwdVc.phone = self.phoneNumber;
//    [self.navigationController pushViewController:setPwdVc animated:YES];
}

//校验验证码
- (void)sendVerCode
{
    YT_WS(weakSelf);
    NSDictionary *params = @{@"mobile":self.phoneLable.text,@"code":self.verCodeTextFiled.text};
    
    [YBHttpNetWorkTool post:Url_VerificationCode_NOTVerificationPhoneExist params:params success:^(id json) {
        YT_LOG(@"json:%@",json);
        NSInteger statusCode = [json[@"code"] integerValue];
        if (statusCode == 1) {
            [SVProgressHUD dismiss];
            YT_SetPwdController *setPwdVc = [[YT_SetPwdController alloc] init];
            setPwdVc.phone = weakSelf.phoneNumber;
            [weakSelf.navigationController pushViewController:setPwdVc animated:YES];
        }else{
            YT_LOG(@"%@",json[@"msg"]);
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        YT_LOG(@"error:%@",error);
    } header:@"" ShowWithStatusText:@"正在校验..."];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
