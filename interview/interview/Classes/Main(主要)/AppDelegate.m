//
//  AppDelegate.m
//  interview
//
//  Created by 于波 on 16/3/12.
//  Copyright © 2016年 于波. All rights reserved.
//
#define CheckAppVersionUrl @"https://itunes.apple.com/lookup?id=1092458285"

#import "AppDelegate.h"
#import "YT_TabBarController.h"
#import "YT_LoginController.h"
#import "YT_NavigationController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "YT_CreatePersonInfoModel.h"
#import "YT_OtherUrl.h"
#import "YT_InvestorPersonInfoModel.h"
#import "YT_InvestorItemsInfoModel.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_CreateItemsInfoModel.h"
#import <MJExtension.h>
#import "NSString+YBExtension.h"
#import "YT_CommonConstList.h"
#import "YT_DateOrderInfoRequestModel.h"
#import "YT_DateOrderInfoDataModel.h"
#import <UMSocial.h>
//#import <UMSocialSinaHandler.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialQQHandler.h>
#import "UMessage.h"
#import "YT_HomeController.h"
#import "YT_InvestorForMeController.h"
#import "YT_CreateForMeController.h"
#import "YT_AllOrderClass.h"
#import "VersionManager.h"
#import "YT_iOS9StartController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//***************************获取iphone设备信息****************************************
    UIDevice* curDev = [UIDevice currentDevice];
    NSUUID *uuid = [NSUUID UUID];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];//CFBundleShortVersionString//CFBundleVersion
    YT_LOG(@"app当前版本?---%@",app_Version);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:app_Version forKey:@"appVer"];//app版本
    [defaults setObject:curDev.model forKey:@"client"];//iphone/ipad设备
    [defaults setObject:curDev.systemVersion forKey:@"os"];//iphone/ipad系统版本
    [defaults setObject:uuid.UUIDString forKey:@"did"];//iphoneUUID
    [defaults synchronize];
//****************************获取iphone设备信息****************************************
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    YT_iOS9StartController *startVc = [[YT_iOS9StartController alloc] init];//防止iOS9崩溃
    self.window.rootViewController = startVc;//防止iOS9崩溃
    [self.window makeKeyAndVisible];
    
    [self checkAppVersion];//检测版本
    
    //取出token
    NSString *user_token = [defaults objectForKey:USER_TOKEN];
    YT_LOG(@"token----%@",user_token);
    
    //应用未启动（不在后台和前台的情况下）点击推送消息进入应用or点击app icon进入应用都会调用这个方法
    if (launchOptions) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo != nil && user_token.length != 0) {
            [UMessage setAutoAlert:NO];//关闭友盟弹出框
            self.userInfoDict = userInfo;
            [self sendUserInfoRequestWithToken:user_token andTabBarSelectedIndex:2];
        }
    }else{
        
        if (user_token.length == 0) {
            //没登录过，跳转登陆页面
            YT_LoginController *loginVc = [[YT_LoginController alloc] init];
            YT_NavigationController *nav = [[YT_NavigationController alloc] initWithRootViewController:loginVc];
            self.window.rootViewController = nav;
        }else{
            //登陆过，自动登陆，获取个人信息
            [self sendUserInfoRequestWithToken:user_token andTabBarSelectedIndex:0];
        }
    }
    //****************************注册第三方服务****************************************
    [self UMengShared];//注册友盟分享
    [self UMengPush:launchOptions];//注册友盟推送
    //****************************注册第三方服务****************************************
    
    
    return YES;
}

- (void)registerUMengAliasWithUserId:(NSString *)userId
{
    [UMessage addAlias:userId type:PushAlias response:^(id responseObject, NSError *error) {
        YT_LOG(@"addAlias_responseObject---%@",responseObject);
    }];
}

#pragma mark - 注册友盟推送
- (void)UMengPush:(NSDictionary *)launchOptions
{
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:umengAppKey launchOptions:launchOptions];
    //1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
    [UMessage registerForRemoteNotifications];
}

