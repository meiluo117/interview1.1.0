//
//  YT_SetPriceController.m
//  interview
//
//  Created by 于波 on 16/3/23.
//  Copyright © 2016年 于波. All rights reserved.
//
#define LimitPriceWords 5
#define LimitHourWords 2
#import "YT_SetPriceController.h"
#import "YT_InvestorPersonInfoModel.h"
#import "YT_CommonConstList.h"

@interface YT_SetPriceController ()
@property (weak, nonatomic) IBOutlet UITextField *priceLable;
@property (weak, nonatomic) IBOutlet UITextField *hourLable;

@end

@implementation YT_SetPriceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    self.NavTitle = @"约谈价格";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    self.priceLable.text = [YT_InvestorPersonInfoModel sharedPersonInfoModel].price;
    self.hourLable.text = [YT_InvestorPersonInfoModel sharedPersonInfoModel].hours;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledPriceEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.priceLable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledHourEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.hourLable];
}

- (void)textFiledPriceEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= LimitPriceWords) {
                textField.text = [toBeString substringToIndex:LimitPriceWords];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= LimitPriceWords) {
            textField.text = [toBeString substringToIndex:LimitPriceWords];
        }
    }
}

- (void)textFiledHourEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= LimitHourWords) {
                textField.text = [toBeString substringToIndex:LimitHourWords];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }   // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= LimitHourWords) {
            textField.text = [toBeString substringToIndex:LimitHourWords];
        }
    }
}

- (BOOL)priceAndHourIsExist
{
    if (self.priceLable.text.length == 0 || self.hourLable.text.length == 0) {
        [self showAlert];
        return NO;
    }
    return YES;
}

- (void)showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请填写约谈价格或时间" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)save
{
    if ([self priceAndHourIsExist]) {
        [self sendRequest];
    }
}

- (void)sendRequest
{
    YT_WS(weakSelf);
    NSDictionary *params = @{@"price":self.priceLable.text,@"hours":self.hourLable.text};
    [YBHttpNetWorkTool post:Url_Set_Price params:params success:^(id json) {
        
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            [YT_InvestorPersonInfoModel sharedPersonInfoModel].price = weakSelf.priceLable.text;
            [YT_InvestorPersonInfoModel sharedPersonInfoModel].hours = weakSelf.hourLable.text;
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            //设置价格成功后，发送通知，刷新首页tabbar和投资人tabbar列表
            [[NSNotificationCenter defaultCenter] postNotificationName:PriceChange object:nil];
            
        }else{
            [SVProgressHUD dismiss];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } header:[YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:nil];
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
