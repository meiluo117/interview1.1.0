//
//  YT_ResponseModel.h
//  interview
//
//  Created by 于波 on 16/3/31.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YT_DataModel;
@interface YT_ResponseModel : NSObject
YT_Singleton_H(Model)
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *msg;
@property (nonatomic,strong)YT_DataModel *data;

@end
