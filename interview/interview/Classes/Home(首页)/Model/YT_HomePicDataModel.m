//
//  YT_HomePicDataModel.m
//  interview
//
//  Created by Mickey on 16/6/12.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_HomePicDataModel.h"
#import "YT_HomePicListModel.h"

@implementation YT_HomePicDataModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":[YT_HomePicListModel class]};
}
@end
