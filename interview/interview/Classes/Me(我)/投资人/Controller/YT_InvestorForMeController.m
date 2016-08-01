//
//  YT_InvestorForMeController.m
//  interview
//
//  Created by 于波 on 16/3/21.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_InvestorForMeController.h"
#import "YT_AllOrderClass.h"
#import "YT_SetCreateInfoCell.h"
#import "YT_InvestorPersonInfoModel.h"
#import "UIButton+YBExtension.h"
#import "YT_InvestorYueController.h"
#import "YT_InvestorDateTableController.h"
#import "YT_SetPriceController.h"
#import "YT_SetPwdBeforeController.h"
#import "YT_LoginController.h"
#import "YT_InvestorForMeInfoController.h"
#import "YT_InvestorPayModel.h"
#import "YT_InvestorHasMeetModel.h"
#import <MJExtension.h>
#import "YT_NavigationController.h"
#import "YT_CommonConstList.h"
#import "HYActivityView.h"
#import <UMSocial.h>
#import "YT_OtherUrl.h"
#import "YT_AboutApp.h"
#import "YT_DotCell.h"
#import "UITabBar+YBbadge.h"
#import "AppDelegate.h"
#import "UMessage.h"

@interface YT_InvestorForMeController ()
@property (nonatomic,weak)UILabel *yueNumLable;
@property (nonatomic,weak)UILabel *teamNumLable;
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,weak) UIView *redView;
@property (assign,nonatomic) BOOL isShowDotWithReadAboutAppCell;
@property (nonatomic, strong) HYActivityView *activityView;
@end

