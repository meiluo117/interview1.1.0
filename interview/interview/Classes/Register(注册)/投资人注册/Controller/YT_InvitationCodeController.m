//
//  YT_InvitationCodeController.m
//  interview
//
//  Created by 于波 on 16/3/24.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_InvitationCodeController.h"
#import "YT_PhoneRegisterController.h"

@interface YT_InvitationCodeController ()
@property (weak, nonatomic) IBOutlet UITextField *invitationCodeLable;
@property (weak, nonatomic) IBOutlet UILabel *warningLable;
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureBtnClick:(UIButton *)sender;

@end

@implementation YT_InvitationCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.NavTitle = @"输入邀请码";
    self.sureBtn.backgroundColor = btnColor;
    self.warningView.alpha = 0;
    self.sureBtn.layer.cornerRadius = 8.0f;
}

- (IBAction)sureBtnClick:(UIButton *)sender {
    YT_WS(weakSelf);
    NSDictionary *params = @{@"code":self.invitationCodeLable.text};
    [YBHttpNetWorkTool post:Url_InviteCode params:params success:^(id json) {
        NSInteger statusCode = [json[@"code"] integerValue];
        if (statusCode == 1) {
            [SVProgressHUD dismiss];
            YT_PhoneRegisterController *phoneRegisterVc = [[YT_PhoneRegisterController alloc] init];
            [weakSelf.navigationController pushViewController:phoneRegisterVc animated:YES];
        }else{
            [SVProgressHUD dismiss];
            [weakSelf showWarning:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [weakSelf showWarning:@"请求超时"];
    } header:@"" ShowWithStatusText:nil];

}

- (void)showWarning:(NSString *)warningStr
{
    self.warningLable.text = warningStr;
    self.warningView.alpha = 1.0f;
    [UIView animateWithDuration:WarningTime animations:^{
        self.warningView.alpha = 0.0f;
    }];
}
@end
