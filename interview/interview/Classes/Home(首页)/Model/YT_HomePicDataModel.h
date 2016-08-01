//
//  YT_HomePicDataModel.h
//  interview
//
//  Created by Mickey on 16/6/12.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YT_HomePicDataModel : NSObject
@property (nonatomic,copy)NSString *curPage;
@property (nonatomic,copy)NSString *hasMore;
@property (nonatomic,copy)NSString *total;
@property (nonatomic,copy)NSString *totalPage;
@property (nonatomic,strong)NSArray *list;
@end
