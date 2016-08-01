//
//  YT_createDate4Controller.m
//  interview
//
//  Created by Mickey on 16/5/11.
//  Copyright © 2016年 于波. All rights reserved.
//
#define HTML_InvestorDetail @"http://www.talk2vc.com/wap/investor?userId=%@"
#define oneStar @"不值"
#define twoStar @"一般"
#define threeStar @"可尝试"
#define fourStar @"有所收获"
#define fiveStar @"受益匪浅"

#import "YT_createDate4Controller.h"
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
#import "YT_createDate5Controller.h"
#import "NSString+YBExtension.h"
#import "YT_ItemModel.h"
#import "HYActivityView.h"
#import <UMSocial.h>
#import "YT_OtherUrl.h"
#import "YT_CommonConstList.h"

@interface YT_createDate4Controller ()<CWStarRateViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (strong, nonatomic) CWStarRateView *starRateView;
@property (weak,nonatomic) UILabel *starDescriptionLable;
@property (weak,nonatomic) UITextView *myCommentTextView;
@property (copy,nonatomic) NSString *starNum;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UILabel *orderLable;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *datePlaceLable;
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (nonatomic, strong) HYActivityView *activityView;
@end

@implementation YT_createDate4Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self readOrderRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(push) name:SharedHide object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SharedHide object:nil];
}
- (void)push
{
    [self pushCreateDate5Controller];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollV.contentSize = CGSizeMake(ScreenWidth, 830);
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
    
    self.NavTitle = @"待团队评价";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat starX = (ScreenWidth - 270) / 2;
    self.starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(starX, 460, 270, 40) numberOfStars:5];
    self.starRateView.scorePercent = 1.0;
    self.starRateView.allowIncompleteStar = NO;
    self.starRateView.hasAnimation = YES;
    self.starRateView.delegate = self;
    [self.scrollV addSubview:self.starRateView];
    self.starNum = @"5";
    
    CGFloat starDescriptionLableX = (ScreenWidth - 100) / 2;
    UILabel *starDescriptionLable = [[UILabel alloc] initWithFrame:CGRectMake(starDescriptionLableX, CGRectGetMaxY(self.starRateView.frame) + 10, 100, 20)];
    starDescriptionLable.textAlignment = NSTextAlignmentCenter;
    starDescriptionLable.textColor = titleColor;
    starDescriptionLable.font = [UIFont systemFontOfSize:14];
    self.starDescriptionLable = starDescriptionLable;
    self.starDescriptionLable.text = [YT_Enum starDescription:self.starRateView.scorePercent];
    [self.scrollV addSubview:self.starDescriptionLable];
    
    //我的评价文字lable
    CGFloat myCommentLableX = (ScreenWidth - 100) / 2;
    UILabel *myCommentLable = [[UILabel alloc] initWithFrame:CGRectMake(myCommentLableX, CGRectGetMaxY(self.starDescriptionLable.frame) + 20, 100, 20)];
    myCommentLable.text = @"我给的评价";
    myCommentLable.textAlignment = NSTextAlignmentCenter;
    myCommentLable.textColor = YT_Color(122, 122, 122, 1);
    myCommentLable.font = [UIFont systemFontOfSize:12];
    [self.scrollV addSubview:myCommentLable];
    
    //我的评价白色view
    UIView *myCommentView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(myCommentLable.frame) + 10, ScreenWidth - 40, 150)];
    myCommentView.layer.cornerRadius = 6.0f;
    myCommentView.backgroundColor = [UIColor whiteColor];
    [self.scrollV addSubview:myCommentView];
    
    //我的评价textview
    UITextView *myCommentTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth - 40 - 10, 150 - 10)];
    myCommentTextView.textColor = [UIColor grayColor];
    myCommentTextView.font = [UIFont systemFontOfSize:14];
    myCommentTextView.returnKeyType = UIReturnKeyDone;
    myCommentTextView.delegate = self;
//    myCommentTextView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.myCommentTextView = myCommentTextView;
    [myCommentView addSubview:self.myCommentTextView];
    
    UIButton *sureBtn = [UIButton greenBtnWithTarget:self Action:@selector(sureBtnClick:) btnTitle:@"确定" btnX:20 btnY:CGRectGetMaxY(myCommentView.frame) + 20 andBtnWidth:ScreenWidth - 40];
    [self.scrollV addSubview:sureBtn];
    
    [self.tableV reloadData];
}

- (void)sureBtnClick:(UIButton *)btn
{
    NSDictionary *params = @{@"star":self.starNum,
                             @"content":self.myCommentTextView.text,
                             @"orderId":[YT_DateOrderInfoRequestModel sharedModel].data.orderId};
//    if (self.myCommentTextView.text.length == 0) {
//        [self showCommentAlert];
//    }else{
        [self sendSureRequest:params];
//    }
}

