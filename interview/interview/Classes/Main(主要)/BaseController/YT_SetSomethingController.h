//
//  YT_SetSomethingController.h
//  interview
//
//  Created by 于波 on 16/3/23.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_GrayBgController.h"

@interface YT_SetSomethingController : YT_GrayBgController
@property (nonatomic,weak)UILabel *showLable;
@property (nonatomic,weak)UITextField *infoTextField;
- (void)showLableStr:(NSString *)lableStr andLableHidden:(BOOL)lableHidden;
- (void)showInfoTextFieldPlaceholder:(NSString *)infoTextFieldPlaceholderStr;

@end
