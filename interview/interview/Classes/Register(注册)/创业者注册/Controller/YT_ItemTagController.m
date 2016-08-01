//
//  YT_ItemTagController.m
//  interview
//
//  Created by 于波 on 16/3/24.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_ItemTagController.h"
#import "UIButton+YBExtension.h"
#import "YT_CreateItemsInfoModel.h"
#import "YT_InvestorPersonInfoModel.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_IndustryModel.h"

@interface YT_ItemTagController ()
//@property (nonatomic,copy)NSString *btnSelectedTitle;
@property (nonatomic,strong)NSArray *btnTitleArray;
@property (nonatomic,strong)NSDictionary *btnTitleDict;
@property (nonatomic,strong)NSMutableArray *indexArray;//将选中的btn标识添加到数组中，发送到服务器，例如："2,3,14"

@property (nonatomic,copy)NSString *cutString;
@property (nonatomic,copy)NSString *cutStringTitle;
@end

@implementation YT_ItemTagController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.NavTitle = @"行业标签";
    [self createUI];
}

- (void)createUI
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    
    self.btnTitleArray = @[@"游戏",@"硬件",@"工具",@"旅游",@"金融",@"体育",@"教育",@"媒体",@"社交",@"搜索安全",@"视频娱乐",@"营销广告",@"创业服务",@"站长工具",@"企业服务",@"电子商务",@"生活消费",@"文化艺术",@"健康医疗",@"移动互联网",@"TMT",@"大数据",@"消费升级",@"其他"];
    
    self.btnTitleDict = @{@"游戏":@"1",
                          @"硬件":@"2",
                          @"工具":@"3",
                          @"旅游":@"4",
                          @"金融":@"5",
                          @"体育":@"6",
                          @"教育":@"7",
                          @"媒体":@"8",
                          @"社交":@"9",
                          @"搜索安全":@"10",
                          @"视频娱乐":@"11",
                          @"营销广告":@"12",
                          @"创业服务":@"13",
                          @"站长工具":@"14",
                          @"企业服务":@"15",
                          @"电子商务":@"16",
                          @"生活消费":@"17",
                          @"文化艺术":@"18",
                          @"健康医疗":@"19",
                          @"移动互联网":@"20",
                          @"其他":@"21",
                          @"TMT":@"22",
                          @"大数据":@"23",
                          @"消费升级":@"24"};
    
    float wSpace = (float)(ScreenWidth- 3 * 80) / 4;
    float hSpace = (float)(ScreenHeight - 3 * 25 - 64 - 49) / 4;
    
    for(int i = 0;i < self.btnTitleArray.count;i++)
    {
        UIButton *btn = [UIButton chooseBtnWithTarget:self Action:@selector(btnClick:) btnTitle:self.btnTitleArray[i] andBtnFrame:CGRectMake(wSpace + (wSpace + 80) * (i % 3), hSpace + (60) * (i / 3), 80, 25)];
        btn.tag = i + 10;
        [self.view addSubview:btn];
    }
    
    if ([YT_CreatePersonInfoModel sharedPersonInfoModel].itemArray.count == 0 && [YT_InvestorPersonInfoModel sharedPersonInfoModel].itemArray == 0) return;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"ID"] isEqualToString:@"chuangye"]) {
        [self btnSelected:[YT_CreatePersonInfoModel sharedPersonInfoModel].itemArray];
    }else{
        [self btnSelected:[YT_InvestorPersonInfoModel sharedPersonInfoModel].itemArray];
    }
}

