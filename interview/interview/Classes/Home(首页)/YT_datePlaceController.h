//
//  YT_datePlaceController.h
//  interview
//
//  Created by Mickey on 16/5/6.
//  Copyright © 2016年 于波. All rights reserved.
//

typedef void(^myBlock)(NSString *msg);

#import "YT_GrayBgController.h"

@interface YT_datePlaceController : YT_GrayBgController
@property (copy,nonatomic) myBlock placeBlock;
@property (copy,nonatomic) NSString *place;
@end
