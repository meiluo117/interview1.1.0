//
//  YT_InvestorDateTableController.m
//  interview
//
//  Created by Mickey on 16/5/25.
//  Copyright © 2016年 于波. All rights reserved.
//
#define ScrollViewHeight ScreenHeight - 130
#import "YT_InvestorDateTableController.h"
#import "UIButton+YBExtension.h"
#import "YT_InvestorForMeDateCell.h"
#import "YT_listDateInvestorRequestModel.h"
#import "YT_listDateInvestorDataModel.h"
#import "YT_listDateInvestorListModel.h"
#import "YT_InvestorPersonInfoModel.h"
#import <MJExtension.h>
#import "YT_CommonConstList.h"
#import "YT_AllOrderClass.h"
#import "YT_dateInfoController.h"
#import "YBDotView.h"

@interface YT_InvestorDateTableController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak)UIButton *waitDateBtn;
@property (nonatomic,weak)UIButton *finishDateBtn;
@property (nonatomic,weak)UIScrollView *scrollV;
@property (nonatomic,weak)UITableView *tableViewWait;
@property (nonatomic,weak)UITableView *tableViewFisish;
@property (nonatomic,strong)NSMutableArray *dataArrayWait;
@property (nonatomic,strong)NSMutableArray *dataArrayFinish;
@property (nonatomic,assign)int page;
@property (strong,nonatomic) YBDotView *dot;
@end

@implementation YT_InvestorDateTableController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshTable];
}

- (void)tableFooterEndRefreshing
{
    [self.tableViewWait.mj_footer endRefreshing];
    [self.tableViewFisish.mj_footer endRefreshing];
}
- (void)tableHeaderEndRefreshing
{
    [self.tableViewWait.mj_header endRefreshing];
    [self.tableViewFisish.mj_header endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    [self loadWaitNewData];
    [self createUI];
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable) name:RefreshDataTable object:nil];
    
    self.tableViewWait.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadWaitNewData)];
    self.tableViewFisish.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFinishNewData)];
    
    self.tableViewWait.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadWaitMoreData)];
    self.tableViewFisish.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFinishMoreData)];
}

- (void)refreshTable
{
    if (self.scrollV.contentOffset.x == 0) {
        [self.dataArrayWait removeAllObjects];
        [self loadWaitNewData];
    }else{
        [self.dataArrayFinish removeAllObjects];
        [self loadFinishNewData];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshDataTable object:nil];
}

- (void)loadWaitNewData
{
    self.page = 1;
    [self tableFooterEndRefreshing];
    NSDictionary *params = @{@"type":@"2",@"status":@"1",@"page":@(self.page)};
    [self sendDataTableRequest:params andIsNewData:YES];
}
- (void)loadFinishNewData
{
    self.page = 1;
    [self tableFooterEndRefreshing];
    NSDictionary *params = @{@"type":@"2",@"status":@"2",@"page":@(self.page)};
    [self sendDataTableRequest:params andIsNewData:YES];
}
- (void)loadWaitMoreData
{
    self.page ++;
    [self tableHeaderEndRefreshing];
    NSDictionary *params = @{@"type":@"2",@"status":@"1",@"page":@(self.page)};
    [self sendDataTableRequest:params andIsNewData:NO];
}
- (void)loadFinishMoreData
{
    self.page ++;
    [self tableHeaderEndRefreshing];
    NSDictionary *params = @{@"type":@"2",@"status":@"2",@"page":@(self.page)};
    [self sendDataTableRequest:params andIsNewData:NO];
}

