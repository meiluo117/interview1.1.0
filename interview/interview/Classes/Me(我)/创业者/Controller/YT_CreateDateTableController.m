//
//  YT_CreateDateTableController.m
//  interview
//
//  Created by Mickey on 16/5/25.
//  Copyright © 2016年 于波. All rights reserved.
//
#define BtnW 90 //按钮的宽度
#define ScrollViewHeight ScreenHeight - 130
#import "YT_CreateDateTableController.h"
#import "UIButton+YBExtension.h"
#import "YT_CreateDateCell.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_listCreateRequestModel.h"
#import "YT_listCreateDataModel.h"
#import "YT_listCreateListModel.h"
#import "YT_listCreateIndustryListModel.h"
#import <MJExtension.h>
#import "YT_AllOrderClass.h"
#import "YBDotView.h"
#import "YT_CommonConstList.h"

@interface YT_CreateDateTableController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak)UIButton *waitDateBtn;
@property (nonatomic,weak)UIButton *finishDateBtn;
@property (nonatomic,weak)UIButton *commentDateBtn;
@property (nonatomic,weak)UITableView *tableViewWait;
@property (nonatomic,weak)UITableView *tableViewFisish;
@property (nonatomic,weak)UITableView *tableViewComment;
@property (nonatomic,strong)NSMutableArray *dataArrayWait;
@property (nonatomic,strong)NSMutableArray *dataArrayFinish;
@property (nonatomic,strong)NSMutableArray *dataArrayComment;
@property (nonatomic,weak)UIScrollView *scrollV;
@property (nonatomic,assign)int page;
@property (strong,nonatomic) YBDotView *dot;
@end

@implementation YT_CreateDateTableController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshTable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    [self loadWaitNewData];
    [self createUI];
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable) name:RefreshDataTable object:nil];
    
    self.tableViewWait.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadWaitNewData)];
    self.tableViewComment.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadCommentNewData)];
    self.tableViewFisish.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFinishNewData)];

    self.tableViewWait.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadWaitMoreData)];
    self.tableViewComment.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadCommentMoreData)];
    self.tableViewFisish.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadFinishMoreData)];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshDataTable object:nil];
}

- (void)refreshTable
{
    if (self.scrollV.contentOffset.x == 0) {
        [self loadWaitNewData];
        
    }else if (self.scrollV.contentOffset.x == ScreenWidth){
        [self loadCommentNewData];
        
    }else if (self.scrollV.contentOffset.x == ScreenWidth*2){
        [self loadFinishNewData];
    }
}

- (void)loadWaitNewData
{
    self.page = 1;
    [self tableFooterEndRefreshing];
    NSDictionary *params = @{@"type":@"1",@"status":@"1",@"page":@(self.page)};
    [self sendDataTableRequest:params andIsNewData:YES];
}
- (void)loadCommentNewData
{
    self.page = 1;
    [self tableFooterEndRefreshing];
    NSDictionary *params = @{@"type":@"1",@"status":@"2",@"page":@(self.page)};
    [self sendDataTableRequest:params andIsNewData:YES];
}
- (void)loadFinishNewData
{
    self.page = 1;
    [self tableFooterEndRefreshing];
    NSDictionary *params = @{@"type":@"1",@"status":@"3",@"page":@(self.page)};
    [self sendDataTableRequest:params andIsNewData:YES];
}

- (void)loadWaitMoreData
{
    self.page ++;
    [self tableHeaderEndRefreshing];
    NSDictionary *params = @{@"type":@"1",@"status":@"1",@"page":@(self.page)};
    [self sendDataTableRequest:params andIsNewData:NO];
}
- (void)loadCommentMoreData
{
    self.page ++;
    [self tableHeaderEndRefreshing];
    NSDictionary *params = @{@"type":@"1",@"status":@"2",@"page":@(self.page)};
    [self sendDataTableRequest:params andIsNewData:NO];
}
- (void)loadFinishMoreData
{
    self.page ++;
    [self tableHeaderEndRefreshing];
    NSDictionary *params = @{@"type":@"1",@"status":@"3",@"page":@(self.page)};
    [self sendDataTableRequest:params andIsNewData:NO];
}

