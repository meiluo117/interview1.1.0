//
//  YT_Enum.m
//  interview
//
//  Created by 于波 on 16/4/5.
//  Copyright © 2016年 于波. All rights reserved.
//
#define TypeUnknow @"(必填)"
#define TypeIdea @"idea"
#define TypeOnTheWay @"研发中"
#define TypeFinish @"已上线"

#define oneStar @"不值"
#define twoStar @"一般"
#define threeStar @"可尝试"
#define fourStar @"有所收获"
#define fiveStar @"受益匪浅"

typedef NS_ENUM(NSInteger, starNumberStatusType) {
    starNumberStatusTypeUnknow        = 0,   //错误
    starNumberStatusTypeBad           = 1,   //不值
    starNumberStatusTypeGeneral       = 2,   //一般
    starNumberStatusTypeTry           = 3,   //可尝试
    starNumberStatusTypeHaveHarvest   = 4,   //有所收获
    starNumberStatusTypeVeryGood      = 5,   //受益匪浅
};

typedef NS_ENUM(NSInteger, starTitleStatusType) {
    starTitleStatusTypeUnknow        = 0,   //错误
    starTitleStatusTypeBad           = 1,   //不值
    starTitleStatusTypeGeneral       = 2,   //一般
    starTitleStatusTypeTry           = 3,   //可尝试
    starTitleStatusTypeHaveHarvest   = 4,   //有所收获
    starTitleStatusTypeVeryGood      = 5,   //受益匪浅
};

typedef NS_ENUM(NSInteger, itemStatusType) {
    itemStatusTypeUnknow   = 0,   //错误
    itemStatusTypeIdea     = 1,   //idea
    itemStatusTypeOnTheWay = 2,   //研发中
    itemStatusTypeFinish   = 3,   //已上线
};

typedef NS_ENUM(NSInteger, cityStatusType) {
    cityStatusTypeUnknow        = 0,   //错误
    cityStatusTypeBeiJing       = 1,   //北京
    cityStatusTypeShangHai      = 2,   //上海
    cityStatusTypeGuangDong     = 3,   //广东
    cityStatusTypeTianJin       = 4,   //天津
    cityStatusTypeChongQing     = 5,   //重庆
    cityStatusTypeHeiBei        = 6,   //河北
    cityStatusTypeShangXi       = 7,   //山西
    cityStatusTypeShangXi2      = 8,   //陕西
    cityStatusTypeShangDong     = 9,   //山东
    cityStatusTypeHeiNan        = 10,   //河南
    cityStatusTypeLiaoNing      = 11,   //辽宁
    cityStatusTypeJiLin         = 12,   //吉林
    cityStatusTypeJiangSu       = 13,   //江苏
    cityStatusTypeZheJiang      = 14,   //浙江
    cityStatusTypeAnHui         = 15,   //安徽
    cityStatusTypeJiangXi       = 16,   //江西
    cityStatusTypeFuJian        = 17,   //福建
    cityStatusTypeHuBei         = 18,   //湖北
    cityStatusTypeHuNan         = 19,   //湖南
    cityStatusTypeSiChuan       = 20,   //四川
    cityStatusTypeGuiZhou       = 21,   //贵州
    cityStatusTypeYunNan        = 22,   //云南
    cityStatusTypeHaiNan        = 23,   //海南
    cityStatusTypeHeiLongJiang  = 24,   //黑龙江
    cityStatusTypeGanSu         = 25,   //甘肃
    cityStatusTypeQingHai       = 26,   //青海
    cityStatusTypeGuangXi       = 27,   //广西
    cityStatusTypeNingXia       = 28,   //宁夏
    cityStatusTypeNeiMengGu     = 29,   //内蒙古
    cityStatusTypeXinJiang      = 30,   //新疆
    cityStatusTypeXiZang        = 31,   //西藏
    cityStatusTypeTaiWan        = 32,   //台湾
    cityStatusTypeXiangGang     = 33,   //香港
    cityStatusTypeAoMen         = 34,   //澳门
    cityStatusTypeHaiWai        = 35,   //海外
};

