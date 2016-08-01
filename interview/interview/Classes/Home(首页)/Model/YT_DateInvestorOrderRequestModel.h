//
//  YT_DateInvestorOrderRequestModel.h
//  interview
//
//  Created by Mickey on 16/5/20.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YT_DateInvestorOrderDataModel;
@interface YT_DateInvestorOrderRequestModel : NSObject
YT_Singleton_H(Model)
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *msg;
@property (nonatomic,strong)YT_DateInvestorOrderDataModel *data;
@end