- (void)sendDataTableRequest:(NSDictionary *)params andIsNewData:(BOOL)isNewData
{
    YT_WS(weakSelf);
    NSInteger statusCreate = [params[@"status"] integerValue];
    
    [YBHttpNetWorkTool post:Url_Date_list params:params success:^(id json) {
        NSInteger status = [json[@"code"] integerValue];
        YT_LOG(@"%@",json);
        if (status == 1) {
            [SVProgressHUD dismiss];
            [YT_listDateInvestorRequestModel mj_objectWithKeyValues:json];
            //创建小红点
            [weakSelf waitBtnIsShowDotWithIfNotice];
            [weakSelf finishBtnIsShowDotWithIfNotice];
            
            NSInteger totalPage = [[YT_listDateInvestorRequestModel sharedModel].data.totalPage integerValue];
            if (isNewData) {//最新数据
                
                if (statusCreate == 1) {
                    if (weakSelf.page == totalPage || totalPage == 0) {
                        YT_LOG(@"weakSelf.dataArrayWait.count??????%lu",(unsigned long)weakSelf.dataArrayWait.count);
                        [weakSelf.tableViewWait.mj_footer endRefreshingWithNoMoreData];
                    }
                    
                    [weakSelf.dataArrayWait removeAllObjects];
                    weakSelf.dataArrayWait = [NSMutableArray arrayWithArray:[YT_listDateInvestorRequestModel sharedModel].data.list];
                    [weakSelf tableHeaderEndRefreshing];
                    [weakSelf.tableViewWait reloadData];
                    
                }else if (statusCreate == 2){
                    if (weakSelf.page == totalPage || totalPage == 0) {
                        YT_LOG(@"weakSelf.dataArrayFinish.count??????%lu",(unsigned long)weakSelf.dataArrayFinish.count);
                        [weakSelf.tableViewFisish.mj_footer endRefreshingWithNoMoreData];
                    }
                    [weakSelf.dataArrayFinish removeAllObjects];
                     weakSelf.dataArrayFinish = [NSMutableArray arrayWithArray:[YT_listDateInvestorRequestModel sharedModel].data.list];
                     [weakSelf tableHeaderEndRefreshing];
                     [weakSelf.tableViewFisish reloadData];
                }
            }else{//更多数据
                if (statusCreate == 1) {
                    
                    if (weakSelf.page > totalPage) {
                        [weakSelf.tableViewWait.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [weakSelf.dataArrayWait addObjectsFromArray:[YT_listDateInvestorRequestModel sharedModel].data.list];
                        [weakSelf tableFooterEndRefreshing];
                        [weakSelf.tableViewWait reloadData];
                    }
                    
                }else if (statusCreate == 2){
                    
                    if (weakSelf.page > totalPage) {
                        [weakSelf.tableViewFisish.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [weakSelf.dataArrayFinish addObjectsFromArray:[YT_listDateInvestorRequestModel sharedModel].data.list];
                        [weakSelf tableFooterEndRefreshing];
                        [weakSelf.tableViewFisish reloadData];
                    }
                }
            }
            
        }else{
            [SVProgressHUD dismiss];
            [weakSelf tableHeaderEndRefreshing];
            [weakSelf tableFooterEndRefreshing];
        }
        
    } failure:^(NSError *error) {
        [weakSelf tableHeaderEndRefreshing];
        [weakSelf tableFooterEndRefreshing];
    } header:[YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:nil];
}

- (void)createTableView
{
    for (int i = 0; i < 2; i ++) {
        UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScrollViewHeight) style:UITableViewStylePlain];
        tableV.tag = i + 100;
        tableV.delegate = self;
        tableV.dataSource = self;
        tableV.backgroundColor = bgColor;
        tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.scrollV addSubview:tableV];
    }
    self.tableViewWait = (UITableView *)[self.view viewWithTag:100];
    self.tableViewFisish = (UITableView *)[self.view viewWithTag:101];
}

- (void)createUI
{
    self.NavTitle = @"约我的团队";
    
    float w = ScreenWidth / 2;
    UIButton *waitDateBtn = [UIButton dateBtnWithTarget:self Action:@selector(waitDateBtnClick:) btnTitle:@"待约谈" andBtnFrame:CGRectMake(w - 100, 84, 100, 30)];
    waitDateBtn.selected = YES;
    self.waitDateBtn = waitDateBtn;
    [self.view addSubview:self.waitDateBtn];
    
    UIButton *finishDateBtn = [UIButton dateBtnWithTarget:self Action:@selector(finishDateBtnClick:) btnTitle:@"已结束" andBtnFrame:CGRectMake(w + 10, 84, 100, 30)];
    self.finishDateBtn = finishDateBtn;
    [self.view addSubview:self.finishDateBtn];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 130, ScreenWidth, ScrollViewHeight)];
    scrollView.contentOffset = CGPointZero;
    scrollView.contentSize = CGSizeMake(2 * ScreenWidth, 130);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.tag = 102;
    scrollView.backgroundColor = bgColor;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    self.scrollV = scrollView;
    [self.view addSubview:self.scrollV];
    
}

- (void)waitDateBtnClick:(UIButton *)btn
{
    btn.selected = YES;
    [self getWaitScrollView];
    if (btn.selected) {
        self.finishDateBtn.selected = NO;
    }
}
- (void)finishDateBtnClick:(UIButton *)btn
{
    btn.selected = YES;
    [self getFinishScrollView];
    if (btn.selected) {
        self.waitDateBtn.selected = NO;
    }
}

