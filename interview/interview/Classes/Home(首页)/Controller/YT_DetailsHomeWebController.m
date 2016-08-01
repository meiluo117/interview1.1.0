//
//  YT_DetailsHomeWebController.m
//  interview
//
//  Created by Mickey on 16/5/6.
//  Copyright © 2016年 于波. All rights reserved.
//
#define HTML_InvestorDetail @"http://www.talk2vc.com/wap/investor?userId=%@&source=1"
#define WARNING @"您与该投资人有尚未完成的订单，请完成后再约吧~"

#import "YT_DetailsHomeWebController.h"
#import "YT_dateTimeAndPlaceController.h"
#import "YT_dateInfoController.h"
#import "HYActivityView.h"
#import <UMSocial.h>
#import "YT_OtherUrl.h"
#import "YT_ItemModel.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_CommonConstList.h"
#import "YT_dateUrl.h"
#import <WebKit/WebKit.h>

@interface YT_DetailsHomeWebController ()<UIWebViewDelegate>{//WKNavigationDelegate
    BOOL theBool;
    NSTimer *myTimer;
    UIProgressView *_myProgressView;
}
//@property (weak,nonatomic) UIWebView *detailsHomeWebView;
@property (weak,nonatomic) UIWebView *detailsHomeWebView;
//@property (weak,nonatomic) WKWebView *detailsHomeWebView;
@property (nonatomic, strong) HYActivityView *activityView;
@end

@implementation YT_DetailsHomeWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_myProgressView removeFromSuperview];
}

- (void)createUI
{
    self.navigationItem.title = @"投资人";
    self.view.backgroundColor = YT_Color(244, 244, 244, 1);
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(shared) image:@"share2"];
    
    /*******************仿微信进度条*********************/
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _myProgressView = [[UIProgressView alloc] initWithFrame:barFrame];
    _myProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _myProgressView.progressTintColor = [UIColor colorWithRed:43.0/255.0 green:186.0/255.0  blue:0.0/255.0  alpha:1.0];
    [self.navigationController.navigationBar addSubview:_myProgressView];
     /*******************仿微信进度条*********************/
    
    UIWebView *webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49)];
    webV.scalesPageToFit = YES;
    webV.scrollView.bounces = NO;
    webV.delegate = self;
    self.detailsHomeWebView = webV;
    [self.view addSubview:self.detailsHomeWebView];
    
    UIButton *dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dateBtn.frame = CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49);
    [dateBtn setTitle:@"立即付费约TA" forState:UIControlStateNormal];
    [dateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dateBtn.backgroundColor = btnColor;
    [dateBtn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dateBtn];
    
    // 请求网络
    [self reRequesrtUrl];
    
//    if (self.isExistDateBtn) {
//        dateBtn.hidden = YES;
//        webV.height = ScreenHeight;
//    }
    
    //投资人身份 隐藏约见按钮
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:USER_ID] isEqualToString:@"touzi"] || self.isExistDateBtn) {
        dateBtn.hidden = YES;
        webV.height = ScreenHeight;
    }
}

- (void)reRequesrtUrl
{
    NSString *url = [NSString stringWithFormat:HTML_InvestorDetail,self.model.userId];
    [self.detailsHomeWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];

}

- (void)sendDataIsFinishRequest
{
    YT_WS(weakSelf);
    NSDictionary *params = @{@"userId":self.userID};
    
    [YBHttpNetWorkTool post:Url_Date_OrderIsFinish params:params success:^(id json) {
        YT_LOG(@"是否约见过----:%@",json);
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            YT_dateInfoController *dateVc = [[YT_dateInfoController alloc] init];
            dateVc.userId = weakSelf.userID;
            [weakSelf.navigationController pushViewController:dateVc animated:YES];
            
        }else{
            [SVProgressHUD dismiss];
            [weakSelf showWarningWithString:WARNING];
        }
        
    } failure:^(NSError *error) {
        
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:@"立即约见..."];
}

- (void)dateBtnClick:(UIButton *)btn
{
    [self sendDataIsFinishRequest];
}

- (void)shared
{
    if (!self.activityView) {
        self.activityView = [[HYActivityView alloc]initWithTitle:@"分享到" referView:self.view];
        
        self.activityView.HYbgColor = [UIColor whiteColor];
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 3;
        
        ButtonView *bv = [[ButtonView alloc]initWithText:@"微信好友" image:[UIImage imageNamed:@"yt_wechat"] handler:^(ButtonView *buttonView){
            //微信好友集成服务
            [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:sharedInvestor_HTML,self.model.userId];//微信好友分享url
            [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:sharedHotInvestorTitle,_model.name,_model.company,_model.position];//微信好友分享title
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_model.logo]];
            UIImage *image = [UIImage imageWithData:imageData];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:sharedHotInvestorDetail image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                }
            }];
            
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"QQ好友" image:[UIImage imageNamed:@"yt_qq"] handler:^(ButtonView *buttonView){
            [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:sharedInvestor_HTML,self.model.userId];//qq好友分享url
            [UMSocialData defaultData].extConfig.qqData.title = [NSString stringWithFormat:sharedHotInvestorTitle,_model.name,_model.company,_model.position];//qq好友分享title
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_model.logo]];
            UIImage *image = [UIImage imageWithData:imageData];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:sharedHotInvestorDetail image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                }
            }];
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"朋友圈" image:[UIImage imageNamed:@"yt_wechatTime"] handler:^(ButtonView *buttonView){
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:sharedInvestor_HTML,self.model.userId];
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = [NSString stringWithFormat:sharedHotInvestorTitle,_model.name,_model.company,_model.position];
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_model.logo]];
            UIImage *image = [UIImage imageWithData:imageData];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"" image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                }
            }];
        }];
        [self.activityView addButtonView:bv];
    }
    
    [self.activityView show];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    _myProgressView.progress = 0;
    theBool = false;
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}

//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
//{
//    _myProgressView.progress = 0;
//    theBool = false;
//    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    theBool = true;
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
}

//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
//{
//    theBool = true;
////    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"]
//}

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

- (void)showWarningWithString:(NSString *)warningStr
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:warningStr preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertVc animated:YES completion:nil];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel   handler:^(UIAlertAction * _Nonnull action) {
        return ;
    }];
    [alertVc addAction:alertAction];
}

@end
