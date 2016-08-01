//
//  YT_getMoneyExplainWeb.m
//  interview
//
//  Created by Mickey on 16/5/24.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_getMoneyExplainWeb.h"

@interface YT_getMoneyExplainWeb ()
@property (weak,nonatomic)UIWebView *webV;
@end

@implementation YT_getMoneyExplainWeb

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.navigationItem.title = @"提现明细";//?userId=%@
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    NSString *url = [NSString stringWithFormat:@"%@?userId=%@",Url_getMoneyExplain,self.userID];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    self.webV = web;
    [self.view addSubview:self.webV];
}

@end
