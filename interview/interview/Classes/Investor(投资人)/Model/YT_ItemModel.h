//
//  YT_ItemModel.h
//  interview
//
//  Created by 于波 on 16/3/31.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YT_ItemModel : NSObject

/**
 *  公司
 */
@property (nonatomic,copy)NSString *company;
/**
 *  星级
 */
@property (nonatomic,copy)NSString *evaluate;
/**
 *  头像
 */
@property (nonatomic,copy)NSString *logo;
/**
 *
 */
@property (nonatomic,copy)NSString *introduce;
/**
 *  名字
 */
@property (nonatomic,copy)NSString *name;
/**
 *  点赞人数
 */
@property (nonatomic,copy)NSString *orderNum;
/**
 *  投资经理
 */
@property (nonatomic,copy)NSString *position;
/**
 *  约谈价格
 */
@property (nonatomic,copy)NSString *price;
/**
 *  用户ID
 */
@property (nonatomic,copy)NSString *userId;

@property (nonatomic,strong)NSArray *industryList;

@end
