//
//  YT_RegisterController.m
//  interview
//
//  Created by 于波 on 16/3/22.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_RegisterController.h"
#import "YT_PhoneRegisterController.h"
#import "YT_InvitationCodeController.h"
#import "YT_CommonConstList.h"

@interface YT_RegisterController ()
@property (weak, nonatomic) IBOutlet UIImageView *createRegisterImage;
@property (weak, nonatomic) IBOutlet UIImageView *investorRegisterImage;

@end

@implementation YT_RegisterController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"注册";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.view.backgroundColor = bgColor;
    self.investorRegisterImage.userInteractionEnabled = YES;
    self.createRegisterImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *createTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createRegister)];
    [self.createRegisterImage addGestureRecognizer:createTap];
    
    UITapGestureRecognizer *investorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(investorRegister)];
    [self.investorRegisterImage addGestureRecognizer:investorTap];
}

- (void)createRegister
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"chuangye" forKey:USER_ID];
    
    YT_PhoneRegisterController *phoneVc = [[YT_PhoneRegisterController alloc] init];
    [self.navigationController pushViewController:phoneVc animated:YES];
    
}

- (void)investorRegister
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"touzi" forKey:USER_ID];
    
    YT_InvitationCodeController *invitationCodeVc = [[YT_InvitationCodeController alloc] init];
    [self.navigationController pushViewController:invitationCodeVc animated:YES];
}

@end
