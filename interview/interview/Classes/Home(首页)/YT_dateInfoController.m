//
//  YT_dateInfoController.m
//  interview
//
//  Created by Mickey on 16/5/13.
//  Copyright © 2016年 于波. All rights reserved.
//
#define explain @"您可以登录www.chuangxp.com上传商业计划书"
#import "YT_dateInfoController.h"
#import "YT_SetCreateInfoCell.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_Enum.h"
#import "UIButton+YBExtension.h"
#import "YT_ItemNameController.h"
#import "YT_ItemStepController.h"
#import "YT_ItemTagController.h"
#import "YT_ChooseCityController.h"
#import "YT_ItemExplainController.h"
#import "YT_TeamExplainController.h"
#import "YT_createDateController.h"
#import "YT_serviceWebController.h"
#import "YT_SetNameController.h"

@interface YT_dateInfoController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *tableV;
@property (strong,nonatomic) NSArray *titleArr;
@property (strong,nonatomic) NSDictionary *cityDict;
@end

@implementation YT_dateInfoController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableV reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.cityDict = @{@"北京":@"1",
                      @"上海":@"2",
                      @"广东":@"3",
                      @"天津":@"4",
                      @"重庆":@"5",
                      @"河北":@"6",
                      @"山西":@"7",
                      @"陕西":@"8",
                      @"山东":@"9",
                      @"河南":@"10",
                      @"辽宁":@"11",
                      @"吉林":@"12",
                      @"江苏":@"13",
                      @"浙江":@"14",
                      @"安徽":@"15",
                      @"江西":@"16",
                      @"福建":@"17",
                      @"湖北":@"18",
                      @"湖南":@"19",
                      @"四川":@"20",
                      @"贵州":@"21",
                      @"云南":@"22",
                      @"海南":@"23",
                      @"黑龙江":@"24",
                      @"甘肃":@"25",
                      @"青海":@"26",
                      @"广西":@"27",
                      @"宁夏":@"28",
                      @"内蒙古":@"29",
                      @"新疆":@"30",
                      @"西藏":@"31",
                      @"台湾":@"32",
                      @"香港":@"33",
                      @"澳门":@"34",
                      @"海外":@"35"};
    
    self.titleArr = @[@[@"真实姓名",@"项目名称",@"项目阶段",@"行业标签",@"所在地区"],@[@"简单介绍您的项目",@"简单介绍您的团队"],@[@"项目商业计划书"]];
    
    self.NavTitle = @"填写预约信息";
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.bounces = NO;
    tableV.showsVerticalScrollIndicator = NO;
    tableV.showsHorizontalScrollIndicator = NO;
    self.tableV = tableV;
    [self.view addSubview:self.tableV];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    footView.backgroundColor = YT_Color(239, 239, 244, 1);
    self.tableV.tableFooterView = footView;
    
    UIButton *finishBtn = [UIButton greenBtnWithTarget:self Action:@selector(submit:) btnTitle:@"提交" btnX:20 btnY:10 andBtnWidth:ScreenWidth - 40];
    [footView addSubview:finishBtn];
}

- (void)submit:(UIButton *)btn
{
    if ([YT_CreatePersonInfoModel sharedPersonInfoModel].name.length == 0 || [YT_CreatePersonInfoModel sharedPersonInfoModel].stage.length == 0 || [YT_CreatePersonInfoModel sharedPersonInfoModel].provinceId.length == 0 || [YT_CreatePersonInfoModel sharedPersonInfoModel].itemTag.length == 0) {
        [self showAlertTitle:@"提示" andDetail:@"请填写（必填）项"];
    }else{
        [self sendSubmitRequest];
    }
}