- (void)showCommentAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入评价内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 10;
    [alert show];
}

- (void)sendSureRequest:(NSDictionary *)params
{
    YT_WS(weakSelf);
    [YBHttpNetWorkTool post:Url_Date_CreateCommentDate params:params success:^(id json) {
        
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            [weakSelf showAlert];
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        YT_LOG(@"创业者提交评价和评星error:%@",error);
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:@"正在提交信息..."];
}

//分享
- (void)showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"评价成功" message:@"如您觉得投资人很赞，立刻分享给他人" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"分享", nil];
    alert.tag = 11;
    [alert show];
}

- (void)sharedApp
{
    YT_WS(weakSelf);
    if (!self.activityView) {
        self.activityView = [[HYActivityView alloc]initWithTitle:@"分享到" referView:self.view];
        
        self.activityView.HYbgColor = [UIColor whiteColor];
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 3;
        
        ButtonView *bv = [[ButtonView alloc]initWithText:@"微信好友" image:[UIImage imageNamed:@"yt_wechat"] handler:^(ButtonView *buttonView){
            //微信好友集成服务
            [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:HTML_InvestorDetail,[YT_DateOrderInfoRequestModel sharedModel].data.userId];//微信好友分享url
            [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:sharedHotInvestorTitle,[YT_DateOrderInfoRequestModel sharedModel].data.realName,[YT_DateOrderInfoRequestModel sharedModel].data.company,[YT_DateOrderInfoRequestModel sharedModel].data.position];//微信好友分享title
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[YT_DateOrderInfoRequestModel sharedModel].data.headImg]];
            UIImage *image = [UIImage imageWithData:imageData];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:sharedHotInvestorDetail image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [weakSelf pushCreateDate5Controller];
                }
            }];
            
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"QQ好友" image:[UIImage imageNamed:@"yt_qq"] handler:^(ButtonView *buttonView){
            [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:HTML_InvestorDetail,[YT_DateOrderInfoRequestModel sharedModel].data.userId];//qq好友分享url
            [UMSocialData defaultData].extConfig.qqData.title = [NSString stringWithFormat:sharedHotInvestorTitle,[YT_DateOrderInfoRequestModel sharedModel].data.realName,[YT_DateOrderInfoRequestModel sharedModel].data.company,[YT_DateOrderInfoRequestModel sharedModel].data.position];//qq好友分享title
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[YT_DateOrderInfoRequestModel sharedModel].data.headImg]];
            UIImage *image = [UIImage imageWithData:imageData];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:sharedHotInvestorDetail image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [weakSelf pushCreateDate5Controller];
                }
            }];
        }];
        [self.activityView addButtonView:bv];
        
        bv = [[ButtonView alloc]initWithText:@"朋友圈" image:[UIImage imageNamed:@"yt_wechatTime"] handler:^(ButtonView *buttonView){
            
            [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:HTML_InvestorDetail,[YT_DateOrderInfoRequestModel sharedModel].data.userId];//qq好友分享url
            [UMSocialData defaultData].extConfig.qqData.title = @"";//qq好友分享title
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[YT_DateOrderInfoRequestModel sharedModel].data.headImg]];
            UIImage *image = [UIImage imageWithData:imageData];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:sharedHotInvestorTitle,[YT_DateOrderInfoRequestModel sharedModel].data.realName,[YT_DateOrderInfoRequestModel sharedModel].data.company,[YT_DateOrderInfoRequestModel sharedModel].data.position] image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [weakSelf pushCreateDate5Controller];
                }
            }];
        }];
        [self.activityView addButtonView:bv];
    }
    [self.activityView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11) {
        if (buttonIndex == 0) {//分享取消
            [self pushCreateDate5Controller];
        }else{//分享
            [self sharedApp];
        }
    }else if (alertView.tag == 10){
    
    }
}
- (void)pushCreateDate5Controller
{
    YT_createDate5Controller *createDate5Vc = [[YT_createDate5Controller alloc] init];
    createDate5Vc.orderID = self.orderID;
    [self.navigationController pushViewController:createDate5Vc animated:YES];
}

#pragma mark - CWStarRateViewDelegate
- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent
{
    self.starDescriptionLable.text = [YT_Enum starDescription:newScorePercent*10];
    self.starNum = [YT_Enum starNum:newScorePercent*10];
    YT_LOG(@"%f",newScorePercent);
    YT_LOG(@"评价星星描述-----%@",[YT_Enum starDescription:newScorePercent*10]);
    YT_LOG(@"评价星星几个星-----%@",[YT_Enum starNum:newScorePercent*10]);
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