@implementation YT_InvestorForMeController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self pushVcWithNotificationInfo];
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
                    YT_investorDateController *orderVc1 = [[YT_investorDateController alloc] init];
                    orderVc1.orderID = app.userInfoDict[@"orderId"];
                    [self.navigationController pushViewController:orderVc1 animated:YES];
                }else if (status_order == 2){
                    YT_investorDate2Controller *orderVc2 = [[YT_investorDate2Controller alloc] init];
                    orderVc2.orderID = app.userInfoDict[@"orderId"];
                    [self.navigationController pushViewController:orderVc2 animated:YES];
                }else if (status_order == 3){
                    YT_investorDate3Controller *orderVc3 = [[YT_investorDate3Controller alloc] init];
                    orderVc3.orderID = app.userInfoDict[@"orderId"];
                    [self.navigationController pushViewController:orderVc3 animated:YES];
                }else if (status_order == 4){
                    YT_investorDate4Controller *orderVc4 = [[YT_investorDate4Controller alloc] init];
                    orderVc4.orderID = app.userInfoDict[@"orderId"];
                    [self.navigationController pushViewController:orderVc4 animated:YES];
                }else if (status_order == 5){
                    YT_investorDate5Controller *orderVc5 = [[YT_investorDate5Controller alloc] init];
                    orderVc5.orderID = app.userInfoDict[@"orderId"];
                    [self.navigationController pushViewController:orderVc5 animated:YES];
                }else if (status_order == 22){
                    YT_investorDate22Controller *orderVc22 = [[YT_investorDate22Controller alloc] init];
                    orderVc22.orderID = app.userInfoDict[@"orderId"];
                    [self.navigationController pushViewController:orderVc22 animated:YES];
                }else if (status_order == 23){
                    YT_investorDate23Controller *orderVc23 = [[YT_investorDate23Controller alloc] init];
                    orderVc23.orderID = app.userInfoDict[@"orderId"];
                    [self.navigationController pushViewController:orderVc23 animated:YES];
                }
                
            }else if (status_remotePushType == 2){
                if (![app.userInfoDict[@"url"] isEqualToString:@""]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:app.userInfoDict[@"url"]]];
                }
            }
            app.userInfoDict = nil;//跳转后,清空推送消息
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self sendHasMeetRequest];
    [self sendPayRequest];
}
- (void)sendPayRequest
{
    YT_WS(weakSelf);
    [YBHttpNetWorkTool post:Url_Investor_PayInfo params:nil success:^(id json) {
        NSInteger status = [json[@"code"] integerValue];
        YT_LOG(@"sendPayRequest----%@",json);
        if (status == 1) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDict = json[@"data"];
            YT_InvestorPayModel *model = [YT_InvestorPayModel mj_objectWithKeyValues:dataDict];
            weakSelf.yueNumLable.text = model.balance;
        }else{
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSError *error) {
        
    } header:[YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:nil];
}

- (void)sendHasMeetRequest
{
    YT_WS(weakSelf);
    [YBHttpNetWorkTool post:Url_Investor_HasMeet params:nil success:^(id json) {
        NSInteger status = [json[@"code"] integerValue];
        YT_LOG(@"sendHasMeetRequest----%@",json);
        if (status == 1) {
            [SVProgressHUD dismiss];
            weakSelf.teamNumLable.text = json[@"data"][@"hasMeet"];
            if ([json[@"data"][@"ifNotice"] isEqualToString:@"true"]) {
                weakSelf.redView.hidden = NO;
                [self.tabBarController.tabBar showBadgeOnItemIndex:2];//添加tabbar红点
            }else{
                weakSelf.redView.hidden = YES;
                [self.tabBarController.tabBar hideBadgeOnItemIndex:2];//移除tabbar红点
            }
        }else{
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSError *error) {
        
    } header:[YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self createHeaderView];
    [self createFooterView];
    //是否新版本
//    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    self.isShowDotWithReadAboutAppCell = app.isNewVersion;
    
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

- (void)loadMeData
{
    [self sendHasMeetRequest];
    [self sendPayRequest];
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReadAppUpDataNews object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshTabBarMe object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshUserInfoShowDot object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PushVcWithTabBarMeAppBackground object:nil];
}

- (void)createTableView
{
    NSArray *arr = @[@[@"设置约谈价格",@"修改个人信息",@"重置密码"],
                     @[@"关于约谈"]];
    self.titleArray = [NSArray arrayWithArray:arr];
    UITableView *tableV = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    tableV.bounces = NO;
    self.tableView = tableV;
}

- (void)createFooterView
{
    UIButton *footBtn = [UIButton otherBtnWithTarget:self Action:@selector(exit:) btnTitle:@"退出登录" andBtnFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    footBtn.backgroundColor = [UIColor whiteColor];
    footBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.tableView.tableFooterView = footBtn;
}

- (void)createHeaderView
{
//    YT_InvestorPayModel *model = [YT_InvestorPayModel sharedPayModel];
    //背景 view
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    bgView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = bgView;
    //中间 灰色线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - 1) / 2, 10, 1, 180)];
    lineView.backgroundColor = YT_Color(249, 249, 249, 1);
    [bgView addSubview:lineView];
    //橘黄色 圆
    UIImageView *orangerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetMinX(lineView.frame) - 120) / 2, 20, 120, 120)];
    orangerImageView.userInteractionEnabled = YES;
    orangerImageView.backgroundColor = YT_Color(240, 111, 48, 1);
    orangerImageView.layer.cornerRadius = 120 / 2;
    [bgView addSubview:orangerImageView];
    UITapGestureRecognizer *orangerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yueClick)];
    [orangerImageView addGestureRecognizer:orangerTap];
    //绿色 圆
    UIImageView *greenImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - CGRectGetMaxX(lineView.frame) - 120) / 2 + CGRectGetMaxX(lineView.frame), 20, 120, 120)];
    greenImageView.userInteractionEnabled = YES;
    greenImageView.backgroundColor = YT_Color(73, 161, 106, 1);
    greenImageView.layer.cornerRadius = 120 / 2;
    [bgView addSubview:greenImageView];
    UITapGestureRecognizer *greenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookClick)];
    [greenImageView addGestureRecognizer:greenTap];
    //灰色 余额提现 文字
    UILabel *yueLable = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetMinX(lineView.frame) - 100) / 2, CGRectGetMaxY(orangerImageView.frame) + 10, 100, 20)];
    yueLable.textAlignment = NSTextAlignmentCenter;
    yueLable.text = @"余额提现";
    yueLable.textColor = YT_ColorFromRGB(0x878787);
    yueLable.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:yueLable];
    //灰色 查看我的约见 文字
    UILabel *lookLable = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - CGRectGetMaxX(lineView.frame) - 100) / 2 + CGRectGetMaxX(lineView.frame), CGRectGetMaxY(orangerImageView.frame) + 10, 100, 20)];
    lookLable.textAlignment = NSTextAlignmentCenter;
    lookLable.text = @"查看我的约见";
    lookLable.textColor = YT_ColorFromRGB(0x878787);
    lookLable.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:lookLable];
    //橘黄色内 余额 文字
    UILabel *orangerYueLable = [[UILabel alloc] initWithFrame:CGRectMake(35, 30, 30, 20)];
    orangerYueLable.text = @"余额";
    orangerYueLable.textColor = [UIColor whiteColor];
    orangerYueLable.font = [UIFont systemFontOfSize:14];
    orangerYueLable.textAlignment = NSTextAlignmentCenter;
    [orangerImageView addSubview:orangerYueLable];
    //橘黄色内 (元) 文字
    UILabel *orangerYuanLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(orangerYueLable.frame), 32, 20, 20)];
    orangerYuanLable.text = @"(元)";
    orangerYuanLable.textColor = [UIColor whiteColor];
    orangerYuanLable.font = [UIFont systemFontOfSize:10];
    orangerYuanLable.textAlignment = NSTextAlignmentCenter;
    [orangerImageView addSubview:orangerYuanLable];
    
    //橘黄色内 余额1000 文字
    UILabel *orangerYuanNumLable = [[UILabel alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(orangerYueLable.frame) + 5, 80, 20)];