#pragma mark - 登录成功,请求个人信息
- (void)sendUserInfoRequestWithToken:(NSString *)userToken andTabBarSelectedIndex:(NSInteger)index
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    YT_WS(weakSelf);
    [YBHttpNetWorkTool post:Url_UserInfo params:nil success:^(id json) {
        YT_LOG(@"----个人信息%@",json);
        NSInteger statusCode = [json[@"code"] integerValue];
        
        if (statusCode == 1) {
            NSDictionary *dataDict = json[@"data"];
            //用户绑定友盟推送
            [weakSelf registerUMengAliasWithUserId:dataDict[@"userId"]];
            
            NSInteger type = [dataDict[@"type"] integerValue];
            NSMutableArray *itemTagTitleArray = [NSMutableArray array];
            NSString *indexString = [NSMutableString string];
            
            if (type == 1) {
                [userDefaults setObject:@"touzi" forKey:USER_ID];
                [userDefaults synchronize];
                [YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket = userToken;
                
                [YT_InvestorPersonInfoModel mj_objectWithKeyValues:dataDict];
                
                for (YT_InvestorItemsInfoModel *model in [YT_InvestorPersonInfoModel sharedPersonInfoModel].industryList) {
                    [itemTagTitleArray addObject:model.value];
                }
                [YT_InvestorPersonInfoModel sharedPersonInfoModel].itemArray = [itemTagTitleArray copy];
                
                for (NSString *str in itemTagTitleArray) {
                    indexString = [indexString stringByAppendingFormat:@"%@,",str];
                    [YT_InvestorPersonInfoModel sharedPersonInfoModel].itemTagTitle = [indexString substringToIndex:indexString.length - 1];
                }
                
            }else{
                [userDefaults setObject:@"chuangye" forKey:USER_ID];
                [userDefaults synchronize];
                [YT_CreatePersonInfoModel sharedPersonInfoModel].ticket = userToken;
                [YT_CreatePersonInfoModel sharedPersonInfoModel].projectId = dataDict[@"projectId"];
                
                [YT_CreatePersonInfoModel mj_objectWithKeyValues:dataDict];
                
                for (YT_CreateItemsInfoModel *model in [YT_CreatePersonInfoModel sharedPersonInfoModel].industryList) {
                    [itemTagTitleArray addObject:model.value];
                }
                [YT_CreatePersonInfoModel sharedPersonInfoModel].itemArray = [itemTagTitleArray copy];
                
                for (NSString *str in itemTagTitleArray) {
                    indexString = [indexString stringByAppendingFormat:@"%@,",str];
                    [YT_CreatePersonInfoModel sharedPersonInfoModel].itemTagTitle = [indexString substringToIndex:indexString.length - 1];
                }
                
                NSString *itemIndex = [NSMutableString string];
                for (YT_CreateItemsInfoModel *model in [YT_CreatePersonInfoModel sharedPersonInfoModel].industryList) {
                    itemIndex = [itemIndex stringByAppendingFormat:@"%@,",model.index];
                    [YT_CreatePersonInfoModel sharedPersonInfoModel].itemTag = [itemIndex substringToIndex:itemIndex.length - 1];
                }
            }
                YT_TabBarController *tabBar = [[YT_TabBarController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = tabBar;
                tabBar.selectedIndex = index;
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
            [weakSelf removeUserInfo];
            [weakSelf goLogin];
        }
        
    } failure:^(NSError *error) {
        [weakSelf removeUserInfo];
        [weakSelf goLogin];
    } header:userToken ShowWithStatusText:@"正在登陆..."];
}

- (void)goLogin
{
    YT_WS(weakSelf);
    YT_LoginController *loginVc = [[YT_LoginController alloc] init];
    YT_NavigationController *nav = [[YT_NavigationController alloc] initWithRootViewController:loginVc];
    weakSelf.window.rootViewController = nav;
}
//登录失败，清空个人数据
- (void)removeUserInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USER_PHONE];
    [userDefaults removeObjectForKey:USER_PASSWORD];
    [userDefaults removeObjectForKey:USER_TOKEN];
    [userDefaults synchronize];
    [[YT_CreatePersonInfoModel sharedPersonInfoModel] clear];
    [[YT_InvestorPersonInfoModel sharedPersonInfoModel] clear];
}

#pragma mark - 注册友盟分享
- (void)UMengShared
{
    //友盟分享
    [UMSocialData setAppKey:umengAppKey];
    //微博
    //    [UMSocialSinaHandler openSSOWithRedirectURL:WeiboSSO];
    //QQ
    [UMSocialQQHandler setQQWithAppId:QQWithAppId appKey:QQWithAppKey url:QQWithUrl];
    //微信
    [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXAppSecret url:WXWithUrl];
}

#pragma mark - 支付宝_openURL
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            YT_LOG(@"支付宝返回result = %@",resultDic);
            
            //支付宝返回9000，向服务器发送确认请求
            NSInteger status = [resultDic[@"resultStatus"] integerValue];
            if (status == 9000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_PaySure object:nil];
//                [weakSelf sendPaySureRequest];
            }
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            YT_LOG(@"9.0以后使用新API接口,支付宝返回result = %@",resultDic);
            
            //支付宝返回9000，向服务器发送确认请求
            NSInteger status = [resultDic[@"resultStatus"] integerValue];
            if (status == 9000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_PaySure object:nil];
                
//                [weakSelf sendPaySureRequest];
            }
            
        }];
    }
    return YES;
}
//发送支付信息
- (void)sendPaySureRequest
{
    NSString *orderId = [YT_DateOrderInfoRequestModel sharedModel].data.orderId;
    NSDictionary *params = @{@"orderId":orderId};
    
    [YBHttpNetWorkTool post:Url_AliPay_AgainSure params:params success:^(id json) {
        YT_LOG(@"支付成功向后台确认%@",json);
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            //向服务器确认，支付成功
            [SVProgressHUD showSuccessWithStatus:json[@"msg"]];

            [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_PaySure object:nil];
        }else{
            //向服务器确认，支付失败
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求超时"];
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:@"正在提交..."];
}

#pragma mark - 清楚图片缓存_ReceiveMemoryWarning
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    //取消下载
    [manager cancelAll];
    //清除内存中的所有图片
    [manager.imageCache clearMemory];
}

