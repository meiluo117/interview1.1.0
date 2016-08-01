//
//  YT_createDate2Controller.h
//  interview
//
//  Created by Mickey on 16/5/10.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_GrayBgController.h"
@class YT_ItemModel;
@interface YT_createDate2Controller : YT_GrayBgController
@property (strong,nonatomic) YT_ItemModel *model;
@property (copy,nonatomic)NSString *orderID;
@end