//    orangerYuanNumLable.text = @"0";
    orangerYuanNumLable.textColor = [UIColor whiteColor];
    orangerYuanNumLable.font = [UIFont systemFontOfSize:22];
    orangerYuanNumLable.textAlignment = NSTextAlignmentCenter;
    self.yueNumLable = orangerYuanNumLable;
    [orangerImageView addSubview:self.yueNumLable];
    //绿色内 约我 文字
    UILabel *greenYueLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 30, 20)];
    greenYueLable.text = @"约我";
    greenYueLable.textColor = [UIColor whiteColor];
    greenYueLable.font = [UIFont systemFontOfSize:14];
    greenYueLable.textAlignment = NSTextAlignmentCenter;
    [greenImageView addSubview:greenYueLable];
    //绿色内 (团队) 文字
    UILabel *greenYuanLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(greenYueLable.frame), 32, 30, 20)];
    greenYuanLable.text = @"(团队)";
    greenYuanLable.textColor = [UIColor whiteColor];
    greenYuanLable.font = [UIFont systemFontOfSize:10];
    greenYuanLable.textAlignment = NSTextAlignmentCenter;
    [greenImageView addSubview:greenYuanLable];
    //绿色内 团队11 文字
    UILabel *greenTeamNumLable = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(orangerYueLable.frame) + 5, 80, 20)];
//    greenTeamNumLable.text = @"0";
    greenTeamNumLable.textColor = [UIColor whiteColor];
    greenTeamNumLable.font = [UIFont systemFontOfSize:22];
    greenTeamNumLable.textAlignment = NSTextAlignmentCenter;
    self.teamNumLable = greenTeamNumLable;
    [greenImageView addSubview:self.teamNumLable];
    //是否有约见 红色圈
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(greenImageView.frame) - 10, CGRectGetMinY(greenImageView.frame), 10, 10)];
    redView.backgroundColor = [UIColor redColor];
    redView.layer.cornerRadius = 5;
    self.redView = redView;
    [bgView addSubview:self.redView];
}

//余额提现
- (void)yueClick
{
    YT_InvestorYueController *yueVc = [[YT_InvestorYueController alloc] init];
    [self.navigationController pushViewController:yueVc animated:YES];
}
//查看我的约见
- (void)lookClick
{
    YT_InvestorDateTableController *investorDateVc = [[YT_InvestorDateTableController alloc] init];
    [self.navigationController pushViewController:investorDateVc animated:YES];
}
//退出
- (void)exit:(UIButton *)btn
{
    [self exitAlert];
}

- (void)exitAlert
{
    UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:@"" message:@"您确定退出登录?" preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alerVc animated:YES completion:nil];
    
    UIAlertAction *exit = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //清空推送
        [UMessage removeAlias:[YT_InvestorPersonInfoModel sharedPersonInfoModel].userId type:PushAlias response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            
        }];
        //清空用户model
        YT_InvestorPersonInfoModel *model = [YT_InvestorPersonInfoModel sharedPersonInfoModel];
        [model clear];
        //清空账号
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0f;
    }else{
        return 1.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *setCreateInfo = @"setCreateInfo";
    static NSString *dot = @"dot";
    
    if (indexPath.section == 0) {
        YT_SetCreateInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:setCreateInfo];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YT_SetCreateInfoCell" owner:self options:nil] lastObject];
        }
        cell.titleLable.text = self.titleArray[0][indexPath.row];
        return cell;
        
    }else if (indexPath.section == 1){//关于约谈
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
    return  nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { //设置约谈价格
            YT_SetPriceController *setPriceVc = [[YT_SetPriceController alloc] init];
            [self.navigationController pushViewController:setPriceVc animated:YES];
        }else if (indexPath.row == 1){//个人资料
            YT_InvestorForMeInfoController *meInfoVc = [[YT_InvestorForMeInfoController alloc] init];
            [self.navigationController pushViewController:meInfoVc animated:YES];
        }else{//修改密码
            YT_SetPwdBeforeController *beforePwdVc = [[YT_SetPwdBeforeController alloc] init];
            [self.navigationController pushViewController:beforePwdVc animated:YES];
        }
    }else if (indexPath.section == 1){
        YT_AboutApp *aboutAppVc = [[YT_AboutApp alloc] init];
        [self.navigationController pushViewController:aboutAppVc animated:YES];
    }
}


@end
