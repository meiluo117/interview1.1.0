//
//  YT_listCreateListModel.h
//  interview
//
//  Created by Mickey on 16/5/24.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YT_listCreateListModel : NSObject
@property (nonatomic,copy)NSString *orderId;
@property (nonatomic,copy)NSString *orderStatus;
@property (nonatomic,copy)NSString *orderStatusName;
@property (nonatomic,copy)NSString *updateTime;
@property (nonatomic,copy)NSString *realName;
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *headImg;
@property (nonatomic,copy)NSString *company;
@property (nonatomic,copy)NSString *position;
@property (nonatomic,copy)NSString *introduce;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *hours;
@property (nonatomic,copy)NSString *star;
@property (nonatomic,copy)NSString *evaluateNum;
@property (nonatomic,copy)NSString *evaluate;
@property (nonatomic,copy)NSString *ifNotice;

@property (nonatomic,strong)NSArray *industryList;

@end
