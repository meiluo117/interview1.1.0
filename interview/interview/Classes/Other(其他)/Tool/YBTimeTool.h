//
//  YBTimeTool.h
//  interview
//
//  Created by Mickey on 16/5/30.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBTimeTool : NSObject

/**
 *  得到系统当前时间的字符串
 */
+ (NSString *)getSystemNowTimeString;

/**
 *  得到时间的float类型 便于计算时间
 *
 *  @param timeString 传入时间的字符串 格式:2016-04-12 14:48:46
 */
+ (CGFloat)getTimeFloat:(NSString *)timeString;

@end
