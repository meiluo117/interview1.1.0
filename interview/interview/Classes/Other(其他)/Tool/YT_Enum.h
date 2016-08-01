//
//  YT_Enum.h
//  interview
//
//  Created by 于波 on 16/4/5.
//  Copyright © 2016年 于波. All rights reserved.
//
typedef NS_ENUM(NSInteger, itemStatusType);
typedef NS_ENUM(NSInteger, cityStatusType);
typedef NS_ENUM(NSInteger, starTitleStatusType);
typedef NS_ENUM(NSInteger, starNumberStatusType);

#import <Foundation/Foundation.h>

@interface YT_Enum : NSObject

+ (Class)pushVcWithOrderStatus:(NSString *)orderStatus andUserType:(NSString *)userType;

/**
 *  项目状态
 *
 *  @param statusType 传入int类型
 */
+ (NSString *)productItemStatus:(itemStatusType)statusType;

/**
 *  城市
 *
 *  @param statusType 传入int类型
 */
+ (NSString *)productCityStatus:(cityStatusType)statusType;

/**
 *  通过orderEvaluateStar=？参数，得到星星对应的title
 *
 *  @param star 传递int类型
 */
+ (NSString *)starTitle:(starTitleStatusType)star;

/**
 *  通过orderEvaluateStar=？参数，得到相应的float数值，显示星星个数
 *
 *  @param 传递int类型
 */
+ (CGFloat)starNumber:(starNumberStatusType)starNum;

/**
 *  传入评价星星float，得到对应的几颗星
 */
+ (NSString *)starNum:(CGFloat)starNum;

/**
 *  传入评价星星float，得到星星对应的描述
 */
+ (NSString *)starDescription:(CGFloat)starScore;

@end
