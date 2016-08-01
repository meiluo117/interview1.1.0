//
//  YT_createDate2Controller.m
//  interview
//
//  Created by Mickey on 16/5/10.
//  Copyright © 2016年 于波. All rights reserved.
//
#import "YT_createDate2Controller.h"
#import "YT_DateOrderCell.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_DateOrderInfoRequestModel.h"
#import "YT_DateOrderInfoDataModel.h"
#import "YT_DateOrderInfoIndustryListModel.h"
#import <MJExtension.h>
#import "YT_salesController.h"
#import "YT_DetailsHomeWebController.h"
#import "YBTimeTool.h"
#import "YT_OtherUrl.h"
#import <AlipaySDK/AlipaySDK.h>
#import "YT_CommonConstList.h"
#import "YT_createDate3Controller.h"
#import "NSString+YBExtension.h"
#import "YT_ItemModel.h"
#import "YT_createDate23Controller.h"

@interface YT_createDate2Controller ()<UITableViewDelegate,UITableViewDataSource>
{
    dispatch_source_t _timer;
}
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (weak, nonatomic) IBOutlet UIView *salesView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *orderLable;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLable;
- (IBAction)payBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (weak, nonatomic) IBOutlet UILabel *beforePriceLable;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLable;
@property (weak, nonatomic) IBOutlet UILabel *tatolPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *payPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *hourLable;
@property (weak, nonatomic) IBOutlet UILabel *minuteLable;

@end

@implementation YT_createDate2Controller

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SALE_RefreshTable object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSNotification_PaySure object:nil];
}

- (void)refreshData
{
    [self createData];
}

- (void)viewDidLoad {//paySure
    [super viewDidLoad];
    [self createData];
    [self readOrderRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:SALE_RefreshTable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNextVc) name:NSNotification_PaySure object:nil];
}

- (void)pushNextVc
{
    YT_WS(weakSelf);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
//        [SVProgressHUD showSuccessWithStatus:@"支付成功!"];
        YT_createDate3Controller *createDate3Vc = [[YT_createDate3Controller alloc] init];
        createDate3Vc.orderID = weakSelf.orderID;
        [weakSelf.navigationController pushViewController:createDate3Vc animated:YES];
//    });
    
}

- (void)createUI
{
    self.NavTitle = @"待团队付费";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view1.layer.cornerRadius = 4.5;
    self.view2.layer.cornerRadius = 4.5;
    self.view3.layer.cornerRadius = 4.5;
    self.view4.layer.cornerRadius = 4.5;
    self.view5.layer.cornerRadius = 4.5;
    
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.tableV.showsVerticalScrollIndicator = NO;
    self.tableV.showsHorizontalScrollIndicator = NO;
    self.tableV.bounces = NO;
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSString *order = [NSString orderNumberStringWithFormat:[YT_DateOrderInfoRequestModel sharedModel].data.orderNo];
    self.orderLable.attributedText = [NSString orderNumberLableTextAttributedWithString:order];
    self.orderTimeLable.text = [YT_DateOrderInfoRequestModel sharedModel].data.orderTime;
    self.beforePriceLable.text = [YT_DateOrderInfoRequestModel sharedModel].data.price;
    self.salePriceLable.text = [YT_DateOrderInfoRequestModel sharedModel].data.discount;
    self.payPriceLable.text = [YT_DateOrderInfoRequestModel sharedModel].data.realPay;
    self.tatolPriceLable.text = [YT_DateOrderInfoRequestModel sharedModel].data.realPay;
    
    [self getOrderCancelTime];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sale)];
    [self.salesView addGestureRecognizer:tap];
    
    self.payBtn.backgroundColor = btnColor;
    
    [self.tableV reloadData];
}

//计算订单取消时间
- (void)getOrderCancelTime
{
    YT_WS(weakSelf);
    CGFloat systemTimeFloat = [YBTimeTool getTimeFloat:[YBTimeTool getSystemNowTimeString]];
    CGFloat cancelTimeFloat = [YBTimeTool getTimeFloat:[YT_DateOrderInfoRequestModel sharedModel].data.cancelTime];
    CGFloat orderCancelTime = cancelTimeFloat - systemTimeFloat;
    
    if (_timer==nil) {
        __block int timeout = orderCancelTime; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.hourLable.text = @"00";
                        weakSelf.minuteLable.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;

                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                        if (hours<10) {
                            weakSelf.hourLable.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            weakSelf.hourLable.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10) {
                            weakSelf.minuteLable.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            weakSelf.minuteLable.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        
                    });
                    timeout--;
                    if (timeout <= 0) {
                        YT_createDate23Controller *createDate23Vc = [[YT_createDate23Controller alloc] init];
                        createDate23Vc.orderID = weakSelf.orderID;
                        [weakSelf.navigationController pushViewController:createDate23Vc animated:YES];
                    }
                }
            });
            dispatch_resume(_timer);
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

- (void)sale
{
    YT_salesController *salesVc = [[YT_salesController alloc] init];
    salesVc.orderId = self.orderID;
    [self.navigationController pushViewController:salesVc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollV.contentSize = CGSizeMake(ScreenWidth, 600);
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

- (IBAction)payBtnClick:(id)sender
{
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"interviewPay";
    
    NSDictionary *params = @{@"orderId":self.orderID};
    [self sendPayRequest:params andAppScheme:appScheme];
}

- (void)sendPayRequest:(NSDictionary *)params andAppScheme:(NSString *)appScheme
{
    YT_WS(weakSelf);
    __block NSString *orderString = nil;
    
    [YBHttpNetWorkTool post:Url_AliPay_Signiture params:params success:^(id json) {
        
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            orderString = json[@"data"][@"content"];
            //调用支付宝
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                
                NSInteger status = [resultDic[@"resultStatus"] integerValue];
                if (status == 9000) {
                    YT_createDate3Controller *createDate3Vc = [[YT_createDate3Controller alloc] init];
                    createDate3Vc.orderID = weakSelf.orderID;
                    [weakSelf.navigationController pushViewController:createDate3Vc animated:YES];
                }
                
            }];
            
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:@"正在提交..."];
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
