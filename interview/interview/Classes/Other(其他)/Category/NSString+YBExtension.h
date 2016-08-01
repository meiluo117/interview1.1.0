//
//  NSString+YBExtension.h
//  interview
//
//  Created by 于波 on 16/3/12.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YBExtension)
- (NSInteger)fileSize;

/**
 *  订单号富文本
 *
 *  @param orderNumberString 传入订单号string
 */
+ (NSMutableAttributedString *)orderNumberLableTextAttributedWithString:(NSString *)orderNumberString;

/**
 *  订单时间富文本
 *
 *  @param orderNumberString 传入订单时间string
 */
+ (NSMutableAttributedString *)orderTimeLableTextAttributedWithString:(NSString *)orderTimeString;

/**
 *  拼接订单号 加两个空格
 */
+ (NSString *)orderNumberStringWithFormat:(NSString *)orderNumberString;

/**
 *  拼接下单时间 加两个空格
 */
+ (NSString *)orderTimeStringWithFormat:(NSString *)orderTimeString;

/**
 *  得到设备token 用于推送消息
 */
+ (NSString *)stringWithDeviceToekn:(NSData *)deviceToken;

/**
 *  app版本比对
 */
+ (BOOL)isNewVersionWithPresentVersion:(NSString *)presentVersion andAppStoreVersion:(NSString *)appStoreVersion;
@end
