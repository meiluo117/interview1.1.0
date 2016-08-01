//
//  YT_ItemModel.m
//  interview
//
//  Created by 于波 on 16/3/31.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_ItemModel.h"
#import <MJExtension.h>
#import "YT_IndustryModel.h"

@implementation YT_ItemModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"industryList":[YT_IndustryModel class]};
}
@end
