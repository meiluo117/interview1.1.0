//
//  YT_InvestorHasMeetModel.h
//  interview
//
//  Created by Mickey on 16/4/28.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YT_InvestorHasMeetModel : NSObject
YT_Singleton_H(hasMeetModel)
/**
 *  1=投资人 2=创业者
 */
@property (copy,nonatomic) NSString *type;
/**
 *  真实姓名
 */
@property (copy,nonatomic) NSString *realName;
/**
 *  头像
 */
@property (copy,nonatomic) NSString *headImg;
/**
 *  约见价格
 */
@property (copy,nonatomic) NSString *price;
/**
 *  约我的团队
 */
@property (copy,nonatomic) NSString *hasMeet;
/**
 *  是否显示新通知
 */
@property (copy,nonatomic) NSString *ifNotice;
@end
