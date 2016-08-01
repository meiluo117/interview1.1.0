//
//  YT_InvestorController.m
//  interview
//
//  Created by 于波 on 16/3/21.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_InvestorController.h"
#import "YT_HomeCell.h"
#import "YBSearchBar.h"
#import "YT_SearchController.h"
#import "YT_HomeTableCell.h"
#import "YT_ResponseModel.h"
#import "YT_DataModel.h"
#import "YT_ItemModel.h"
#import "YT_IndustryModel.h"
#import <MJExtension.h>
#import "YT_NavigationController.h"
#import "YT_DetailsHomeWebController.h"
#import "YT_CommonConstList.h"

@interface YT_InvestorController ()
@property (nonatomic,strong)NSMutableArray *hotInvestorsDataArray;
/**设置页面网址的页数*/
@property (nonatomic,assign)int page;
@end

@implementation YT_InvestorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = bgColor;
    [self createData];
    [self createSearchBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:PriceChange object:nil];
}

- (void)refreshTableView
{
    [self loadNewData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PriceChange object:nil];
}

- (void)createData
{
    [self loadNewData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
- (void)loadNewData
{
    self.page = 1;
    [self.tableView.mj_footer endRefreshing];
    
    [self sendHomeRequestWithUrl:Url_Investor_Home page:self.page andIsNewData:YES];
}

- (void)loadMoreData
{
    self.page ++;
    [self sendHomeRequestWithUrl:Url_Investor_Home page:self.page andIsNewData:NO];
}

- (void)sendHomeRequestWithUrl:(NSString *)url page:(int)page andIsNewData:(BOOL)newData
{
    YT_WS(weakSelf);
    NSDictionary *params = @{@"page":@(page)};
    [YBHttpNetWorkTool post:url params:params success:^(id json) {
//        YT_LOG(@"投资人数据%@",json);
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            //最新数据
            if (newData) {
                [weakSelf.hotInvestorsDataArray removeAllObjects];
                
                YT_ResponseModel *model = [YT_ResponseModel mj_objectWithKeyValues:json];
                weakSelf.hotInvestorsDataArray = [NSMutableArray arrayWithArray:model.data.list];
                
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView reloadData];
            }else{//更多数据
                YT_ResponseModel *model = [YT_ResponseModel mj_objectWithKeyValues:json];
                [weakSelf.hotInvestorsDataArray addObjectsFromArray:model.data.list];
                
                NSInteger totalPage = [[YT_ResponseModel sharedModel].data.totalPage integerValue];
                
                if (weakSelf.page > totalPage) {
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [weakSelf.tableView.mj_footer endRefreshing];
                    [weakSelf.tableView reloadData];
                }
            }
        }else{
            [SVProgressHUD dismiss];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } header:@"" ShowWithStatusText:nil];
}

- (void)createSearchBar
{
    YBSearchBar *searchBar = [YBSearchBar searchBar];
    searchBar.enabled = NO;
    searchBar.x = 10;
    searchBar.width = ScreenWidth - 20;
    searchBar.height = 30;
    self.navigationItem.titleView = searchBar;
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchClick)];
    [searchBar addGestureRecognizer:searchTap];
}

- (void)searchClick
{
    
    YT_SearchController *searchVc = [[YT_SearchController alloc] init];
    YT_NavigationController *nav = [[YT_NavigationController alloc] initWithRootViewController:searchVc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hotInvestorsDataArray.count;;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"home";
    
    YT_HomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (nil == cell) {
        cell = [[YT_HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (self.hotInvestorsDataArray.count > indexPath.row) {
        cell.model = self.hotInvestorsDataArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YT_ItemModel *model = self.hotInvestorsDataArray[indexPath.row];
    YT_DetailsHomeWebController *investorDetailVc = [[YT_DetailsHomeWebController alloc] init];
    investorDetailVc.model = model;
    investorDetailVc.userID = model.userId;
    [self.navigationController pushViewController:investorDetailVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

#pragma mark - 懒加载
- (NSMutableArray *)hotInvestorsDataArray
{
    if (nil == _hotInvestorsDataArray) {
        self.hotInvestorsDataArray = [NSMutableArray array];
    }
    return _hotInvestorsDataArray;
}



@end
