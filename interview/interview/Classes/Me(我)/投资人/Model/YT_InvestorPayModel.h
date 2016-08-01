//
//  YT_InvestorPayModel.h
//  interview
//
//  Created by Mickey on 16/4/28.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YT_InvestorPayModel : NSObject
YT_Singleton_H(PayModel)
/**
 *  支付账户姓名
 */
@property (copy,nonatomic) NSString *realName;
/**
 *  支付账户
 */
@property (copy,nonatomic) NSString *aliAccount;
/**
 *  累计收入
 */
@property (copy,nonatomic) NSString *sum;
/**
 *  余额总数
 */
@property (copy,nonatomic) NSString *balance;
/**
 *  身份证
 */
@property (copy,nonatomic) NSString *idCard;

@end
