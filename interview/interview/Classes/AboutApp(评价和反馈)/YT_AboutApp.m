//
//  YT_AboutApp.m
//  interview
//
//  Created by Mickey on 16/6/22.
//  Copyright © 2016年 于波. All rights reserved.
//https://itunes.apple.com/cn/app/yue-tanyt/id1092458285?mt=8
#define AppStoreCommentStarUrl @"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1092458285&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
#define ServicePhoneNumber @"010-53399322"
#import "YT_AboutApp.h"
#import "HYActivityView.h"
#import <UMSocial.h>
#import "YT_OtherUrl.h"
#import "YT_DotCell.h"
#import "YT_AboutAppWeb.h"
#import "AppDelegate.h"
#import "YT_OpinionController.h"

@interface YT_AboutApp ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) HYActivityView *activityView;
@property (weak, nonatomic) IBOutlet UITableView *aboutAppTableV;
@property (strong,nonatomic) NSMutableArray *titleArray;
@property (assign,nonatomic)BOOL dotIsExist;

@end

@implementation YT_AboutApp

static NSString *const string = @"dot";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
//    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    self.dotIsExist = app.isNewVersion;
}

- (void)createUI
{
    self.NavTitle = @"关于约谈";
    
    self.aboutAppTableV.delegate = self;
    self.aboutAppTableV.dataSource = self;
    self.aboutAppTableV.scrollEnabled = NO;
    self.aboutAppTableV.tableFooterView = [[UIView alloc] init];
    
    self.titleArray = [NSMutableArray arrayWithObjects:@"意见反馈",@"去评分",[NSString stringWithFormat:@"客服电话: %@",ServicePhoneNumber],@"系统通知",@"分享此App给好友", nil];
    [self.aboutAppTableV reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YT_DotCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    
    if (nil == cell) {
        cell = [[YT_DotCell alloc] init];
    }
    
    cell.titleLable.text = self.titleArray[indexPath.row];
    [cell layoutIfNeeded];
    
    if (indexPath.row == 3) {
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.isNewVersion ? [cell showDotViewWithTitleLable:cell.titleLable] : [cell hideDot];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YT_WS(weakSelf);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {//意见反馈
        YT_OpinionController *opinionVc = [[YT_OpinionController alloc] init];
        [self.navigationController pushViewController:opinionVc animated:YES];
    }else if (indexPath.row == 1){//去评分
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStoreCommentStarUrl]];
    }else if (indexPath.row == 2){//客服电话
        [self callPhone];
    }else if (indexPath.row == 3){//系统通知
        YT_AboutAppWeb *Vc = [[YT_AboutAppWeb alloc] init];
        
//        Vc.dotBlock = ^(BOOL exist){
//            _dotIsExist = exist;
//            [weakSelf.aboutAppTableV reloadData];
//        };
        [self.navigationController pushViewController:Vc animated:YES];
        
    }else if (indexPath.row == 4){//分享此App给好友
        [self sharedApp];
    }
}

- (void)callPhone
{
    UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:@"是否拨打客服电话?" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alerVc animated:YES completion:nil];
    
    UIAlertAction *phoneCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *phoneCall = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"拨打 %@",ServicePhoneNumber] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        NSString *call = [NSString stringWithFormat:@"tel://%@",ServicePhoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:call]];
        
    }];
    
    [alerVc addAction:phoneCancel];
    [alerVc addAction:phoneCall];
}

#pragma mark - 分享
- (void)sharedApp
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    if (!self.activityView) {
        self.activityView = [[HYActivityView alloc]initWithTitle:@"分享到" referView:window];
        
        self.activityView.HYbgColor = [UIColor whiteColor];
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 3;
        
        ButtonView *bv = [[ButtonView alloc]initWithText:@"微信好友" image:[UIImage imageNamed:@"yt_wechat"] handler:^(ButtonView *buttonView){
            //微信好友集成服务
            [UMSocialData defaultData].extConfig.wechatSessionData.url = sharedDownloadAPP;//微信好友分享url
            [UMSocialData defaultData].extConfig.wechatSessionData.title = sharedTitle;//微信好友分享title
            UIImage *image = [UIImage imageNamed:@"appIcon29"];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:sharedDetail image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                }
            }];
            
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"QQ好友" image:[UIImage imageNamed:@"yt_qq"] handler:^(ButtonView *buttonView){
            [UMSocialData defaultData].extConfig.qqData.url = sharedDownloadAPP;//qq好友分享url
            [UMSocialData defaultData].extConfig.qqData.title = sharedTitle;//qq好友分享title
            UIImage *image = [UIImage imageNamed:@"appIcon29"];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:sharedDetail image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                }
            }];
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"朋友圈" image:[UIImage imageNamed:@"yt_wechatTime"] handler:^(ButtonView *buttonView){
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = sharedDownloadAPP;//
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = sharedDetail;//
            UIImage *image = [UIImage imageNamed:@"appIcon29"];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:sharedTitle image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                }
            }];
        }];
        [self.activityView addButtonView:bv];
    }
    
    [self.activityView show];
}

#pragma mark - 懒加载
- (NSMutableArray *)titleArray
{
    if (_titleArray == nil) {
        self.titleArray = [NSMutableArray array];
    }
    return _titleArray;
}


@end
