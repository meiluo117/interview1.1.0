//
//  YT_CreateForMeController.m
//  interview
//
//  Created by 于波 on 16/3/21.
//  Copyright © 2016年 于波. All rights reserved.

#define HeadViewHeight 140.0f
#define FootViewHeight 40.0f
#define HeadImageW 80.0f //头像宽和高
#define HeadImageY 20.0f //头像的y坐标
#define HeadImageX (ScreenWidth - HeadImageW) / 2 //头像的x坐标

#import "YT_CreateForMeController.h"
#import "YT_PhoneRegisterController.h"
#import "YT_SetCreateInfoCell.h"
#import "YT_LoginController.h"
#import "UIButton+YBExtension.h"
#import "YT_CreateDateTableController.h"
#import "YT_SetPwdBeforeController.h"
#import "YT_SetCreateInfoController.h"
#import "YT_SetCreateDetailController.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_SetCreateInfoForMeController.h"
#import <MJExtension.h>
#import "YT_NavigationController.h"
#import "YT_CommonConstList.h"
#import "HYActivityView.h"
#import <UMSocial.h>
#import "YT_OtherUrl.h"
#import "YT_AboutApp.h"
#import "UITabBar+YBbadge.h"
#import "YT_DotCell.h"
#import "UMessage.h"
#import "AppDelegate.h"
#import "YT_AllOrderClass.h"

@interface YT_CreateForMeController ()

@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,weak)UILabel *nameLable;
@property (nonatomic,weak)UIImageView *headImageView;
@property (nonatomic, strong) HYActivityView *activityView;
@property (assign,nonatomic) BOOL isShowDotWithReadAboutAppCell;
@end

@implementation YT_CreateForMeController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self pushVcWithNotificationInfo];//页面完全出现 再去跳转
}

- (void)pushVcWithNotificationInfo
{
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.userInfoDict != nil) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //判断消息类型是广播还单播
            NSInteger status_remotePushType = [app.userInfoDict[@"type"] integerValue];
            
            if (status_remotePushType == 1) {//单播
                NSInteger status_order = [app.userInfoDict[@"orderStatus"] integerValue];
                if (status_order == 1) {
                    YT_createDateController *orderVc1 = [[YT_createDateController alloc] init];
                    orderVc1.orderID = app.userInfoDict[@"orderId"];
                    [self.navigationController pushViewController:orderVc1 animated:YES];
                }else if (status_order == 2){
                    YT_createDate2Controller *orderVc2 = [[YT_createDate2Controller alloc] init];
                    orderVc2.orderID = app.userInfoDict[@"orderId"];
                    [self.navigationController pushViewController:orderVc2 animated:YES];
                }else if (status_order == 3){
                    YT_createDate3Controller *orderVc3 = [[YT_createDate3Controller alloc] init];
                    orderVc3.orderID = app.userInfoDict[@"orderId"];
                    [self.navigationController pushViewController:orderVc3 animated:YES];
                }else if (status_order == 4){
                    YT_createDate4Controller *orderVc4 = [[YT_createDate4Controller alloc] init];
                    orderVc4.orderID = app.userInfoDict[@"orderId"];
                    [self.navigationController pushViewController:orderVc4 animated:YES];
                }else if (status_order == 5){
                    YT_createDate5Controller *orderVc5 = [[YT_createDate5Controller alloc] init];
                    orderVc5.orderID = app.userInfoDict[@"orderId"];
                    [self.navigationController pushViewController:orderVc5 animated:YES];
                }else if (status_order == 22){
                    YT_createDate22Controller *orderVc22 = [[YT_createDate22Controller alloc] init];
                    orderVc22.orderID = app.userInfoDict[@"orderId"];
                    [self.navigationController pushViewController:orderVc22 animated:YES];
                }else if (status_order == 23){
                    YT_createDate23Controller *orderVc23 = [[YT_createDate23Controller alloc] init];
                    orderVc23.orderID = app.userInfoDict[@"orderId"];
                    [self.navigationController pushViewController:orderVc23 animated:YES];
                }
                
            }else if (status_remotePushType == 2){
                if (![app.userInfoDict[@"url"] isEqualToString:@""]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:app.userInfoDict[@"url"]]];
                }
            }
            app.userInfoDict = nil;
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadMeData];
}

- (void)loadMeData
{
    YT_WS(weakSelf);
    [YBHttpNetWorkTool post:Url_UserInfo params:nil success:^(id json) {
        YT_LOG(@"----%@",json);
        NSInteger statusCode = [json[@"code"] integerValue];
        
        if (statusCode == 1) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDict = json[@"data"];
            [YT_CreatePersonInfoModel mj_objectWithKeyValues:dataDict];
            [weakSelf showDotWithTabbar];
            [weakSelf.tableView reloadData];
            [weakSelf createHeadView];
        }else{
            [SVProgressHUD dismiss];
        }
    } failure:^(NSError *error) {
        
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:nil];
}

- (void)showDotWithTabbar
{
    if ([[YT_CreatePersonInfoModel sharedPersonInfoModel].ifNotice isEqualToString:@"true"]) {
        [self.tabBarController.tabBar showBadgeOnItemIndex:2];
    }else{
        [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YT_Color(244, 244, 244, 1);
    self.titleArray = @[@[@"我约的投资人",@"个人信息",@"项目信息",@"重置密码"],@[@"关于约谈"]];
    UITableView *tableV = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    tableV.bounces = NO;
    self.tableView = tableV;
    
    [self createHeadView];
    [self createFootView];
    //是否新版本
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.isShowDotWithReadAboutAppCell = app.isNewVersion;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelDot) name:ReadAppUpDataNews object:nil];
    //当在tabbar“我”，进入后台，再进入前台的时候刷新tabbar //RefreshTabBarMe
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMeData) name:RefreshTabBarMe object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jump) name:PushVcWithTabBarMeAppBackground object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMeData) name:RefreshUserInfoShowDot object:nil];
}
- (void)jump
{
    [self pushVcWithNotificationInfo];
}

