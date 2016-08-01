//
//  YT_ItemTagController.h
//  interview
//
//  Created by 于波 on 16/3/24.
//  Copyright © 2016年 于波. All rights reserved.
//

typedef void(^myblock)(NSString *msg);

#import "YT_GrayBgController.h"

@interface YT_ItemTagController : YT_GrayBgController
@property (nonatomic,strong)NSMutableArray *indexArrayTitle;

@property (copy,nonatomic) myblock selectedBtnTitleBlock;

@end
