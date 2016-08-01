//
//  YT_ItemExplainController.m
//  interview
//
//  Created by 于波 on 16/3/24.
//  Copyright © 2016年 于波. All rights reserved.
//

#define Explain @"如：我们的项目是一个怎样的产品，帮助哪些人，解决什么问题。"
#define LimitMaxWord 100

#import "YT_ItemExplainController.h"
#import "YT_CreateItemsInfoModel.h"
#import "YT_CreatePersonInfoModel.h"

@interface YT_ItemExplainController ()<UITextViewDelegate>
@property (nonatomic,weak)UITextView *explainTextView;
@property (nonatomic,weak)UILabel *wordLable;
@end

@implementation YT_ItemExplainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    self.NavTitle = @"项目简介";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    
    [self createUI];
}

- (void)createUI
{
    UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];
    textV.font = [UIFont systemFontOfSize:14];
    textV.textColor = [UIColor blackColor];
    textV.backgroundColor = [UIColor whiteColor];
    textV.delegate = self;
    textV.scrollEnabled = NO;
    textV.alwaysBounceVertical = NO;
    self.explainTextView = textV;
    [self.view addSubview:self.explainTextView];
    self.explainTextView.text = [YT_CreatePersonInfoModel sharedPersonInfoModel].introduce;
    
    UILabel *wordLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 50, CGRectGetMaxY(self.explainTextView.frame) - 20, 100, 20)];
    wordLable.font = [UIFont systemFontOfSize:12];
    wordLable.textColor = [UIColor blackColor];
    
    if (self.explainTextView.text.length == 0) {
        wordLable.text = [NSString stringWithFormat:@"0/%d",LimitMaxWord];
    }else{
        wordLable.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)self.explainTextView.text.length,LimitMaxWord];
    }
    
    self.wordLable = wordLable;
    [self.view addSubview:self.wordLable];
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
    if (self.explainTextView.text.length == 0) {
        self.explainTextView.text = @"";
    }
    
    NSDictionary *params = @{@"type":@"5",
                             @"value":self.explainTextView.text,
                             @"projectId":[YT_CreatePersonInfoModel sharedPersonInfoModel].projectId};
    
    [YBHttpNetWorkTool post:Url_ItemProduct_Info params:params success:^(id json) {
        
        NSInteger statusCode = [json[@"code"] integerValue];
        if (statusCode == 1) {
            [SVProgressHUD dismiss];
            [YT_CreatePersonInfoModel sharedPersonInfoModel].introduce = weakSelf.explainTextView.text;
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }else{
            [SVProgressHUD dismiss];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:nil];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
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
    //该判断用于联想输入
    if (textView.text.length > LimitMaxWord)
    {
        textView.text = [textView.text substringToIndex:LimitMaxWord];
    }
    
    self.wordLable.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)[textView.text length], LimitMaxWord];
}




@end
