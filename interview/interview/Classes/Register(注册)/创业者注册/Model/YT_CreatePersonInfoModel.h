//
//  YT_CreatePersonInfoModel.h
//  interview
//
//  Created by 于波 on 16/4/5.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YT_CreatePersonInfoModel : NSObject
YT_Singleton_H(PersonInfoModel)
/**
 *  用户唯一表示token
 */
@property (nonatomic,copy)NSString *ticket;
/**
 *  用户id
 */
@property (nonatomic,copy)NSString *userId;

/**
 *  用户身份 1=投资人 2=创业者
 */
//@property (nonatomic,copy)NSString *type;

/**
 *  用户真实姓名
 */
@property (nonatomic,copy)NSString *realName;

/**
 *  用户手机
 */
@property (nonatomic,copy)NSString *mobile;

/**
 *  用户头像url
 */
@property (nonatomic,copy)NSString *headImg;

/**
 *  用户微信
 */
@property (nonatomic,copy)NSString *wechat;


/**
 *  项目logo
 */
@property (nonatomic,copy)NSString *logo;

/**
 *  项目id
 */
@property (nonatomic,copy)NSString *projectId;

/**
 *  项目名称
 */
@property (nonatomic,copy)NSString *name;

/**
 *  项目阶段
 */
@property (nonatomic,copy)NSString *stage;

/**
 *  行业标签数组
 */
@property (nonatomic,strong)NSArray *industryList;

/**
 *  所在地区
 */
@property (nonatomic,copy)NSString *provinceId;

/**
 *  项目介绍
 */
@property (nonatomic,copy)NSString *introduce;

/**
 *  团队介绍
 */
@property (nonatomic,copy)NSString *apntTeamIntro;

/**
 *  是否有通知
 */
@property (nonatomic,copy)NSString *ifNotice;

- (void)clear;

//*************行业标签专用**************

/**
 *  记录行业标签-文字字符串
 */
@property (nonatomic,copy)NSString *itemTagTitle;

/**
 *  记录行业标签-标识字符串
 */
@property (nonatomic,copy)NSString *itemTag;

/**
 *  记录所有标识文字-数组
 */
@property (nonatomic,strong)NSArray *itemArray;

//*************行业标签专用**************

@end
