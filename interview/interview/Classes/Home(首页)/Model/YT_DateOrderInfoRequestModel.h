//
//  YT_DateOrderInfoRequestModel.h
//  interview
//
//  Created by Mickey on 16/5/18.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YT_DateOrderInfoDataModel;
@interface YT_DateOrderInfoRequestModel : NSObject
YT_Singleton_H(Model)
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *msg;
@property (nonatomic,strong)YT_DateOrderInfoDataModel *data;

@end
