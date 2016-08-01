//
//  YT_DataModel.m
//  interview
//
//  Created by 于波 on 16/3/31.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_DataModel.h"
#import <MJExtension.h>
#import "YT_ItemModel.h"

@implementation YT_DataModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":[YT_ItemModel class]};
}

@end
