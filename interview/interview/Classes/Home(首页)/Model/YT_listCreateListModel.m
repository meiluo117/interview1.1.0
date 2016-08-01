//
//  YT_listCreateListModel.m
//  interview
//
//  Created by Mickey on 16/5/24.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_listCreateListModel.h"
#import "YT_listCreateIndustryListModel.h"
@implementation YT_listCreateListModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"industryList":[YT_listCreateIndustryListModel class]};
}
@end
