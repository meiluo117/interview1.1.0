//
//  YT_HomeController.m
//  interview
//
//  Created by 于波 on 16/3/20.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_HomeController.h"
#import "YBAdvertScrollView.h"
#import "YT_HomeCell.h"
#import "YBSearchBar.h"
#import "YT_SearchController.h"
#import "YT_HomeTableCell.h"
#import "YT_ResponseModel.h"
#import "YT_DataModel.h"
#import "YT_ItemModel.h"
#import "YT_IndustryModel.h"
#import <MJExtension.h>
#import "YT_DetailsHomeWebController.h"
#import "YT_HomePictureRequest.h"
#import "YT_HomePicDataModel.h"
#import "YT_HomePicListModel.h"
#import "YT_NavigationController.h"
#import "YT_dateInfoController.h"
#import "YT_CommonConstList.h"
#import "YT_AboutApp.h"
#import "AppDelegate.h"
#import "YT_Enum.h"
#import "YT_AllOrderClass.h"

@interface YT_HomeController ()<jumpAdvertWebViewDelegate>

@property (nonatomic,strong)NSMutableArray *hotInvestorsDataArray;
@property (nonatomic,strong)NSMutableArray *advertDataArray;
@property (nonatomic,strong)NSMutableArray *advertDataPictureArray;
/**设置页面网址的页数*/
@property (nonatomic,assign)int page;
@end

@implementation YT_HomeController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    YT_WS(weakSelf);
//    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    if (app.userInfoDict != nil) {
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            //判断消息类型是广播还单播
//            NSInteger status_remotePushType = [app.userInfoDict[@"type"] integerValue];
//            if (status_remotePushType == 1) {//单播
//                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                BOOL isCreate = [[userDefaults objectForKey:USER_ID] isEqualToString:@"chuangye"];
//                isCreate ? [weakSelf pushCreateOrderVc:app.userInfoDict] : [weakSelf pushInvestorOrderVc:app.userInfoDict];
//            }else if (status_remotePushType == 2){
//                if (![app.userInfoDict[@"url"] isEqualToString:@""]) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:app.userInfoDict[@"url"]]];
//                }
//            }
//            app.userInfoDict = nil;//清空推送消息
//        });
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = bgColor;
    [self createData];
    [self createSearchBar];
    //添加约谈价格改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:PriceChange object:nil];
}

- (void)refreshTableView
{
    [self loadNewData];
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
    
    [self loadHomePicture];
    
    [self sendHomeRequestWithUrl:Url_Home page:self.page andIsNewData:YES];
}

- (void)loadMoreData
{
    self.page ++;
    [self sendHomeRequestWithUrl:Url_Home page:self.page andIsNewData:NO];
}

- (void)sendHomeRequestWithUrl:(NSString *)url page:(int)page andIsNewData:(BOOL)newData
{
    YT_WS(weakSelf);
    NSDictionary *params = @{@"page":@(page)};
    
    [YBHttpNetWorkTool post:url params:params success:^(id json) {
//        YT_LOG(@"首页数据%@",json);
        
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

//首页轮播图
- (void)loadHomePicture
{
    YT_WS(weakSelf);
    [YBHttpNetWorkTool post:Url_Home_Pic params:nil success:^(id json) {
//        YT_LOG(@"首页轮播图%@",json);
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            [weakSelf.advertDataArray removeAllObjects];
            [weakSelf.advertDataPictureArray removeAllObjects];
            
            YT_HomePictureRequest *model = [YT_HomePictureRequest mj_objectWithKeyValues:json];
            for (YT_HomePicListModel *listModel in model.data.list) {
                [weakSelf.advertDataArray addObject:listModel];
                [weakSelf.advertDataPictureArray addObject:listModel.backImage];
            }
            [weakSelf createAdvert];
        }else{
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSError *error) {
        
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

- (void)createAdvert
{
    NSArray *advArray = [self.advertDataPictureArray copy];
    YBAdvertScrollView *scrollView = [[YBAdvertScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 230) andDataSource:advArray];
    scrollView.advArr = advArray;
    scrollView.advertDelegate = self;
    self.tableView.tableHeaderView = scrollView;
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
        [cell layoutIfNeeded];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YT_ItemModel *model = self.hotInvestorsDataArray[indexPath.row];
    YT_DetailsHomeWebController *investorDetailVc = [[YT_DetailsHomeWebController alloc] init];
    investorDetailVc.userID = model.userId;
    investorDetailVc.model = model;
    [self.navigationController pushViewController:investorDetailVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PriceChange object:nil];
}

#pragma mark - 懒加载
- (NSMutableArray *)hotInvestorsDataArray
{
    if (nil == _hotInvestorsDataArray) {
        self.hotInvestorsDataArray = [NSMutableArray array];
    }
    return _hotInvestorsDataArray;
}
- (NSMutableArray *)advertDataArray
{
    if (nil == _advertDataArray) {
        self.advertDataArray = [NSMutableArray array];
    }
    return _advertDataArray;
}
- (NSMutableArray *)advertDataPictureArray
{
    if (nil == _advertDataPictureArray) {
        self.advertDataPictureArray = [NSMutableArray array];
    }
    return _advertDataPictureArray;
}

#pragma mark - jumpAdvertWebViewDelegate
- (void)tapPicIndexID:(NSInteger)advertID
{
    YT_LOG(@"======%ld",(long)advertID);
    if (self.advertDataArray.count > 0) { //防崩溃
        YT_ItemModel *model = self.advertDataArray[advertID];
        YT_DetailsHomeWebController *investorDetailVc = [[YT_DetailsHomeWebController alloc] init];
        investorDetailVc.userID = model.userId;
        investorDetailVc.model = model;
        [self.navigationController pushViewController:investorDetailVc animated:YES];
    }
}

@end
