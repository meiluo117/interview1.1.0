//
//  YBTimeTool.m
//  interview
//
//  Created by Mickey on 16/5/30.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YBTimeTool.h"

@implementation YBTimeTool

+ (NSString *)getSystemNowTimeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

+ (CGFloat)getTimeFloat:(NSString *)timeString
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//可能需要设置时区，此处设为东8即北京时间
    NSDate * questionDate = [dateFormatter dateFromString:timeString];//时间为2016-04-12 14:48:46 +0000
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timeInterval =[questionDate timeIntervalSinceDate:nowDate];
    return timeInterval;
}

@end
