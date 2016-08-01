//
//  YT_DateInvestorOrderDataModel.h
//  interview
//
//  Created by Mickey on 16/5/20.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YT_DateInvestorOrderDataModel : NSObject
@property (copy,nonatomic) NSString *orderId;//用户id
@property (copy,nonatomic) NSString *orderNo;//订单号
@property (copy,nonatomic) NSString *orderTime;//订单时间
@property (copy,nonatomic) NSString *prcessStatus;//订单的5种状态
@property (copy,nonatomic) NSString *type;//身份
@property (copy,nonatomic) NSString *founderName;//姓名
@property (copy,nonatomic) NSString *founderMobile;
@property (copy,nonatomic) NSString *headImg;
@property (copy,nonatomic) NSString *founderWechat;
@property (copy,nonatomic) NSString *proName;//项目名称
@property (copy,nonatomic) NSString *proCity;
@property (copy,nonatomic) NSString *proIntroduce;//项目介绍
@property (copy,nonatomic) NSString *teamIntroduce;//团队介绍
@property (copy,nonatomic) NSString *stage;
@property (copy,nonatomic) NSString *stageName;
@property (copy,nonatomic) NSString *bpUrl;
@property (copy,nonatomic) NSString *bpName;
@property (copy,nonatomic) NSString *time;
@property (copy,nonatomic) NSString *address;
@property (copy,nonatomic) NSString *evaluate;//评论
@property (copy,nonatomic) NSString *evaluateTime;//评论时间bpNameFont
@property (copy,nonatomic) NSString *bpNameFont;//bp名字
@property (strong,nonatomic) NSArray *industryList;
@end
