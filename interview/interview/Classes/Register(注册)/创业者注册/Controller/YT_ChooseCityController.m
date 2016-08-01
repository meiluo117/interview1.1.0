//
//  YT_ChooseCityController.m
//  interview
//
//  Created by 于波 on 16/3/26.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_ChooseCityController.h"
#import "YT_CreateItemsInfoModel.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_InvestorPersonInfoModel.h"

@interface YT_ChooseCityController ()
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,strong)NSMutableArray *pinArray;
@property (nonatomic,strong)NSDictionary *cityDict;
@property (nonatomic,copy)NSString *cityStr;

@end

@implementation YT_ChooseCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"城市选择";
    
    NSArray *cityArr = @[@[@"安徽",@"澳门"],
                     @[@"北京"],
                     @[@"重庆"],
                     @[@"福建"],
                     @[@"甘肃",@"广东",@"广西",@"贵州"],
                     @[@"河北",@"黑龙江",@"河南",@"湖北",@"湖南",@"海外",@"海南"],
                     @[@"吉林",@"江苏",@"江西"],
                     @[@"辽宁"],
                     @[@"内蒙古",@"宁夏"],
                     @[@"青海"],
                     @[@"上海",@"山西",@"陕西",@"山东",@"四川"],
                     @[@"天津",@"台湾"],
                     @[@"新疆",@"西藏",@"香港"],
                     @[@"云南"],
                     @[@"浙江"]];
    
    self.array = [NSMutableArray arrayWithArray:cityArr];
    
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
    
    NSArray *pinArr = @[@"A",@"B",@"C",@"F",@"G",@"H",@"J",@"L",@"N",@"Q",@"S",@"T",@"X",@"Y",@"Z"];
    self.pinArray = [NSMutableArray arrayWithArray:pinArr];
    
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    tableV.bounces = NO;
    tableV.showsVerticalScrollIndicator = NO;
    tableV.showsHorizontalScrollIndicator = NO;
    self.tableView = tableV;
}



#pragma mark - Table view data source
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *city = @"city";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:city];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:city];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    cell.textLabel.text = self.array[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.array[section] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.pinArray[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.pinArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YT_LOG(@"%@",self.cityDict[self.array[indexPath.section][indexPath.row]]);
    self.cityStr = self.cityDict[self.array[indexPath.section][indexPath.row]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"ID"] isEqualToString:@"chuangye"]) {
        
        NSDictionary *params = @{@"type":@"4",
                                 @"value":self.cityStr,
                                 @"projectId":[YT_CreatePersonInfoModel sharedPersonInfoModel].projectId};
        
        [self sendRequest:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket requestUrl:Url_ItemProduct_Info andParams:params];
        
    }else{
        
        NSDictionary *params = @{@"type":@"4",
                                 @"value":self.cityStr};
        
        [self sendRequest:[YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket requestUrl:Url_Set_City andParams:params];
    }
}

- (void)sendRequest:(NSString *)userTicket requestUrl:(NSString *)requestUrl andParams:(NSDictionary *)params
{
    YT_WS(weakSelf);
    
    [YBHttpNetWorkTool post:requestUrl params:params success:^(id json) {
        
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            if ([[defaults objectForKey:@"ID"] isEqualToString:@"chuangye"]) {
                
                [YT_CreatePersonInfoModel sharedPersonInfoModel].provinceId = weakSelf.cityStr;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                
                [YT_InvestorPersonInfoModel sharedPersonInfoModel].provinceId = weakSelf.cityStr;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
        }else{
            [SVProgressHUD dismiss];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        YT_LOG(@"选择城市error:%@",error);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } header:userTicket ShowWithStatusText:@"正在保存..."];
}

@end
