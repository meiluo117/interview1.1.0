//
//  YT_GrayBgController.m
//  interview
//
//  Created by 于波 on 16/3/23.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_GrayBgController.h"

@interface YT_GrayBgController ()

@end

@implementation YT_GrayBgController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = bgColor;
    
    //点击消除键盘
//    UITapGestureRecognizer *tapToCancelKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
//    [self.view addGestureRecognizer:tapToCancelKeyboard];
}

- (void)setNavTitle:(NSString *)NavTitle
{
    self.navigationItem.title = NavTitle;
}

//消除键盘
-(void)cancelKeyboard{
    [self.view endEditing:YES];
}



@end