//typedef NS_ENUM(NSInteger, itemRegionStatusType) {
//    itemStatusTypeUnknow   = 0,   //错误
//    itemStatusTypeGame     = 1,   //游戏
//    itemStatusTypeHardware = 2,   //硬件
//    itemStatusTypeTool   = 3,   //工具
//    itemStatusTypeTrave   = 3,   //旅游
//    itemStatusTypeTool   = 3,   //工具
//    itemStatusTypeTool   = 3,   //工具
//    itemStatusTypeTool   = 3,   //工具
//    itemStatusTypeTool   = 3,   //工具
//    itemStatusTypeTool   = 3,   //工具
//    itemStatusTypeTool   = 3,   //工具
//    itemStatusTypeTool   = 3,   //工具
//    itemStatusTypeTool   = 3,   //工具
//    itemStatusTypeTool   = 3,   //工具
//    itemStatusTypeTool   = 3,   //工具
//    itemStatusTypeTool   = 3,   //工具
//    itemStatusTypeTool   = 3,   //工具
//    itemStatusTypeTool   = 3,   //工具
//    itemStatusTypeTool   = 3,   //工具
//    itemStatusTypeTool   = 3,   //工具
//    itemStatusTypeTool   = 3,   //工具
//};
//
//
//@"游戏":@"1",
//@"硬件":@"2",
//@"工具":@"3",
//@"旅游":@"4",
//@"金融":@"5",
//@"体育":@"6",
//@"教育":@"7",
//@"媒体":@"8",
//@"社交":@"9",
//@"搜索安全":@"10",
//@"视频娱乐":@"11",
//@"营销广告":@"12",
//@"创业服务":@"13",
//@"站长工具":@"14",
//@"企业服务":@"15",
//@"电子商务":@"16",
//@"生活消费":@"17",
//@"文化艺术":@"18",
//@"健康医疗":@"19",
//@"移动互联网":@"20",
//@"其他":@"21"};

#import "YT_Enum.h"
#import "YT_investorDateController.h"
#import "YT_investorDate2Controller.h"
#import "YT_investorDate3Controller.h"
#import "YT_investorDate4Controller.h"
#import "YT_investorDate5Controller.h"
#import "YT_investorDate22Controller.h"
#import "YT_investorDate23Controller.h"
#import "YT_createDateController.h"
#import "YT_createDate2Controller.h"
#import "YT_createDate3Controller.h"
#import "YT_createDate4Controller.h"
#import "YT_createDate5Controller.h"
#import "YT_createDate22Controller.h"
#import "YT_createDate23Controller.h"

@implementation YT_Enum

+ (CGFloat)starNumber:(starNumberStatusType)starNum
{
    switch (starNum) {
        case starNumberStatusTypeUnknow:
            return 1;
            break;
            
        case starNumberStatusTypeBad:
            return 0.2;
            break;
            
        case starNumberStatusTypeGeneral:
            return 0.4;
            break;
            
        case starNumberStatusTypeTry:
            return 0.6;
            break;
            
        case starNumberStatusTypeHaveHarvest:
            return 0.8;
            break;
            
        case starNumberStatusTypeVeryGood:
            return 1;
            break;
    }
}

+ (NSString *)starTitle:(starTitleStatusType)star
{
    switch (star) {
        case starTitleStatusTypeUnknow:
            return fiveStar;
            break;
            
        case starTitleStatusTypeBad:
            return oneStar;
            break;
            
        case starTitleStatusTypeGeneral:
            return twoStar;
            break;
            
        case starTitleStatusTypeTry:
            return threeStar;
            break;
            
        case starTitleStatusTypeHaveHarvest:
            return fourStar;
            break;
            
        case starTitleStatusTypeVeryGood:
            return fiveStar;
            break;
    }
}