- (void)btnSelected:(NSArray *)array
{
    for (NSString *str in array) {
        for (id obj in self.view.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                if ([((UIButton *)obj).titleLabel.text isEqualToString:str]) {
                    ((UIButton *)obj).selected = YES;
                    [self.indexArrayTitle addObject:self.btnTitleArray[((UIButton *)obj).tag - 10]];
                    [self.indexArray addObject:self.btnTitleDict[self.btnTitleArray[((UIButton *)obj).tag - 10]]];
                }
            }
        }
    }
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(UIButton *)btn
{
    if (self.indexArray.count == 0) return;
    
    NSString *indexString = [NSMutableString string];
    for (NSString *str in self.indexArray) {
        indexString = [indexString stringByAppendingFormat:@"%@,",str];
    }
    self.cutString = [indexString substringToIndex:indexString.length - 1];
    
    NSString *indexTitleString = [NSMutableString string];
    for (NSString *str in self.indexArrayTitle) {
        indexTitleString = [indexTitleString stringByAppendingFormat:@"%@,",str];
    }
    self.cutStringTitle = [indexTitleString substringToIndex:indexTitleString.length - 1];
    
//    [YT_CreateItemsInfoModel sharedItemInfoModel].itemTagTitle = self.cutStringTitle;
//    [YT_CreateItemsInfoModel sharedItemInfoModel].itemArray = self.indexArrayTitle;
//    [self.navigationController popViewControllerAnimated:YES];YT_CreatePersonInfoModel
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"ID"] isEqualToString:@"chuangye"]) {
        
        NSDictionary *params = @{@"type":@"3",
                                 @"value":self.cutString,
                                 @"projectId":[YT_CreatePersonInfoModel sharedPersonInfoModel].projectId};
        
        [self sendRequest:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket requestUrl:Url_ItemProduct_Info andParams:params];
        
    }else{
        NSDictionary *params = @{@"type":@"7",
                                 @"value":self.cutString};
        
        [self sendRequest:[YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket requestUrl:Url_Set_Domain andParams:params];
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
                [YT_CreatePersonInfoModel sharedPersonInfoModel].itemArray = self.indexArrayTitle;
                [YT_CreatePersonInfoModel sharedPersonInfoModel].itemTagTitle = self.cutStringTitle;
                [YT_CreatePersonInfoModel sharedPersonInfoModel].itemTag = self.cutString;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [YT_InvestorPersonInfoModel sharedPersonInfoModel].itemArray = self.indexArrayTitle;
                [YT_InvestorPersonInfoModel sharedPersonInfoModel].itemTagTitle = self.cutStringTitle;
                [YT_InvestorPersonInfoModel sharedPersonInfoModel].itemTag = self.cutString;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
        }else{
            [SVProgressHUD dismiss];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        YT_LOG(@"选择相关领域error:%@",error);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } header:userTicket ShowWithStatusText:nil];
}

- (void)btnClick:(UIButton *)btn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"ID"] isEqualToString:@"chuangye"]) {
        [self chuangyeBtn:btn];
    }else{
        [self touziBtn:btn];
    }
}

- (void)chuangyeBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.indexArray addObject:self.btnTitleDict[self.btnTitleArray[btn.tag - 10]]];
        [self.indexArrayTitle addObject:self.btnTitleArray[btn.tag - 10]];
        
        if (self.indexArray.count > 3) {
            btn.selected = NO;
            [self.indexArray removeObject:self.btnTitleDict[self.btnTitleArray[btn.tag - 10]]];
            [self.indexArrayTitle removeObject:self.btnTitleArray[btn.tag - 10]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"最多添加三个行业标签" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }else{
        [self.indexArray removeObject:self.btnTitleDict[self.btnTitleArray[btn.tag - 10]]];
        [self.indexArrayTitle removeObject:self.btnTitleArray[btn.tag - 10]];
    }
}

- (void)touziBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.indexArray addObject:self.btnTitleDict[self.btnTitleArray[btn.tag - 10]]];
        [self.indexArrayTitle addObject:self.btnTitleArray[btn.tag - 10]];
    }else{
        [self.indexArray removeObject:self.btnTitleDict[self.btnTitleArray[btn.tag - 10]]];
        [self.indexArrayTitle removeObject:self.btnTitleArray[btn.tag - 10]];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)indexArray
{
    if (nil == _indexArray) {
        self.indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

- (NSMutableArray *)indexArrayTitle
{
    if (nil == _indexArrayTitle) {
        self.indexArrayTitle = [NSMutableArray array];
    }
    return _indexArrayTitle;
}

@end
