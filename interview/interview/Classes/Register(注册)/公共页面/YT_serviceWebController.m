//
//  YT_serviceWebController.m
//  interview
//
//  Created by Mickey on 16/5/31.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_serviceWebController.h"

@interface YT_serviceWebController ()
@property (weak,nonatomic) UIWebView *web;
@end

@implementation YT_serviceWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.navigationItem.title = self.navTitle;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    self.web.scalesPageToFit = YES;
    self.web = webView;
    [self.view addSubview:self.web];
    
}

@end
