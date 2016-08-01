//
//  YT_AboutAppWeb.m
//  interview
//
//  Created by Mickey on 16/7/13.
//  Copyright © 2016年 于波. All rights reserved.
//
//typedef void(^myBlock) (BOOL);

#import "YT_AboutAppWeb.h"
#import "UIButton+YBExtension.h"
#import "YT_CommonConstList.h"

@interface YT_AboutAppWeb ()<UIWebViewDelegate>{
    BOOL theBool;
    NSTimer *myTimer;
    UIProgressView *_myProgressView;
}
@property (nonatomic,weak) UIWebView *web;
@property (assign,nonatomic) BOOL isExistDot;
@end

@implementation YT_AboutAppWeb

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.fd_interactivePopDisabled = YES;
    self.navigationItem.title = @"系统通知";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"zuojiantou"];
    
    /*******************仿微信进度条*********************/
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _myProgressView = [[UIProgressView alloc] initWithFrame:barFrame];
    _myProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _myProgressView.progressTintColor = [UIColor colorWithRed:43.0/255.0 green:186.0/255.0  blue:0.0/255.0  alpha:1.0];
    [self.navigationController.navigationBar addSubview:_myProgressView];
    /*******************仿微信进度条*********************/
    
    [self loadUrl];
}

- (void)back
{
//    _isExistDot = NO;
//    if (self.dotBlock) {
//        self.dotBlock(_isExistDot);
//    }
    //发送通知 告诉tabbar“我”的关于约谈的cell 取消红点
    [[NSNotificationCenter defaultCenter] postNotificationName:ReadAppUpDataNews object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadUrl
{
    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:Url_SystemInfo]]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_myProgressView removeFromSuperview];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    _myProgressView.progress = 0;
    theBool = false;
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    theBool = true;
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
}

-(void)timerCallback {
    if (theBool) {
        if (_myProgressView.progress >= 1) {
            _myProgressView.hidden = true;
            [myTimer invalidate];
        }
        else {
            _myProgressView.progress += 0.1;
        }
    }
    else {
        _myProgressView.progress += 0.05;
        if (_myProgressView.progress >= 0.95) {
            _myProgressView.progress = 0.95;
        }
    }
}

- (UIWebView *)web
{
    if (nil == _web) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        webView.scalesPageToFit = YES;
        webView.delegate = self;
        self.web = webView;
        [self.view addSubview:self.web];
    }
    return _web;
}

@end
