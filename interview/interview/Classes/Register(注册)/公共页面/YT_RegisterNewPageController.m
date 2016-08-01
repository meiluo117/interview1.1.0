//
//  YT_RegisterNewPageController.m
//  interview
//
//  Created by Mickey on 16/7/29.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_RegisterNewPageController.h"
#import "YT_PhoneRegisterController.h"
#import "YT_InvitationCodeController.h"
#import "YT_CommonConstList.h"

@interface YT_RegisterNewPageController ()
@property (weak, nonatomic) IBOutlet UIImageView *registerBgImageView;
@property (weak, nonatomic) IBOutlet UIView *zhanweiView;
@property (weak,nonatomic) UILabel *navigationItemTitleLable;
- (IBAction)registerCreateBtnClick:(UIButton *)sender;
- (IBAction)registerInvestorBtnClick:(UIButton *)sender;
@end

@implementation YT_RegisterNewPageController //NavigationController.navigationBar

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar_background.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *navigationItemTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navigationItemTitleLable setTextColor:[UIColor blackColor]];
    [navigationItemTitleLable setText:@"注册"];
    navigationItemTitleLable.font = [UIFont boldSystemFontOfSize:18];
    [navigationItemTitleLable sizeToFit];
    self.navigationItem.titleView = navigationItemTitleLable;
}

#pragma mark - 创业者注册click
- (IBAction)registerCreateBtnClick:(UIButton *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"chuangye" forKey:USER_ID];
    
    YT_PhoneRegisterController *phoneVc = [[YT_PhoneRegisterController alloc] init];
    [self.navigationController pushViewController:phoneVc animated:YES];
}
#pragma mark - 投资人注册click
- (IBAction)registerInvestorBtnClick:(UIButton *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"touzi" forKey:USER_ID];
    
    YT_InvitationCodeController *invitationCodeVc = [[YT_InvitationCodeController alloc] init];
    [self.navigationController pushViewController:invitationCodeVc animated:YES];
}

@end
