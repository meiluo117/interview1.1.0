//
//  YT_DetailsHomeWebController.h
//  interview
//
//  Created by Mickey on 16/5/6.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YT_ItemModel;
//@class YT_DateOrderInfoDataModel;
@interface YT_DetailsHomeWebController : UIViewController
@property (copy,nonatomic) NSString *userID;
@property (assign,nonatomic) BOOL isExistDateBtn;
@property (strong,nonatomic) YT_ItemModel *model;
@end
