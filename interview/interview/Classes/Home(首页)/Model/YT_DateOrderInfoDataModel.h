//
//  YT_DateOrderInfoDataModel.h
//  interview
//
//  Created by Mickey on 16/5/18.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YT_DateOrderInfoDataModel : NSObject

@property (copy,nonatomic) NSString *orderId;//订单id
@property (copy,nonatomic) NSString *orderTime;//订单下单时间//orderNo
@property (copy,nonatomic) NSString *orderNo;//订单号
@property (copy,nonatomic) NSString *prcessStatus;//order进度状态
@property (copy,nonatomic) NSString *hasMeetFounders;//人数
@property (copy,nonatomic) NSString *type;//身份状态
@property (copy,nonatomic) NSString *realName;//真实姓名
@property (copy,nonatomic) NSString *name;//真实姓名
@property (copy,nonatomic) NSString *userId;//用户id,加载网页使用
@property (copy,nonatomic) NSString *headImg;//头像
@property (copy,nonatomic) NSString *logo;//头像
@property (copy,nonatomic) NSString *stage;//项目阶段
@property (copy,nonatomic) NSString *provinceId;//城市id
@property (copy,nonatomic) NSString *company;//公司
@property (copy,nonatomic) NSString *position;//职位
@property (copy,nonatomic) NSString *mobile;//手机号
@property (copy,nonatomic) NSString *introduce;//介绍
@property (copy,nonatomic) NSString *wechat;//微信号
@property (copy,nonatomic) NSString *time;//约谈时间
@property (copy,nonatomic) NSString *address;//约谈地址
@property (copy,nonatomic) NSString *price;//约谈价格
@property (copy,nonatomic) NSString *hours;//约谈小时
@property (copy,nonatomic) NSString *star;//评价星星
@property (copy,nonatomic) NSString *orderEvaluateStar;//订单评分
@property (copy,nonatomic) NSString *orderEvaluateContent;//订单评论
@property (copy,nonatomic) NSString *notice;//注意事项
@property (nonatomic,strong) NSArray *industryList;
@property (copy,nonatomic) NSString *discount;//优惠金额
@property (copy,nonatomic) NSString *realPay;//实际支付金额
@property (copy,nonatomic) NSString *cancelTime;//订单取消时间

@end
