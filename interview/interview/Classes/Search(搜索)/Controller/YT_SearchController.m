//
//  YT_SearchController.m
//  interview
//
//  Created by 于波 on 16/4/8.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_SearchController.h"
#import "YBSearchBar.h"
#import "YT_HomeTableCell.h"
#import "UIButton+YBExtension.h"
#import "YT_ResponseModel.h"
#import "YT_DataModel.h"
#import "YT_ItemModel.h"
#import "YT_IndustryModel.h"
#import <MJExtension.h>
#import "BJNoDataView.h"
#import "YT_CommonConstList.h"
#import "YT_dateInfoController.h"
#import "YT_DetailsHomeWebController.h"

@interface YT_SearchController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong,nonatomic) UITableView *searchTableV;
@property (strong,nonatomic) NSMutableArray *searchDataArray;
@property (nonatomic,strong) YBSearchBar *searchBar;
@end

@implementation YT_SearchController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSearchBar];
    self.view.backgroundColor = YT_Color(244, 244, 244, 1);
    [self addObserver:self forKeyPath:SearchArrayNOData options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context
{
    if (![keyPath isEqualToString:SearchArrayNOData]) {
        
        return;
    }
    if ([self.searchDataArray count]==0) {//无数据
        
        [[BJNoDataView shareNoDataView] showCenterWithSuperView:self.searchTableV icon:nil iconClicked:^{
            
            //图片点击回调
        }];
        
        return;
    }
    //有数据
    [[BJNoDataView shareNoDataView] clear];//删除
}

- (void)createSearchBar
{
    YBSearchBar *searchBar = [YBSearchBar searchBar];
    searchBar.delegate = self;
    searchBar.x = 10;
    searchBar.width = ScreenWidth - 20;
    searchBar.height = 30;
    self.searchBar = searchBar;
    self.navigationItem.titleView = self.searchBar;
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    UIButton *cancelBtn = [UIButton otherBtnWithTarget:self Action:@selector(cancelBtnClick:) btnTitle:@"取消" andBtnFrame:CGRectMake(0, 0, 30, 20)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)cancelBtnClick:(UIButton *)btn
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self.searchBar endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)creatTableView{
    self.searchTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.searchTableV.delegate = self;
    self.searchTableV.dataSource = self;
    self.searchTableV.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.searchTableV];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchDataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"home";
    
    YT_HomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (nil == cell) {
        cell = [[YT_HomeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (self.searchDataArray.count > indexPath.row) {
        cell.model = self.searchDataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YT_ItemModel *model = self.searchDataArray[indexPath.row];
    YT_DetailsHomeWebController *investorDetailVc = [[YT_DetailsHomeWebController alloc] init];
    investorDetailVc.userID = model.userId;
    investorDetailVc.model = model;
    [self.navigationController pushViewController:investorDetailVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

- (void)createData:(NSString *)search
{
    YT_WS(weakSelf);
    [self creatTableView];
    NSDictionary *params = @{@"keywords":search};
    [YBHttpNetWorkTool post:Url_Search params:params success:^(id json) {
        YT_LOG(@"sesrch---%@",json);
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDictionary = json[@"data"];
            NSInteger total = [dataDictionary[@"total"] integerValue];
            
            if (total != 0) {
                YT_ResponseModel *model = [YT_ResponseModel mj_objectWithKeyValues:json];
                weakSelf.searchDataArray = [NSMutableArray arrayWithArray:model.data.list];
                [self.searchBar endEditing:YES];
                [weakSelf.searchTableV reloadData];
            }else{
                [SVProgressHUD showErrorWithStatus:@"未搜索到"];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    } header:@"" ShowWithStatusText:@"正在搜索..."];
}

#pragma mark - 懒加载
- (NSMutableArray *)searchDataArray
{
    if (nil == _searchDataArray) {
        self.searchDataArray = [NSMutableArray array];
    }
    return _searchDataArray;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self createData:textField.text];
    return YES;
}

-(void)dealloc{//移除观察者
    
    [self removeObserver:self forKeyPath:SearchArrayNOData];
}


@end
