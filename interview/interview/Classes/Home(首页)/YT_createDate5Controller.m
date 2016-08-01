//
//  YT_createDate5Controller.m
//  interview
//
//  Created by Mickey on 16/5/13.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_createDate5Controller.h"
#import "CWStarRateView.h"
#import "UIButton+YBExtension.h"
#import "YT_Enum.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_DateOrderInfoRequestModel.h"
#import "YT_DateOrderInfoDataModel.h"
#import "YT_DateOrderInfoIndustryListModel.h"
#import <MJExtension.h>
#import "YT_DateOrder2Cell.h"
#import "YT_DetailsHomeWebController.h"
#import "NSString+YBExtension.h"
#import "YT_ItemModel.h"
#import "YT_CreateDateTableController.h"

@interface YT_createDate5Controller ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (strong, nonatomic) CWStarRateView *starRateView;
@property (weak,nonatomic) UILabel *starDescriptionLable;
@property (weak,nonatomic) UILabel *commentTextLable;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *orderLable;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *datePlaceLable;
@property (weak, nonatomic) IBOutlet UITableView *tableV;

@end

@implementation YT_createDate5Controller

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollV.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(self.commentTextLable.frame) + 50);
}

- (void)createUI
{
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
    self.dateTimeLable.text = [YT_DateOrderInfoRequestModel sharedModel].data.time;
    self.datePlaceLable.text = [YT_DateOrderInfoRequestModel sharedModel].data.address;
    
    self.NavTitle = @"已评价";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat starX = (ScreenWidth - 270) / 2;
    self.starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(starX, 460, 270, 40) numberOfStars:5];
    self.starRateView.allowIncompleteStar = NO;
    self.starRateView.hasAnimation = YES;
//    self.starRateView.delegate = self;
    NSString *star = [YT_DateOrderInfoRequestModel sharedModel].data.orderEvaluateStar;
    self.starRateView.scorePercent = [YT_Enum starNumber:[star integerValue]];
    [self.scrollV addSubview:self.starRateView];
    
    //星星遮盖
    UIView *cover = [[UIView alloc] init];
    cover.frame = self.starRateView.frame;
    cover.backgroundColor = [UIColor clearColor];
    [self.scrollV addSubview:cover];
    
    //评分描述
    CGFloat starDescriptionLableX = (ScreenWidth - 100) / 2;
    UILabel *starDescriptionLable = [[UILabel alloc] initWithFrame:CGRectMake(starDescriptionLableX, CGRectGetMaxY(self.starRateView.frame) + 10, 100, 20)];
    starDescriptionLable.textAlignment = NSTextAlignmentCenter;
    starDescriptionLable.textColor = titleColor;
    starDescriptionLable.font = [UIFont systemFontOfSize:14];
    starDescriptionLable.text = [YT_Enum starTitle:[star integerValue]];
    self.starDescriptionLable = starDescriptionLable;
    [self.scrollV addSubview:self.starDescriptionLable];
    
    //我的评价文字lable
    CGFloat myCommentLableX = (ScreenWidth - 100) / 2;
    UILabel *myCommentLable = [[UILabel alloc] initWithFrame:CGRectMake(myCommentLableX, CGRectGetMaxY(self.starDescriptionLable.frame) + 20, 100, 20)];
    myCommentLable.text = @"我给的评价";
    myCommentLable.textAlignment = NSTextAlignmentCenter;
    myCommentLable.textColor = YT_Color(122, 122, 122, 1);
    myCommentLable.font = [UIFont systemFontOfSize:12];
    [self.scrollV addSubview:myCommentLable];
    
    //我的评价textview
    UILabel *commentLable = [[UILabel alloc] init];
    commentLable.font = [UIFont systemFontOfSize:14];
    NSString *comment = [YT_DateOrderInfoRequestModel sharedModel].data.orderEvaluateContent;
    if (comment.length == 0) {
        commentLable.text = @"暂无评论";
    }else{
        commentLable.text = comment;
    }
    commentLable.numberOfLines = 0;
    commentLable.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSizeComment = CGSizeMake(ScreenWidth - 40, 9999);
    CGSize expectSizeComment = [commentLable sizeThatFits:maximumLabelSizeComment];
    commentLable.frame = CGRectMake(20, CGRectGetMaxY(myCommentLable.frame) + 10, expectSizeComment.width, expectSizeComment.height);
    self.commentTextLable = commentLable;
    [self.scrollV  addSubview:self.commentTextLable];
    
    [self.tableV reloadData];
}
#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - UITableViewDelegate
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

@end
