//
//  YT_createDateController.m
//  interview
//
//  Created by Mickey on 16/5/9.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_createDateController.h"
#import "YT_DateOrderCell.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_DateOrderInfoRequestModel.h"
#import "YT_DateOrderInfoDataModel.h"
#import "YT_DateOrderInfoIndustryListModel.h"
#import <MJExtension.h>
#import "YT_DetailsHomeWebController.h"
#import "YT_HomeController.h"
#import "NSString+YBExtension.h"
#import "YT_ItemModel.h"
#import "YT_InvestorController.h"
#import "YT_CreateDateTableController.h"

@interface YT_createDateController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *orderLable;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLable;
@end

@implementation YT_createDateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self readOrderRequest];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"zuojiantou"];
}

- (void)back
{
//    if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[NSClassFromString(@"YT_HomeController") class]] || [[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[NSClassFromString(@"YT_CreateForMeController") class]]) {
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
//    }else{
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//    }
    
    if ([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[YT_CreateDateTableController class]] || [[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[YT_DetailsHomeWebController class]]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else{
        if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[NSClassFromString(@"YT_HomeController") class]] || [[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[NSClassFromString(@"YT_CreateForMeController") class]]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
    }
}

- (void)createData
{
    YT_WS(weakSelf);
    NSDictionary *params = @{@"orderId":self.orderID};
    [YBHttpNetWorkTool post:Url_Date_CreateOrder params:params success:^(id json) {
        YT_LOG(@"order:%@",json);
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            [YT_DateOrderInfoRequestModel mj_objectWithKeyValues:json];
            [weakSelf.dataArray addObject:[YT_DateOrderInfoRequestModel sharedModel].data];
            
            [weakSelf createUI];
        }else{
            
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:@"正在加载..."];
}
//确认订单已读
- (void)readOrderRequest
{
    NSDictionary *params = @{@"orderId":self.orderID,@"type":@"1",@"source":@"1"};
    [YBHttpNetWorkTool post:Url_ReadOrder params:params success:^(id json) {
        
    } failure:^(NSError *error) {
        
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:nil];
}

- (void)createUI
{
    self.NavTitle = @"待投资人接受";
    
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.tableV.showsVerticalScrollIndicator = NO;
    self.tableV.showsHorizontalScrollIndicator = NO;
    self.tableV.bounces = NO;
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSString *order = [NSString orderNumberStringWithFormat:[YT_DateOrderInfoRequestModel sharedModel].data.orderNo];
    self.orderLable.attributedText = [NSString orderNumberLableTextAttributedWithString:order];
    self.orderTimeLable.text = [YT_DateOrderInfoRequestModel sharedModel].data.orderTime;
    
    [self.tableV reloadData];//??????
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"home";
    
    YT_DateOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (nil == cell) {
        cell = [[YT_DateOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (self.dataArray.count > indexPath.row){
        cell.model = self.dataArray[0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YT_DetailsHomeWebController *investorDetailWebVc = [[YT_DetailsHomeWebController alloc] init];
    investorDetailWebVc.isExistDateBtn = YES;
    YT_ItemModel *model = self.dataArray[indexPath.row];
    investorDetailWebVc.model = model;
    [self.navigationController pushViewController:investorDetailWebVc animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
