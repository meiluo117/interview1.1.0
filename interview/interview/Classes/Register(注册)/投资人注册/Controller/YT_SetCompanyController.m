//
//  YT_SetCompanyController.m
//  interview
//
//  Created by 于波 on 16/3/25.
//  Copyright © 2016年 于波. All rights reserved.
//
#define LimitCompanyWords 20
#import "YT_SetCompanyController.h"
#import "YT_InvestorPersonInfoModel.h"

@interface YT_SetCompanyController ()

@end

@implementation YT_SetCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    self.NavTitle = @"公司";
    [self showLableStr:@" " andLableHidden:YES];
    [self showInfoTextFieldPlaceholder:@"公司名称"];
    
    self.infoTextField.text = [YT_InvestorPersonInfoModel sharedPersonInfoModel].company;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    
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
            if (toBeString.length >= LimitCompanyWords) {
                textField.text = [toBeString substringToIndex:LimitCompanyWords];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= LimitCompanyWords) {
            textField.text = [toBeString substringToIndex:LimitCompanyWords];
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
    NSString *ticket = [YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket;
    
    NSDictionary *params = @{@"type":@"5",@"value":self.infoTextField.text};
    [YBHttpNetWorkTool post:Url_Set_Company params:params success:^(id json) {
        YT_LOG(@"setnamejson:%@",json);
        NSInteger statusCode = [json[@"code"] integerValue];
        if (statusCode == 1) {
            [SVProgressHUD dismiss];
            [YT_InvestorPersonInfoModel sharedPersonInfoModel].company = weakSelf.infoTextField.text;
            [weakSelf.navigationController popViewControllerAnimated:YES];
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