- (void)cancelDot
{
    _isShowDotWithReadAboutAppCell = NO;
    [self.tableView reloadData];
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReadAppUpDataNews object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshTabBarMe object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshUserInfoShowDot object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PushVcWithTabBarMeAppBackground object:nil];
}

- (void)createHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HeadViewHeight)];
    headView.backgroundColor = YT_Color(226, 252, 240, 1);
    self.tableView.tableHeaderView = headView;
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(HeadImageX, HeadImageY, HeadImageW, HeadImageW)];
    if ([YT_CreatePersonInfoModel sharedPersonInfoModel].headImg.length != 0) {
        [headImageView sd_setImageWithURL:[NSURL URLWithString:[YT_CreatePersonInfoModel sharedPersonInfoModel].headImg]];
    }else{
        headImageView.image = [UIImage imageNamed:@"touxiang"];
    }
    headImageView.layer.cornerRadius = HeadImageW / 2;
    headImageView.layer.masksToBounds = YES;
    self.headImageView = headImageView;
    [headView addSubview:self.headImageView];
    
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 200) / 2, HeadImageY + HeadImageW + 5, 200, 30)];
    nameLable.text = [YT_CreatePersonInfoModel sharedPersonInfoModel].realName;
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.font = [UIFont systemFontOfSize:14];
    nameLable.textColor = titleColor;
    self.nameLable = nameLable;
    [headView addSubview:self.nameLable];
}

- (void)createFootView
{
    UIButton *footBtn = [UIButton otherBtnWithTarget:self Action:@selector(exitClick:) btnTitle:@"退出登录" andBtnFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    footBtn.backgroundColor = [UIColor whiteColor];
    footBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.tableView.tableFooterView = footBtn;
}

- (void)exitClick:(UIButton *)btn
{
    [self exitAlert];
}

- (void)exitAlert
{
    UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:@"" message:@"您确定退出登录?" preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alerVc animated:YES completion:nil];
    
    UIAlertAction *exit = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //清空推送别名
        [UMessage removeAlias:[YT_CreatePersonInfoModel sharedPersonInfoModel].userId type:PushAlias response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            
        }];
        //清空用户model
        YT_CreatePersonInfoModel *model = [YT_CreatePersonInfoModel sharedPersonInfoModel];
        [model clear];
        //清空账号
        NSUserDefaults *userDefaults  = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:USER_PHONE];
        [userDefaults removeObjectForKey:USER_PASSWORD];
        [userDefaults removeObjectForKey:USER_TOKEN];
        [userDefaults synchronize];
        
        YT_NavigationController *nav = [[YT_NavigationController alloc] initWithRootViewController:[[YT_LoginController alloc] init]];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alerVc addAction:exit];
    [alerVc addAction:cancel];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.titleArray[section] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *setCreateInfo  = @"setCreateInfo";
    static NSString *dot = @"dot";
    
    if (indexPath.section == 0) {
        if (indexPath.row != 0) {
            YT_SetCreateInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:setCreateInfo];
            if (nil == cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"YT_SetCreateInfoCell" owner:self options:nil] lastObject];
            }
            cell.titleLable.text = self.titleArray[0][indexPath.row];
            return cell;
        }else{
            YT_DotCell *cell = [tableView dequeueReusableCellWithIdentifier:dot];
            if (nil == cell) {
                cell = [[YT_DotCell alloc] init];
            }
            cell.titleLable.text = self.titleArray[0][0];
            [cell layoutIfNeeded];
            if ([[YT_CreatePersonInfoModel sharedPersonInfoModel].ifNotice isEqualToString:@"true"]) {
                [cell showDotViewWithTitleLable:cell.titleLable];
            }else{
                [cell hideDot];
            }
            
            return cell;
        }
        
    }else if (indexPath.section == 1){
        YT_DotCell *cell = [tableView dequeueReusableCellWithIdentifier:dot];
        if (nil == cell) {
            cell = [[YT_DotCell alloc] init];
        }
        cell.titleLable.text = self.titleArray[1][indexPath.row];
        [cell layoutIfNeeded];
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.isNewVersion ? [cell showDotViewWithTitleLable:cell.titleLable] : [cell hideDot];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//我越的投资人
            YT_CreateDateTableController *createDateVc = [[YT_CreateDateTableController alloc] init];
            [self.navigationController pushViewController:createDateVc animated:YES];
        }else if (indexPath.row == 1){//个人信息
            YT_SetCreateInfoController *setCreateVc = [[YT_SetCreateInfoController alloc] init];
            setCreateVc.navTitleString = @"个人信息";
            setCreateVc.isExistBtn = NO;
            [self.navigationController pushViewController:setCreateVc animated:YES];
        }else if (indexPath.row == 2){//项目信息
            YT_SetCreateInfoForMeController *setCreateInfoForMEVc = [[YT_SetCreateInfoForMeController alloc] init];
            [self.navigationController pushViewController:setCreateInfoForMEVc animated:YES];
        }else if (indexPath.row == 3){//重置密码
            YT_SetPwdBeforeController *setPwdBeforeVc = [[YT_SetPwdBeforeController alloc] init];
            [self.navigationController pushViewController:setPwdBeforeVc animated:YES];
        }
    }else if (indexPath.section == 1){//分享
        YT_AboutApp *aboutAppVc = [[YT_AboutApp alloc] init];
        [self.navigationController pushViewController:aboutAppVc animated:YES];
    }
    
}



@end