+ (NSString *)productItemStatus:(itemStatusType)statusType
{
    switch (statusType) {
        case itemStatusTypeUnknow:
            return TypeUnknow;
            break;
            
        case itemStatusTypeIdea:
            return TypeIdea;
            break;
            
        case itemStatusTypeOnTheWay:
            return TypeOnTheWay;
            break;
            
        case itemStatusTypeFinish:
            return TypeFinish;
            break;
    }
}

+ (NSString *)productCityStatus:(cityStatusType)statusType
{
    switch (statusType) {
        case 0:
            return TypeUnknow;
            break;
            
        case 1:
            return @"北京";
            break;
            
        case 2:
            return @"上海";
            break;
            
        case 3:
            return @"广东";
            break;
            
        case 4:
            return @"天津";
            break;
            
        case 5:
            return @"重庆";
            break;
            
        case 6:
            return @"河北";
            break;
            
        case 7:
            return @"山西";
            break;
            
        case 8:
            return @"陕西";
            break;
            
        case 9:
            return @"山东";
            break;
            
        case 10:
            return @"河南";
            break;
            
        case 11:
            return @"辽宁";
            break;
            
        case 12:
            return @"吉林";
            break;
            
        case 13:
            return @"江苏";
            break;
            
        case 14:
            return @"浙江";
            break;
            
        case 15:
            return @"安徽";
            break;
            
        case 16:
            return @"江西";
            break;
            
        case 17:
            return @"福建";
            break;
            
        case 18:
            return @"湖北";
            break;
            
        case 19:
            return @"湖南";
            break;
            
        case 20:
            return @"四川";
            break;
            
        case 21:
            return @"贵州";
            break;
            
        case 22:
            return @"云南";
            break;
            
        case 23:
            return @"海南";
            break;
            
        case 24:
            return @"黑龙江";
            break;
            
        case 25:
            return @"甘肃";
            break;
            
        case 26:
            return @"青海";
            break;
            
        case 27:
            return @"广西";
            break;
            
        case 28:
            return @"宁夏";
            break;
            
        case 29:
            return @"内蒙古";
            break;
            
        case 30:
            return @"新疆";
            break;
            
        case 31:
            return @"西藏";
            break;
            
        case 32:
            return @"台湾";
            break;
            
        case 33:
            return @"香港";
            break;
            
        case 34:
            return @"澳门";
            break;
            
        case 35:
            return @"海外";
            break;
    }
}

+ (NSString *)starNum:(CGFloat)starNum
{
    if (starNum == 2) {
        return @"1";
    }else if (starNum == 4){
        return @"2";
    }else if (starNum == 6){
        return @"3";
    }else if (starNum == 8){
        return @"4";
    }else{
        return @"5";
    }
}

+ (NSString *)starDescription:(CGFloat)starScore
{
    if (starScore == 2) {
        return oneStar;
    }else if (starScore == 4){
        return twoStar;
    }else if (starScore == 6){
        return threeStar;
    }else if (starScore == 8){
        return fourStar;
    }else{
        return fiveStar;
    }
}

+ (Class)pushVcWithOrderStatus:(NSString *)orderStatus andUserType:(NSString *)userType
{
    NSInteger status_order = [orderStatus integerValue];
    NSInteger status_user = [userType integerValue];
    
    switch (status_order) {
        case 1:
            return status_user == 1 ? [YT_investorDateController class] : [YT_createDateController class];
            break;
            
        case 2:
            return status_user == 1 ? [YT_investorDateController class] : [YT_createDateController class];
            break;
            
        case 3:
            return status_user == 1 ? [YT_investorDateController class] : [YT_createDateController class];
            break;
            
        case 4:
            return status_user == 1 ? [YT_investorDateController class] : [YT_createDateController class];
            break;
            
        case 5:
            return status_user == 1 ? [YT_investorDateController class] : [YT_createDateController class];
            break;
            
        case 22:
            return status_user == 1 ? [YT_investorDateController class] : [YT_createDateController class];
            break;
            
        case 23:
            return status_user == 1 ? [YT_investorDateController class] : [YT_createDateController class];
            break;
        
        default:
            return nil;
            break;
    }
}

@end
