//
//  YT_DateOrderInfoDataModel.m
//  interview
//
//  Created by Mickey on 16/5/18.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_DateOrderInfoDataModel.h"
#import "YT_DateOrderInfoIndustryListModel.h"

@implementation YT_DateOrderInfoDataModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"industryList":[YT_DateOrderInfoIndustryListModel class]};
}
@end
