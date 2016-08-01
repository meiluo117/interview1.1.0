//
//  YT_listDateInvestorDataModel.h
//  interview
//
//  Created by Mickey on 16/5/24.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YT_listDateInvestorDataModel : NSObject

@property (nonatomic,copy)NSString *curPage;
@property (nonatomic,copy)NSString *hasMore;
@property (nonatomic,copy)NSString *total;
@property (nonatomic,copy)NSString *totalPage;
@property (nonatomic,strong)NSArray *list;

@property (nonatomic,copy)NSString *ifNotice1;
@property (nonatomic,copy)NSString *ifNotice2;

@end
