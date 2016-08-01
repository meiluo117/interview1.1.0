//
//  YT_DateInvestorOrderDataModel.m
//  interview
//
//  Created by Mickey on 16/5/20.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_DateInvestorOrderDataModel.h"
#import "YT_DateInvestorOrderIndustryListModel.h"
@implementation YT_DateInvestorOrderDataModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"industryList":[YT_DateInvestorOrderIndustryListModel class]};
}
@end