- (void)sendSubmitRequest
{
    YT_WS(weakSelf);
    //?projectId=1110&projectName=测试流程&city=1&industry=1&stage=1&logo=23123&url&introduce=介绍&apntTeamIntro=团队信息
    if ([YT_CreatePersonInfoModel sharedPersonInfoModel].introduce.length == 0) {
        [YT_CreatePersonInfoModel sharedPersonInfoModel].introduce = @"";
    }
    if ([YT_CreatePersonInfoModel sharedPersonInfoModel].apntTeamIntro.length == 0) {
        [YT_CreatePersonInfoModel sharedPersonInfoModel].apntTeamIntro = @"";
    }
    if ([YT_CreatePersonInfoModel sharedPersonInfoModel].logo.length == 0) {
        [YT_CreatePersonInfoModel sharedPersonInfoModel].logo = @"";
    }
    
    NSDictionary *params = @{@"projectId":[YT_CreatePersonInfoModel sharedPersonInfoModel].projectId,
                             @"projectName":[YT_CreatePersonInfoModel sharedPersonInfoModel].name,
                             @"city":[YT_CreatePersonInfoModel sharedPersonInfoModel].provinceId,
                             @"industry":[YT_CreatePersonInfoModel sharedPersonInfoModel].itemTag,
                             @"stage":[YT_CreatePersonInfoModel sharedPersonInfoModel].stage,
                             @"logo":[YT_CreatePersonInfoModel sharedPersonInfoModel].logo,
                             @"url":@"",
                             @"introduce":[YT_CreatePersonInfoModel sharedPersonInfoModel].introduce,
                             @"apntTeamIntro":[YT_CreatePersonInfoModel sharedPersonInfoModel].apntTeamIntro,
                             @"bp":@"",
                             @"bpName":@"",
                             @"investorId":self.userId,
                             @"logo":[YT_CreatePersonInfoModel sharedPersonInfoModel].logo};
    
    [YBHttpNetWorkTool post:Url_Date_CreateItem params:params success:^(id json) {
        YT_LOG(@"约见约见:%@",json);
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:json[@"msg"]];
            YT_createDateController *Vc = [[YT_createDateController alloc] init];
            Vc.orderID = json[@"data"][@"orderId"];
            [weakSelf.navigationController pushViewController:Vc animated:YES];
            
            YT_LOG(@"提交全部项目信息json:%@",json);
        }else{
            YT_LOG(@"提交全部项目信息%@",json[@"msg"]);
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        YT_LOG(@"提交全部项目信息error:%@",error);
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:@"正在提交信息..."];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.titleArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * setCreateInfo = @"setCreateInfo";
    
    YT_SetCreateInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:setCreateInfo];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YT_SetCreateInfoCell" owner:self options:nil] lastObject];
    }
    cell.titleLable.text = self.titleArr[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.infoLable.text = [YT_CreatePersonInfoModel sharedPersonInfoModel].realName;
//            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }else if (indexPath.row == 1) {
            cell.infoLable.text = [YT_CreatePersonInfoModel sharedPersonInfoModel].name;
            if (cell.infoLable.text.length == 0) {//项目名称
                cell.infoLable.text = @"(必填)";
            }
        }else if (indexPath.row == 2){//项目阶段
            cell.infoLable.text = [YT_Enum productItemStatus:[[YT_CreatePersonInfoModel sharedPersonInfoModel].stage integerValue]];
            if (cell.infoLable.text.length == 2) {
                cell.infoLable.text = @"(必填)";
            }
        }else if (indexPath.row == 3){
            cell.infoLable.text = [YT_CreatePersonInfoModel sharedPersonInfoModel].itemTagTitle;
            if (cell.infoLable.text.length == 0) {//行业标签
                cell.infoLable.text = @"(必填)";
            }
        }else if (indexPath.row == 4){
            cell.infoLable.text = [YT_Enum productCityStatus:[[YT_CreatePersonInfoModel sharedPersonInfoModel].provinceId integerValue]];
            if (cell.infoLable.text.length == 0) {//地区
                cell.infoLable.text = @"(必填)";
            }
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.infoLable.text = [YT_CreatePersonInfoModel sharedPersonInfoModel].introduce;

        }else if (indexPath.row == 1){//介绍您的团队
            cell.infoLable.text = [YT_CreatePersonInfoModel sharedPersonInfoModel].apntTeamIntro;
        }
    }else if (indexPath.section == 2){
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//真实姓名
            YT_SetNameController *setNameVc = [[YT_SetNameController alloc] init];
            [self.navigationController pushViewController:setNameVc animated:YES];
        }else if (indexPath.row == 1){//项目名称
            YT_ItemNameController *itemNameVc = [[YT_ItemNameController alloc] init];
            [self.navigationController pushViewController:itemNameVc animated:YES];
        }else if (indexPath.row == 2){//项目阶段
            YT_ItemStepController *itemStepVc = [[YT_ItemStepController alloc] init];
            [self.navigationController pushViewController:itemStepVc animated:YES];
        }else if (indexPath.row == 3){//行业标签
            YT_ItemTagController *itemTagVc = [[YT_ItemTagController alloc] init];
            [self.navigationController pushViewController:itemTagVc animated:YES];
        }else if (indexPath.row == 4){//所在地区
            YT_ChooseCityController *chooseCity = [[YT_ChooseCityController alloc] init];
            [self.navigationController pushViewController:chooseCity animated:YES];
        }
    }else if (indexPath.section == 2){//商业计划书
        
        YT_serviceWebController *upBPVc = [[YT_serviceWebController alloc] init];
        upBPVc.navTitle = @"上传方法";
        upBPVc.url = Url_UpBP;
        [self.navigationController pushViewController:upBPVc animated:YES];
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {//简单介绍您的项目
            YT_ItemExplainController *itemExplainVc = [[YT_ItemExplainController alloc] init];
            [self.navigationController pushViewController:itemExplainVc animated:YES];
        }else if (indexPath.row == 1){//简单介绍您的团队
            YT_TeamExplainController *teamExplainVc = [[YT_TeamExplainController alloc] init];
            [self.navigationController pushViewController:teamExplainVc animated:YES];
        }
    }
}

//必填alert
- (void)showAlertTitle:(NSString *)title andDetail:(NSString *)detail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:detail delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
