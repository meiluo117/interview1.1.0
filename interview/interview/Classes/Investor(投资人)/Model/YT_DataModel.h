//
//  YT_DataModel.h
//  interview
//
//  Created by 于波 on 16/3/31.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YT_DataModel : NSObject

@property (nonatomic,copy)NSString *curPage;
@property (nonatomic,copy)NSString *hasMore;
@property (nonatomic,copy)NSString *total;
/**
 *  总页数
 */
@property (nonatomic,copy)NSString *totalPage;
@property (nonatomic,strong)NSArray *list;

@end
