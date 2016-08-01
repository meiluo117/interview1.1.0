//
//  YT_TalkpriceViewController.m
//  interview
//
//  Created by 于波 on 16/3/25.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_TalkpriceViewController.h"
#import "YT_SetPriceController.h"
#import "UIButton+YBExtension.h"
#import "YT_InvestorIntroduceController.h"
#import "YT_SetCreateInfoCell.h"
#import "YT_TabBarController.h"

@interface YT_TalkpriceViewController ()
@property (nonatomic,strong)NSMutableArray *titleArray;
@end

@implementation YT_TalkpriceViewController

- (NSMutableArray *)titleArray
{
    if (nil == _titleArray) {
        self.titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arr = @[@[@"约谈价格"],@[@"自我介绍"]];
    self.titleArray = [NSMutableArray arrayWithArray:arr];
    [self createUI];
    [self createFootView];
}

- (void)createFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    footView.backgroundColor = bgColor;
    self.tableView.tableFooterView = footView;
    
    UIButton *finishBtn = [UIButton greenBtnWithTarget:self Action:@selector(finishBtnClick:) btnTitle:@"完成" btnX:20 btnY:20 andBtnWidth:ScreenWidth - 40];
    [footView addSubview:finishBtn];
}

- (void)createUI
{
    self.navigationItem.title = @"约谈价格";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
}

- (void)finishBtnClick:(UIButton *)btn
{
    UITabBarController *tabBar = [[YT_TabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBar;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *setCreateInfo = @"setCreateInfo";

    YT_SetCreateInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:setCreateInfo];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YT_SetCreateInfoCell" owner:self options:nil] lastObject];
    }

    cell.titleLable.text = self.titleArray[indexPath.section][indexPath.row];
    if (indexPath.section == 1) {
        cell.infoLable.text = @"让创业者更了解您";
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.titleArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        YT_SetPriceController *setPriceVc = [[YT_SetPriceController alloc] init];
        [self.navigationController pushViewController:setPriceVc animated:YES];
    }else if (indexPath.section == 1){
        YT_InvestorIntroduceController *investorIntroduceVc = [[YT_InvestorIntroduceController alloc] init];
        [self.navigationController pushViewController:investorIntroduceVc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

@end
