//
//  YT_InvestorPersonInfoModel.h
//  interview
//
//  Created by 于波 on 16/4/5.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YT_InvestorPersonInfoModel : NSObject
YT_Singleton_H(PersonInfoModel)

/**
 *  投资人身份为 1
 */
@property (nonatomic,copy)NSString *type;

/**
 *  投资人唯一标示
 */
@property (nonatomic,copy)NSString *ticket;

/**
 *  投资人真实姓名
 */
@property (nonatomic,copy)NSString *realName;

/**
 *  投资人id
 */
@property (nonatomic,copy)NSString *userId;

/**
 *  投资人地区
 */
@property (nonatomic,copy)NSString *provinceId;

/**
 *  投资人手机号
 */
@property (nonatomic,copy)NSString *mobile;

/**
 *  投资人头像
 */
@property (nonatomic,copy)NSString *headImg;

/**
 *  投资人微信号
 */
@property (nonatomic,copy)NSString *wechat;

/**
 *  投资人公司
 */
@property (nonatomic,copy)NSString *company;

/**
 *  投资人职位
 */
@property (nonatomic,copy)NSString *position;

/**
 *  投资人自我介绍
 */
@property (nonatomic,copy)NSString *introduce;

/**
 *  投资人名片
 */
@property (nonatomic,copy)NSString *card;

/**
 *  投资人约谈价格
 */
@property (nonatomic,copy)NSString *price;

/**
 *  投资人约谈小时
 */
@property (nonatomic,copy)NSString *hours;

/**
 *  投资人评分
 */
@property (nonatomic,copy)NSString *evaluate;

/**
 *  投资人投资案例
 */
@property (nonatomic,copy)NSString *investorCase;

/**
 *  投资人评价/评论
 */
@property (nonatomic,strong)NSArray *evaluateList;

/**
 *  投资人领域-数组
 */
@property (nonatomic,strong)NSArray *industryList;//ifNotice

/**
 *  是否显示红点
 */
@property (nonatomic,copy)NSString *ifNotice;

//*************行业标签专用**************

/**
 *  投资人领域文字-字符串
 */
@property (nonatomic,copy)NSString *itemTagTitle;

/**
 *  投资人领域标识-字符串
 */
@property (nonatomic,copy)NSString *itemTag;

/**
 *  记录所有标识文字-数组
 */
@property (nonatomic,strong)NSArray *itemArray;


//*************行业标签专用**************

- (void)clear;

@end
