//
//  YT_listCreateRequestModel.h
//  interview
//
//  Created by Mickey on 16/5/24.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YT_listCreateDataModel;
@interface YT_listCreateRequestModel : NSObject
YT_Singleton_H(Model)
@property (strong,nonatomic)YT_listCreateDataModel *data;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *msg;
@end
