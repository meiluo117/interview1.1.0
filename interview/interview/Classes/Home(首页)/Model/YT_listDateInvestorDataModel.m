//
//  YT_listDateInvestorDataModel.m
//  interview
//
//  Created by Mickey on 16/5/24.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_listDateInvestorDataModel.h"
#import "YT_listDateInvestorListModel.h"

@implementation YT_listDateInvestorDataModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":[YT_listDateInvestorListModel class]};
}
@end
