//
//  YT_OpinionController.m
//  interview
//
//  Created by Mickey on 16/7/21.
//  Copyright © 2016年 于波. All rights reserved.
//
#define LimitMaxWord 200 //限制字数

#import "YT_OpinionController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "YT_CommonConstList.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_InvestorPersonInfoModel.h"

@interface YT_OpinionController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *opinionTextView;
- (IBAction)submitBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *limitWordLable;
@property (weak,nonatomic) UILabel *placeHolderLabel;

@end

@implementation YT_OpinionController

- (UILabel *)placeHolderLabel
{
    if (_placeHolderLabel == nil) {
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"请输入您遇到的困难或建议";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        placeHolderLabel.font = [UIFont systemFontOfSize:15];
        [placeHolderLabel sizeToFit];
        self.placeHolderLabel = placeHolderLabel;
        [self.opinionTextView addSubview:self.placeHolderLabel];
    }
    return _placeHolderLabel;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [YBHttpNetWorkTool cancelOperation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;//取消滑动返回
    self.navigationItem.title = @"意见反馈";
    
    //点击消除键盘
    UITapGestureRecognizer *tapToCancelKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
    [self.view addGestureRecognizer:tapToCancelKeyboard];
    
    self.submitBtn.enabled = NO;
    
    [self setupTextView];
}

-(void)cancelKeyboard{
    [self.view endEditing:YES];
}

- (void)setupTextView
{
    //_placeholderLabel为textview私有属性，通过KVC赋值
    [self.opinionTextView setValue:self.placeHolderLabel forKey:@"_placeholderLabel"];
    
    self.opinionTextView.returnKeyType = UIReturnKeyDone;
    self.opinionTextView.delegate = self;
    self.opinionTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);//textview内边距
    self.opinionTextView.font = [UIFont systemFontOfSize:15];
    
    self.limitWordLable.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)self.opinionTextView.text.length,LimitMaxWord];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [self.opinionTextView endEditing:YES];
        return NO;
    }
    //判断加上输入的字符，是否超过界限
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (str.length > LimitMaxWord)
    {
        textView.text = [textView.text substringToIndex:LimitMaxWord];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.submitBtn.enabled = NO;
    }else{
        self.submitBtn.enabled = YES;
    }
    //该判断用于联想输入
    if (textView.text.length > LimitMaxWord)
    {
        textView.text = [textView.text substringToIndex:LimitMaxWord];
    }
    
    self.limitWordLable.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)[textView.text length], LimitMaxWord];
}

- (IBAction)submitBtnClick:(UIButton *)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [[userDefaults objectForKey:USER_ID] isEqualToString:@"touzi"] ? [self sendSubmitContentRequestWithUserToken:[YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket] : [self sendSubmitContentRequestWithUserToken:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket];
}

- (void)sendSubmitContentRequestWithUserToken:(NSString *)token
{
    YT_WS(weakSelf);
    
    NSDictionary *params = @{@"content":self.opinionTextView.text};
    
    [YBHttpNetWorkTool post:Url_Opinion params:params success:^(id json) {
        YT_LOG(@"order:%@",json);
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD showSuccessWithStatus:json[@"msg"]];
        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    } header:token ShowWithStatusText:@"正在提交..."];
}
@end
