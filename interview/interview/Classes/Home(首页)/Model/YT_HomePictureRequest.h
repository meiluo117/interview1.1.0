//
//  YT_HomePictureRequest.h
//  interview
//
//  Created by Mickey on 16/6/12.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YT_HomePicDataModel;
@interface YT_HomePictureRequest : NSObject
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *msg;
@property (strong,nonatomic) YT_HomePicDataModel *data;
@end
