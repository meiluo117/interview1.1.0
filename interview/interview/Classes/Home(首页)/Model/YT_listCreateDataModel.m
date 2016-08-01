//
//  YT_listCreateDataModel.m
//  interview
//
//  Created by Mickey on 16/5/24.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_listCreateDataModel.h"
#import "YT_listCreateListModel.h"

@implementation YT_listCreateDataModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":[YT_listCreateListModel class]};
}
@end
