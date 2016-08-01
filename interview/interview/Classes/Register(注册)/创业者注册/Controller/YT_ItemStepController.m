//
//  YT_ItemStepController.m
//  interview
//
//  Created by 于波 on 16/3/24.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_ItemStepController.h"
#import "UIButton+YBExtension.h"
#import "YT_CreateItemsInfoModel.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_Enum.h"

@interface YT_ItemStepController ()
@property (nonatomic,copy)NSString *btnSelectedTitle;
@property (nonatomic,strong)NSArray *btnTitleArray;
@property (nonatomic,strong)NSDictionary *btnTitleDict;
@end

@implementation YT_ItemStepController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.NavTitle = @"项目阶段";
    [self createUI];
}

- (void)createUI
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    
    self.btnTitleArray = @[@"idea",@"研发中",@"已上线"];
    self.btnTitleDict = @{@"idea":@"1",@"研发中":@"2",@"已上线":@"3"};
    
    //<1>上下左右的间距
    float wSpace = (float)(ScreenWidth- 3 * 70) / 4;
    float hSpace = (float)(ScreenHeight - 3 * 25 - 64 - 49) / 4;
    
    //<2>设置按钮的显示位置
    for(int i = 0;i<self.btnTitleArray.count;i++)
    {
        UIButton * btn = [UIButton chooseBtnWithTarget:self Action:@selector(btnClick:) btnTitle:self.btnTitleArray[i] andBtnFrame:CGRectMake(wSpace + (wSpace + 70) * (i % 3), hSpace + (40) * (i / 3), 70, 25)];
        btn.tag = i + 10;
        [self.view addSubview:btn];
    }
    
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            if ([((UIButton *)obj).titleLabel.text isEqualToString:[YT_Enum productItemStatus:[[YT_CreatePersonInfoModel sharedPersonInfoModel].stage integerValue]]]) {
                ((UIButton *)obj).selected = YES;
                self.btnSelectedTitle = ((UIButton *)obj).titleLabel.text;
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
    YT_LOG(@"save ---%@",self.btnTitleDict[self.btnSelectedTitle]);
    
    NSString *str = self.btnTitleDict[self.btnSelectedTitle];

    [self sendRequest:str];
}

- (void)sendRequest:(NSString *)str
{
    YT_WS(weakSelf);
    NSDictionary *params = @{@"type":@"2",
                             @"value":str,
                             @"projectId":[YT_CreatePersonInfoModel sharedPersonInfoModel].projectId};
    
    [YBHttpNetWorkTool post:Url_ItemProduct_Info params:params success:^(id json) {
        
        NSInteger statusCode = [json[@"code"] integerValue];
        if (statusCode == 1) {
            [SVProgressHUD dismiss];
            [YT_CreatePersonInfoModel sharedPersonInfoModel].stage = str;
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }else{
            [SVProgressHUD dismiss];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:nil];
}

- (void)btnClick:(UIButton *)btn
{
    for(int i = 10; i < 13; i++)
    {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        button.selected = NO;
    }
    NSInteger seleBtnIndex = (long)btn.tag - 10;
    self.btnSelectedTitle = self.btnTitleArray[seleBtnIndex];
    btn.selected = YES;
}

@end
