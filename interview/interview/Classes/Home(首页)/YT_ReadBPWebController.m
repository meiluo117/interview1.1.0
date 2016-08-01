//
//  YT_ReadBPWebController.m
//  interview
//
//  Created by Mickey on 16/5/20.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_ReadBPWebController.h"

@interface YT_ReadBPWebController ()<UIWebViewDelegate>
@property (nonatomic,weak) UIWebView *readBpWeb;
@end

@implementation YT_ReadBPWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.NavTitle = @"阅读BP";
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    web.delegate = self;
    NSString *url = self.bpUrl;
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    self.readBpWeb = web;
    self.readBpWeb.scalesPageToFit = YES;
    [self.view addSubview:self.readBpWeb];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
//    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=0.5"];
}

@end
