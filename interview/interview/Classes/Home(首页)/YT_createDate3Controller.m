//
//  YT_createDate3Controller.m
//  interview
//
//  Created by Mickey on 16/5/10.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_createDate3Controller.h"
#import "YT_DateOrder2Cell.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_DateOrderInfoRequestModel.h"
#import "YT_DateOrderInfoDataModel.h"
#import "YT_DateOrderInfoIndustryListModel.h"
#import <MJExtension.h>
#import "YT_salesController.h"
#import "YT_DetailsHomeWebController.h"
#import "NSString+YBExtension.h"
#import "YT_ItemModel.h"
#import "YT_CreateDateTableController.h"

@interface YT_createDate3Controller ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *timePlaceBgView;
@property (weak, nonatomic) IBOutlet UILabel *orderLable;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLable;
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *datePlaceLable;
@property (weak, nonatomic) IBOutlet UILabel *notesLable;
@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation YT_createDate3Controller

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
    if ([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[YT_CreateDateTableController class]]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else{
        if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[NSClassFromString(@"YT_HomeController") class]] || [[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[NSClassFromString(@"YT_CreateForMeController") class]]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }
    }
}

- (void)createUI
{
    self.NavTitle = @"待约谈";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view1.layer.cornerRadius = 4.5;
    self.view2.layer.cornerRadius = 4.5;
    self.view3.layer.cornerRadius = 4.5;
    self.view4.layer.cornerRadius = 4.5;
    self.view5.layer.cornerRadius = 4.5;
    self.timePlaceBgView.layer.cornerRadius = 6;
    
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.tableV.showsVerticalScrollIndicator = NO;
    self.tableV.showsHorizontalScrollIndicator = NO;
    self.tableV.bounces = NO;
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSString *order = [NSString orderNumberStringWithFormat:[YT_DateOrderInfoRequestModel sharedModel].data.orderNo];
    self.orderLable.attributedText = [NSString orderNumberLableTextAttributedWithString:order];
    self.orderTimeLable.text = [YT_DateOrderInfoRequestModel sharedModel].data.orderTime;
    self.dateTimeLable.text = [YT_DateOrderInfoRequestModel sharedModel].data.time;
    self.datePlaceLable.text = [YT_DateOrderInfoRequestModel sharedModel].data.address;
    if ([YT_DateOrderInfoRequestModel sharedModel].data.notice.length == 0) {
        self.notesLable.text = @"暂无";
    }else{
        self.notesLable.text = [YT_DateOrderInfoRequestModel sharedModel].data.notice;
    }
    
    [self.tableV reloadData];
}

- (void)createData
{
    YT_WS(weakSelf);
    NSDictionary *params = @{@"orderId":self.orderID};
    [YBHttpNetWorkTool post:Url_Date_CreateOrder params:params success:^(id json) {
        YT_LOG(@"order:%@",json);
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            YT_LOG(@"?????----%@",json);
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(self.notesLable.frame) + 20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"home";
    
    YT_DateOrder2Cell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (nil == cell) {
        cell = [[YT_DateOrder2Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
