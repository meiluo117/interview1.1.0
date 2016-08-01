//
//  YT_ItemNameController.m
//  interview
//
//  Created by 于波 on 16/3/24.
//  Copyright © 2016年 于波. All rights reserved.
//
#define LimitItemNameWords 10
#import "YT_ItemNameController.h"
#import "YT_CreateItemsInfoModel.h"
#import "YT_CreatePersonInfoModel.h"

@interface YT_ItemNameController ()

@end

@implementation YT_ItemNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    self.NavTitle = @"项目名称";
    [self showLableStr:@" " andLableHidden:YES];
    [self showInfoTextFieldPlaceholder:@"请输入项目名称"];
    
    self.infoTextField.text = [YT_CreatePersonInfoModel sharedPersonInfoModel].name;
    
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
            if (toBeString.length >= LimitItemNameWords) {
                textField.text = [toBeString substringToIndex:LimitItemNameWords];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= LimitItemNameWords) {
            textField.text = [toBeString substringToIndex:LimitItemNameWords];
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
    NSDictionary *params = @{@"type":@"1",
                             @"value":self.infoTextField.text,
                             @"projectId":[YT_CreatePersonInfoModel sharedPersonInfoModel].projectId};
    
    [YBHttpNetWorkTool post:Url_ItemProduct_Info params:params success:^(id json) {
        
        NSInteger statusCode = [json[@"code"] integerValue];
        if (statusCode == 1) {
            [SVProgressHUD dismiss];
            [YT_CreatePersonInfoModel sharedPersonInfoModel].name = weakSelf.infoTextField.text;
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }else{
            [SVProgressHUD dismiss];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:nil];
}



@end