- (void)tableFooterEndRefreshing
{
    [self.tableViewWait.mj_footer endRefreshing];
    [self.tableViewComment.mj_footer endRefreshing];
    [self.tableViewFisish.mj_footer endRefreshing];
}
- (void)tableHeaderEndRefreshing
{
    [self.tableViewWait.mj_header endRefreshing];
    [self.tableViewComment.mj_header endRefreshing];
    [self.tableViewFisish.mj_header endRefreshing];
}

- (void)createUI
{
    self.NavTitle = @"我约的投资人";
    
    UIButton *commentDateBtn = [UIButton dateBtnWithTarget:self Action:@selector(commentDateBtnClick:) btnTitle:@"待评价" andBtnFrame:CGRectMake(0, 84, BtnW, 30)];
    commentDateBtn.centerX = self.view.centerX;
    self.commentDateBtn = commentDateBtn;
    [self.view addSubview:self.commentDateBtn];
    
    UIButton *waitDateBtn = [UIButton dateBtnWithTarget:self Action:@selector(waitDateBtnClick:) btnTitle:@"待约谈" andBtnFrame:CGRectMake(CGRectGetMinX(self.commentDateBtn.frame) - BtnW - 10, 84, BtnW, 30)];
    waitDateBtn.selected = YES;
    self.waitDateBtn = waitDateBtn;
    [self.view addSubview:self.waitDateBtn];
    
    UIButton *finishDateBtn = [UIButton dateBtnWithTarget:self Action:@selector(finishDateBtnClick:) btnTitle:@"已结束" andBtnFrame:CGRectMake(CGRectGetMaxX(self.commentDateBtn.frame) + 10, 84, BtnW, 30)];
    self.finishDateBtn = finishDateBtn;
    [self.view addSubview:self.finishDateBtn];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 130, ScreenWidth, ScrollViewHeight)];
    scrollView.contentOffset = CGPointZero;
    scrollView.contentSize = CGSizeMake(3 * ScreenWidth, 130);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.tag = 103;
    scrollView.backgroundColor = bgColor;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    self.scrollV = scrollView;
    [self.view addSubview:self.scrollV];
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
            [YT_listCreateRequestModel mj_objectWithKeyValues:json];
            //创建小红点
            [weakSelf waitBtnIsShowDotWithIfNotice];
            [weakSelf commentBtnIsShowDotWithIfNotice];
            [weakSelf finishBtnIsShowDotWithIfNotice];
            
            NSInteger totalPage = [[YT_listCreateRequestModel sharedModel].data.totalPage integerValue];
            
            if (isNewData) {//最新数据
                if (statusCreate == 1) {
                    if (weakSelf.page == totalPage || totalPage == 0) {
                        [weakSelf.tableViewWait.mj_footer endRefreshingWithNoMoreData];
                    }
                    [weakSelf.dataArrayWait removeAllObjects];
                    weakSelf.dataArrayWait = [NSMutableArray arrayWithArray:[YT_listCreateRequestModel sharedModel].data.list];
                    [weakSelf tableHeaderEndRefreshing];
                    [weakSelf.tableViewWait reloadData];
                    
                }else if (statusCreate == 2){
                    if (weakSelf.page == totalPage || totalPage == 0) {
                        [weakSelf.tableViewComment.mj_footer endRefreshingWithNoMoreData];
                    }
                    [weakSelf.dataArrayComment removeAllObjects];
                    weakSelf.dataArrayComment = [NSMutableArray arrayWithArray:[YT_listCreateRequestModel sharedModel].data.list];
                    [weakSelf tableHeaderEndRefreshing];
                    [weakSelf.tableViewComment reloadData];
                    
                }else{
                    if (weakSelf.page == totalPage || totalPage == 0) {
                        [weakSelf.tableViewFisish.mj_footer endRefreshingWithNoMoreData];
                    }
                    [weakSelf.dataArrayFinish removeAllObjects];
                    weakSelf.dataArrayFinish = [NSMutableArray arrayWithArray:[YT_listCreateRequestModel sharedModel].data.list];
                    [weakSelf tableHeaderEndRefreshing];
                    [weakSelf.tableViewFisish reloadData];
                }
            }else{//更多数据
                if (statusCreate == 1) {
                    
                    if (weakSelf.page > totalPage) {
                        [weakSelf.tableViewWait.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [weakSelf.dataArrayWait addObjectsFromArray:[YT_listCreateRequestModel sharedModel].data.list];
                        [weakSelf tableFooterEndRefreshing];
                        [weakSelf.tableViewWait reloadData];
                    }
                    
                }else if (statusCreate == 2){
                    
                    if (weakSelf.page > totalPage) {
                        [weakSelf.tableViewComment.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [weakSelf.dataArrayComment addObjectsFromArray:[YT_listCreateRequestModel sharedModel].data.list];
                        [weakSelf tableFooterEndRefreshing];
                        [weakSelf.tableViewComment reloadData];
                    }
                }else{
                    
                    if (weakSelf.page > totalPage) {
                        [weakSelf.tableViewFisish.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [weakSelf.dataArrayFinish addObjectsFromArray:[YT_listCreateRequestModel sharedModel].data.list];
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
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:nil];
}

- (void)createTableView
{
    for (int i = 0; i < 3; i ++) {
        UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScrollViewHeight) style:UITableViewStylePlain];
        tableV.tag = i + 100;
        tableV.delegate = self;
        tableV.dataSource = self;
        tableV.backgroundColor = bgColor;
        tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.scrollV addSubview:tableV];
    }
    self.tableViewWait = (UITableView *)[self.view viewWithTag:100];
    self.tableViewComment = (UITableView *)[self.view viewWithTag:101];
    self.tableViewFisish = (UITableView *)[self.view viewWithTag:102];
}

- (void)waitDateBtnClick:(UIButton *)btn
{
    btn.selected = YES;
    [self getScrollView:0];
    if (btn.selected) {
        self.finishDateBtn.selected = NO;
        self.commentDateBtn.selected = NO;
    }
}
- (void)finishDateBtnClick:(UIButton *)btn
{
    btn.selected = YES;
    [self getScrollView:2*ScreenWidth];
    if (btn.selected) {
        self.waitDateBtn.selected = NO;
        self.commentDateBtn.selected = NO;
    }
}
- (void)commentDateBtnClick:(UIButton *)btn
{
    btn.selected = YES;
    [self getScrollView:ScreenWidth];
    if (btn.selected) {
        self.waitDateBtn.selected = NO;
        self.finishDateBtn.selected = NO;
    }
}

- (void)getScrollView:(CGFloat)offset
{
    if (offset == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollV.contentOffset = CGPointMake(0, 0);
        } completion:nil];
    }else if (offset == ScreenWidth){
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollV.contentOffset = CGPointMake(ScreenWidth, 0);
        } completion:nil];
    }else if (offset == 2 * ScreenWidth){
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollV.contentOffset = CGPointMake(2 * ScreenWidth, 0);
        } completion:nil];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 103) {
        if (scrollView.contentOffset.x == ScreenWidth) {
            self.commentDateBtn.selected = YES;
            self.waitDateBtn.selected = NO;
            self.finishDateBtn.selected = NO;
            //刷新
            [self loadCommentNewData];
            
        }else if (scrollView.contentOffset.x == 0){
            self.waitDateBtn.selected = YES;
            self.finishDateBtn.selected = NO;
            self.commentDateBtn.selected = NO;
            //刷新
            [self loadWaitNewData];
            
        }else if (scrollView.contentOffset.x == 2*ScreenWidth){
            self.finishDateBtn.selected = YES;
            self.waitDateBtn.selected = NO;
            self.commentDateBtn.selected = NO;
            //刷新
            [self loadFinishNewData];
        }
    }
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 100) {
        return self.dataArrayWait.count;
    }else if (tableView.tag == 101){
        return self.dataArrayComment.count;
    }else{
        return self.dataArrayFinish.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *createDate = @"createDate";
    YT_CreateDateCell *cell = [tableView dequeueReusableCellWithIdentifier:createDate];
    if (nil == cell) {
        cell = [[YT_CreateDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:createDate];
    }
    
    if (tableView.tag == 100) {
        if (self.dataArrayWait.count > indexPath.row) {
            cell.model = self.dataArrayWait[indexPath.row];
        }
    }else if (tableView.tag == 101){
        if (self.dataArrayComment.count > indexPath.row) {
            cell.model = self.dataArrayComment[indexPath.row];
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
    return 160.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _tableViewWait) {
        YT_listCreateListModel *waitModel = self.dataArrayWait[indexPath.row];

        NSInteger status = [waitModel.orderStatus integerValue];
        if (status == 1) {
            YT_createDateController *Vc1 = [[YT_createDateController alloc] init];
            Vc1.orderID = waitModel.orderId;
            [self.navigationController pushViewController:Vc1 animated:YES];
        }else if (status == 2){
            YT_createDate2Controller *Vc2 = [[YT_createDate2Controller alloc] init];
            Vc2.orderID = waitModel.orderId;
            [self.navigationController pushViewController:Vc2 animated:YES];
        }else if (status == 3){
            YT_createDate3Controller *Vc3 = [[YT_createDate3Controller alloc] init];
            Vc3.orderID = waitModel.orderId;
            [self.navigationController pushViewController:Vc3 animated:YES];
        }
        
    }else if (tableView == _tableViewComment){
        YT_listCreateListModel *commentModel = self.dataArrayComment[indexPath.row];
        NSInteger status = [commentModel.orderStatus integerValue];
        if (status == 4) {
            YT_createDate4Controller *Vc4 = [[YT_createDate4Controller alloc] init];
            Vc4.orderID = commentModel.orderId;
            [self.navigationController pushViewController:Vc4 animated:YES];
        }
        
    }else if (tableView == _tableViewFisish){
        YT_listCreateListModel *finishModel = self.dataArrayFinish[indexPath.row];
        NSInteger status = [finishModel.orderStatus integerValue];
        if (status == 5) {
            YT_createDate5Controller *Vc5 = [[YT_createDate5Controller alloc] init];
            Vc5.orderID = finishModel.orderId;
            [self.navigationController pushViewController:Vc5 animated:YES];
        }else if (status == 22){
            YT_createDate22Controller *Vc22 = [[YT_createDate22Controller alloc] init];
            Vc22.orderID = finishModel.orderId;
            [self.navigationController pushViewController:Vc22 animated:YES];
        }else if (status == 23){
            YT_createDate23Controller *Vc23 = [[YT_createDate23Controller alloc] init];
            Vc23.orderID = finishModel.orderId;
            [self.navigationController pushViewController:Vc23 animated:YES];
        }
    }
}
//btn是否显示红点
- (void)waitBtnIsShowDotWithIfNotice
{
    self.dot = [[YBDotView alloc] init];
    self.dot.x = 70;
    self.dot.y = (30 - 8) / 2;
    if ([[YT_listCreateRequestModel sharedModel].data.ifNotice1 isEqualToString:@"true"]) {
        [self.dot showDotWithView:self.waitDateBtn];
    }else{
        [self.dot removeDotWithView:self.waitDateBtn];
    }
}
- (void)commentBtnIsShowDotWithIfNotice
{
    self.dot = [[YBDotView alloc] init];
    self.dot.x = 70;
    self.dot.y = (30 - 8) / 2;
    if ([[YT_listCreateRequestModel sharedModel].data.ifNotice2 isEqualToString:@"true"]) {
        [self.dot showDotWithView:self.commentDateBtn];
    }else{
        [self.dot removeDotWithView:self.commentDateBtn];
    }
}
- (void)finishBtnIsShowDotWithIfNotice
{
    self.dot = [[YBDotView alloc] init];
    self.dot.x = 70;
    self.dot.y = (30 - 8) / 2;
    if ([[YT_listCreateRequestModel sharedModel].data.ifNotice3 isEqualToString:@"true"]) {
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
- (NSMutableArray *)dataArrayComment
{
    if (nil == _dataArrayComment) {
        self.dataArrayComment = [NSMutableArray array];
    }
    return _dataArrayComment;
}

@end
