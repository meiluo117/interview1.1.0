//
//  YT_SetCreateInfoController.h
//  interview
//
//  Created by 于波 on 16/3/23.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_GrayBgController.h"

@interface YT_SetCreateInfoController : YT_GrayBgController
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,weak)UIButton *nextBtn;
@property (nonatomic,assign)BOOL isExistBtn;
@property (nonatomic,copy)NSString *navTitleString;
@end
