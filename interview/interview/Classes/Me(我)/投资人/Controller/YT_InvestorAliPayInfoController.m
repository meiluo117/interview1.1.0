//
//  YT_InvestorAliPayInfoController.m
//  interview
//
//  Created by 于波 on 16/4/11.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_InvestorAliPayInfoController.h"
#import "YT_InvestorPayModel.h"

@interface YT_InvestorAliPayInfoController ()
@property (weak, nonatomic) IBOutlet UILabel *AliPayInfoLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@end

@implementation YT_InvestorAliPayInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.NavTitle = @"支付宝";
    self.AliPayInfoLable.text = [YT_InvestorPayModel sharedPayModel].aliAccount;
    self.nameLable.text = [YT_InvestorPayModel sharedPayModel].realName;
}



@end
