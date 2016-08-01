//
//  YT_salesController.m
//  interview
//
//  Created by Mickey on 16/5/11.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_salesController.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_CommonConstList.h"

@interface YT_salesController ()
@property (weak, nonatomic) IBOutlet UITextField *salesTextField;
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UILabel *warningLable;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureBtnClick:(UIButton *)sender;

@end

@implementation YT_salesController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)createUI
{
    self.NavTitle = @"优惠码";
    //点击消除键盘
    UITapGestureRecognizer *tapToCancelKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
    [self.view addGestureRecognizer:tapToCancelKeyboard];
    
    self.warningView.alpha = 0.0f;
    self.sureBtn.layer.cornerRadius = 8.0f;
    self.sureBtn.backgroundColor = btnColor;
}

//消除键盘
-(void)cancelKeyboard{
    [self.view endEditing:YES];
}

- (void)showWarning:(NSString *)warningStr
{
    self.warningLable.text = warningStr;
    self.warningView.alpha = 1.0f;
    [UIView animateWithDuration:WarningTime animations:^{
        self.warningView.alpha = 0.0f;
    }];
}

- (BOOL)salesCode
{
    if (self.salesTextField.text.length == 0) {
        [self showWarning:@"优惠码不能为空"];
        return NO;
    }
    return YES;
}

- (IBAction)sureBtnClick:(UIButton *)sender {
    
    if (![self salesCode]) return;
    
    [self sendSalesCodeRequest];
}

- (void)sendSalesCodeRequest
{
    YT_WS(weakSelf);
    NSDictionary *params = @{@"code":self.salesTextField.text,
                             @"orderId":self.orderId};
    
    [YBHttpNetWorkTool post:Url_Date_salesCode params:params success:^(id json) {
        
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            [weakSelf sendNotification];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD dismiss];
            [weakSelf showWarning:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:@"正在提交信息..."];
}

- (void)sendNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SALE_RefreshTable object:nil];
}
@end
