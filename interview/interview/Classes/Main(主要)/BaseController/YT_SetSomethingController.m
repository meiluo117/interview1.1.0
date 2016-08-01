//
//  YT_SetSomethingController.m
//  interview
//
//  Created by 于波 on 16/3/23.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_SetSomethingController.h"
#import "UIBarButtonItem+YBExtension.h"

@interface YT_SetSomethingController ()

@end

@implementation YT_SetSomethingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 300, 20)];
    lable.textColor = YT_Color(175, 175, 175, 1);
    lable.font = [UIFont systemFontOfSize:12];
    lable.textAlignment = NSTextAlignmentLeft;
    self.showLable = lable;
    [self.view addSubview:self.showLable];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.showLable.frame) + 2, ScreenWidth, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(20, (bgView.height - 20) / 2, 300, 20)];
    textF.font = [UIFont systemFontOfSize:14];
    textF.textColor = [UIColor blackColor];
    self.infoTextField = textF;
    [bgView addSubview:self.infoTextField];
    
    UITapGestureRecognizer *tapToCancelKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
    [self.view addGestureRecognizer:tapToCancelKeyboard];
}

//消除键盘
-(void)cancelKeyboard{
    [self.view endEditing:YES];
}

- (void)showLableStr:(NSString *)lableStr andLableHidden:(BOOL)lableHidden
{
    if (lableHidden) {
        self.showLable.hidden = YES;
    }else{
        self.showLable.text = lableStr;
    }
}

- (void)showInfoTextFieldPlaceholder:(NSString *)infoTextFieldPlaceholderStr
{
    self.infoTextField.placeholder = infoTextFieldPlaceholderStr;
}


@end
