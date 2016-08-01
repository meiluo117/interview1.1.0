//
//  YT_InvestorGetMoneyInfoController.m
//  interview
//
//  Created by Mickey on 16/4/28.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_InvestorGetMoneyInfoController.h"
#import "YT_InvestorPayModel.h"

@interface YT_InvestorGetMoneyInfoController ()
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UILabel *getMoneyLable;
@property (weak, nonatomic) IBOutlet UILabel *accountLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *balanceLable;
- (IBAction)finishBtnClick:(UIButton *)sender;

@end

@implementation YT_InvestorGetMoneyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    
    self.NavTitle = @"提现详情";
    self.finishBtn.layer.cornerRadius = 8.0f;
    self.finishBtn.backgroundColor = btnColor;
    
    self.accountLable.text = [YT_InvestorPayModel sharedPayModel].aliAccount;
    self.balanceLable.text = [NSString stringWithFormat:@"%@元",self.balance];
    self.timeLable.text = self.time;
    self.getMoneyLable.text = [NSString stringWithFormat:@"%@元",self.money];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
}


- (IBAction)finishBtnClick:(UIButton *)sender {
    YT_LOG(@"已经联系工作人员提现");
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
@end