- (void)getWaitScrollView
{
    if (self.scrollV.contentOffset.x == ScreenWidth) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollV.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            
            //            YT_LOG(@"刷新wait");
        }];
    }
}
- (void)getFinishScrollView
{
    if (self.scrollV.contentOffset.x == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollV.contentOffset = CGPointMake(ScreenWidth, 0);
        } completion:^(BOOL finished) {
            
            //            YT_LOG(@"刷新finish");
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 102) {
        YT_LOG(@"这是scrollview滑动事件scrollViewDidScroll");
        if (scrollView.contentOffset.x == ScreenWidth) {
            self.finishDateBtn.selected = YES;
            self.waitDateBtn.selected = NO;
            YT_LOG(@"刷新finish tableview");
            //刷新
            [self loadFinishNewData];
            
        }else if (scrollView.contentOffset.x == 0){
            self.waitDateBtn.selected = YES;
            self.finishDateBtn.selected = NO;
            YT_LOG(@"刷新wait tableview");
            //刷新
            [self loadWaitNewData];
        }
    }
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 100) {
        return self.dataArrayWait.count;
    }else{
        return self.dataArrayFinish.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *wait = @"wait";
    YT_InvestorForMeDateCell *cell = [tableView dequeueReusableCellWithIdentifier:wait];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YT_InvestorForMeDateCell" owner:self options:nil] lastObject];
    }
    if (tableView.tag == 100) {
        if (self.dataArrayWait.count > indexPath.row) {
            cell.model = self.dataArrayWait[indexPath.row];
        }
    }else{
        if (self.dataArrayFinish.count > indexPath.row) {
            cell.model = self.dataArrayFinish[indexPath.row];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _tableViewWait) {
        
        YT_listDateInvestorListModel *model = self.dataArrayWait[indexPath.row];
        NSInteger status = [model.orderStatus integerValue];
        if (status == 1) {
            YT_investorDateController *Vc1 = [[YT_investorDateController alloc] init];
            Vc1.orderID = model.orderId;
            [self.navigationController pushViewController:Vc1 animated:YES];
            
        }else if (status == 2){
            YT_investorDate2Controller *Vc2 = [[YT_investorDate2Controller alloc] init];
            Vc2.orderID = model.orderId;
            [self.navigationController pushViewController:Vc2 animated:YES];
        }else if (status == 3){
            YT_investorDate3Controller *Vc3 = [[YT_investorDate3Controller alloc] init];
            Vc3.orderID = model.orderId;
            [self.navigationController pushViewController:Vc3 animated:YES];
        }
        
    }else{
        YT_listDateInvestorListModel *model = self.dataArrayFinish[indexPath.row];
        NSInteger status = [model.orderStatus integerValue];
        if (status == 4) {
            YT_investorDate4Controller *Vc4 = [[YT_investorDate4Controller alloc] init];
            Vc4.orderID = model.orderId;
            [self.navigationController pushViewController:Vc4 animated:YES];
            
        }else if (status == 5) {
            YT_investorDate5Controller *Vc5 = [[YT_investorDate5Controller alloc] init];
            Vc5.orderID = model.orderId;
            [self.navigationController pushViewController:Vc5 animated:YES];
            
        }else if (status == 22){
            YT_investorDate22Controller *Vc22 = [[YT_investorDate22Controller alloc] init];
            Vc22.orderID = model.orderId;
            [self.navigationController pushViewController:Vc22 animated:YES];
            
        }else if (status == 23){
            YT_investorDate23Controller *Vc23 = [[YT_investorDate23Controller alloc] init];
            Vc23.orderID = model.orderId;
            [self.navigationController pushViewController:Vc23 animated:YES];
        }
    }
}

//btn是否显示红点
- (void)waitBtnIsShowDotWithIfNotice
{
    self.dot = [[YBDotView alloc] init];
    self.dot.x = 80;
    self.dot.y = (30 - 8) / 2;
    if ([[YT_listDateInvestorRequestModel sharedModel].data.ifNotice1 isEqualToString:@"true"]) {
        [self.dot showDotWithView:self.waitDateBtn];
    }else{
        [self.dot removeDotWithView:self.waitDateBtn];
    }
}
- (void)finishBtnIsShowDotWithIfNotice
{
    self.dot = [[YBDotView alloc] init];
    self.dot.x = 80;
    self.dot.y = (30 - 8) / 2;
    if ([[YT_listDateInvestorRequestModel sharedModel].data.ifNotice2 isEqualToString:@"true"]) {
        [self.dot showDotWithView:self.finishDateBtn];
    }else{
        [self.dot removeDotWithView:self.finishDateBtn];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArrayWait
{
    if (nil == _dataArrayWait) {
        self.dataArrayWait = [NSMutableArray array];
    }
    return _dataArrayWait;
}
- (NSMutableArray *)dataArrayFinish
{
    if (nil == _dataArrayFinish) {
        self.dataArrayFinish = [NSMutableArray array];
    }
    return _dataArrayFinish;
}

@end