#pragma mark - 友盟推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
//    [UMessage registerDeviceToken:deviceToken];
    YT_LOG(@"%@",[NSString stringWithDeviceToekn:deviceToken]);
}

#pragma mark - 处理远程推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    YT_LOG(@"IOS如何跳转到指定页面_didReceiveRemoteNotification_userInfo-----:%@",userInfo);
    [UMessage setAutoAlert:NO];//关闭友盟弹出框
    [UMessage didReceiveRemoteNotification:userInfo];
    
    NSInteger remoteMessageType = [userInfo[@"type"] integerValue];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive){//app在前台
        //收到推送 在tabbar“我” 显示红点
        if (remoteMessageType == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NewNotification object:nil];
            //让投资人和创业者的列表刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshDataTable object:nil];
            
            [self postNotficaitonToTabBarMeRefreshData];
        }
        
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){//app非活跃
        //收到推送 在tabbar“我” 显示红点
        //        [[NSNotificationCenter defaultCenter] postNotificationName:NewNotification object:nil];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *user_token = [defaults objectForKey:USER_TOKEN];
        if (user_token.length != 0) {//token不为空，说明在登录状态
            self.userInfoDict = userInfo;//远程通知赋值
            
            YT_TabBarController *ytTabBar = (YT_TabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            YT_NavigationController *ytNav = ytTabBar.selectedViewController;
            
            if ([ytNav.visibleViewController isKindOfClass:[YT_InvestorForMeController class]] || [ytNav.visibleViewController isKindOfClass:[YT_CreateForMeController class]]) {
                //app在tabbar“我”的当前页进入后台，收到推送，点击推送，app从后台进入前台，发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:PushVcWithTabBarMeAppBackground object:nil];
            }else{
                
                UIViewController *backVc = (UIViewController *)ytNav.visibleViewController;
                
                NSArray *viewcontrollers = backVc.navigationController.viewControllers;
                if (viewcontrollers.count > 1) {
                    if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == backVc) {
                        //push方式
                        [backVc.navigationController popToRootViewControllerAnimated:YES];
                        
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            ytTabBar.selectedIndex = 2;
                        });
                    }
                }
                else{
                    //present方式 目前只有tabbar present出搜索页面 欠缺其他页面存在present页面的考虑
                    [backVc dismissViewControllerAnimated:YES completion:nil];
                    
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        ytTabBar.selectedIndex = 2;
                    });
                }
            }
        }else{
            [self jumpAppStoreWithNotification:userInfo];
        }
        
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        YT_LOG(@"UIApplicationStateBackground");
    }
}

#pragma mark - 跳转AppStore下载页面
- (void)jumpAppStoreWithNotification:(NSDictionary *)remoteNotification
{
    YT_LOG(@"remoteNotification----%@",remoteNotification);
    if (![remoteNotification[@"url"] isEqualToString:@""]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:remoteNotification[@"url"]]];
    }
}

#pragma mark - 检测app在appstore版本
- (void)checkAppVersion
{
    YT_WS(weakSelf);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [YBHttpNetWorkTool get:CheckAppVersionUrl params:nil success:^(id json) {
        NSDictionary *dict = [json[@"results"] lastObject];
        weakSelf.isNewVersion = [NSString isNewVersionWithPresentVersion:[defaults objectForKey:@"appVer"] andAppStoreVersion:dict[@"version"]];
        YT_LOG(@"???????????:%@",weakSelf.isNewVersion ? @"yes" : @"no");
        
    } failure:^(NSError *error) {
        YT_LOG(@"app在appstore版本为error%@",error);
    }];
}

#pragma mark - app从后台进入前台调用
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_token = [defaults objectForKey:USER_TOKEN];
    if (user_token.length != 0) {
        [YBHttpNetWorkTool post:Url_UserInfo params:nil success:^(id json) {
            NSInteger statusCode = [json[@"code"] integerValue];
            if (statusCode == 1) {
                [SVProgressHUD dismiss];
                //每次app从后台到前台，刷新tabbar“我”的红点显示
                [json[@"data"][@"type"] isEqualToString:@"1"] ? [YT_InvestorPersonInfoModel mj_objectWithKeyValues:json[@"data"]] : [YT_CreatePersonInfoModel mj_objectWithKeyValues:json[@"data"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshUserInfoShowDot object:nil];
            }
            
        } failure:^(NSError *error) {
            
        } header:user_token ShowWithStatusText:nil];
    }
}

#pragma mark - 当每次有新版本，只提醒一次
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [VersionManager checkVerSion];
}

- (void)postNotficaitonToTabBarMeRefreshData
{
    YT_TabBarController *ytTabBar = (YT_TabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    YT_NavigationController *ytNav = ytTabBar.selectedViewController;
    
    if ([ytNav.visibleViewController isKindOfClass:[YT_InvestorForMeController class]] || [ytNav.visibleViewController isKindOfClass:[YT_CreateForMeController class]]) {
        //app只有停留在tabbar“我”的当前页进入后台，再从后台进入前台的时候，才去刷新tabbar“我”的页面
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshTabBarMe object:nil];
    }
}

@end
