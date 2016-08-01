//
//  YT_listCreateDataModel.h
//  interview
//
//  Created by Mickey on 16/5/24.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YT_listCreateDataModel : NSObject
@property (nonatomic,copy)NSString *curPage;
@property (nonatomic,copy)NSString *hasMore;
@property (nonatomic,copy)NSString *total;
@property (nonatomic,copy)NSString *totalPage;
@property (nonatomic,strong)NSArray *list;

/**
 *  待约谈红点
 */
@property (nonatomic,copy)NSString *ifNotice1;
/**
 *  待评价红点
 */
@property (nonatomic,copy)NSString *ifNotice2;
/**
 *  已结束红点
 */
@property (nonatomic,copy)NSString *ifNotice3;
@end
