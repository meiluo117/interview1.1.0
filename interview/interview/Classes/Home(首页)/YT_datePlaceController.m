//
//  YT_datePlaceController.m
//  interview
//
//  Created by Mickey on 16/5/6.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_datePlaceController.h"

@interface YT_datePlaceController ()
@property (weak,nonatomic)UITextView *datePlaceTextV;
@end

@implementation YT_datePlaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.navigationItem.title = @"约见地点";
    
    UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 120)];
    textV.backgroundColor = [UIColor whiteColor];
    textV.font = [UIFont systemFontOfSize:14];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.datePlaceTextV = textV;
    self.datePlaceTextV.text = self.place;
    [self.view addSubview:self.datePlaceTextV];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save
{
    if (self.placeBlock) {
        self.placeBlock(self.datePlaceTextV.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
