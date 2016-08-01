//
//  YT_SetNameController.m
//  interview
//
//  Created by 于波 on 16/3/23.
//  Copyright © 2016年 于波. All rights reserved.
//
#define LimitNameWords 7
#import "YT_SetNameController.h"
#import "YT_InvestorPersonInfoModel.h"
#import "YT_CreatePersonInfoModel.h"

@interface YT_SetNameController ()<UITextFieldDelegate>

@end

@implementation YT_SetNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    self.NavTitle = @"真实姓名";
    [self showInfoTextFieldPlaceholder:@"请输入姓名"];
    self.infoTextField.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"ID"] isEqualToString:@"touzi"]) {
        [self showLableStr:@"请如实填写您的真实姓名，以便创业团队搜到您" andLableHidden:NO];
        self.infoTextField.text = [YT_InvestorPersonInfoModel sharedPersonInfoModel].realName;
    }else{
        [self showLableStr:@"真实姓名是您与投资人建立信任的基础，请如实填写" andLableHidden:NO];
        self.infoTextField.text = [YT_CreatePersonInfoModel sharedPersonInfoModel].realName;
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    
    //通知监听textfield输入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.infoTextField];

}

- (void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= LimitNameWords) {
                textField.text = [toBeString substringToIndex:LimitNameWords];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= LimitNameWords) {
            textField.text = [toBeString substringToIndex:LimitNameWords];
        }
    }
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(UIButton *)btn
{
    [self sendRequest];
}

- (void)sendRequest
{
    YT_WS(weakSelf);
    NSString *ticket;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"ID"] isEqualToString:@"touzi"]) {
        ticket = [YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket;
    }else{
        ticket = [YT_CreatePersonInfoModel sharedPersonInfoModel].ticket;
    }
    
    NSDictionary *params = @{@"type":@"1",@"value":self.infoTextField.text};
    [YBHttpNetWorkTool post:Url_Set_RealName params:params success:^(id json) {
        YT_LOG(@"setnamejson:%@",json);
        NSInteger statusCode = [json[@"code"] integerValue];
        if (statusCode == 1) {
            [SVProgressHUD dismiss];
            if ([[defaults objectForKey:@"ID"] isEqualToString:@"touzi"]) {
                [YT_InvestorPersonInfoModel sharedPersonInfoModel].realName = weakSelf.infoTextField.text;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [YT_CreatePersonInfoModel sharedPersonInfoModel].realName = weakSelf.infoTextField.text;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [SVProgressHUD dismiss];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        YT_LOG(@"setNameError:%@",error);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } header:ticket ShowWithStatusText:nil];
}

@end
