//
//  NSString+YBExtension.m
//  interview
//
//  Created by 于波 on 16/3/12.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "NSString+YBExtension.h"

@implementation NSString (YBExtension)
- (NSInteger)fileSize
{
    NSFileManager *mgr = [NSFileManager defaultManager];

    BOOL dir = NO;
    BOOL exists = [mgr fileExistsAtPath:self isDirectory:&dir];

    if (exists == NO) return 0;
    
    if (dir) {

        NSArray *subpaths = [mgr subpathsAtPath:self];
        NSInteger totalByteSize = 0;
        for (NSString *subpath in subpaths) {

            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];

            BOOL dir = NO;
            [mgr fileExistsAtPath:fullSubpath isDirectory:&dir];
            if (dir == NO) {
                totalByteSize += [[mgr attributesOfItemAtPath:fullSubpath error:nil][NSFileSize] integerValue];
            }
        }
        return totalByteSize;
    } else {
        return [[mgr attributesOfItemAtPath:self error:nil][NSFileSize] integerValue];
    }
}

+ (NSMutableAttributedString *)orderNumberLableTextAttributedWithString:(NSString *)orderNumberString
{
     //富文本对象
    NSMutableAttributedString *aAttributedString = [[NSMutableAttributedString alloc] initWithString:orderNumberString];
    
    //range(0,3) 字体颜色
    [aAttributedString addAttribute:NSForegroundColorAttributeName value:YT_Color(124, 126, 135, 1) range:NSMakeRange(0, 3)];
    
    [aAttributedString addAttribute:NSForegroundColorAttributeName value:btnColor range:NSMakeRange(5, orderNumberString.length - 5)];
    
    //range(0,3) 字体大小
    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0,3)];
    
    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(5, orderNumberString.length - 5)];
    
    return aAttributedString;
}

+ (NSMutableAttributedString *)orderTimeLableTextAttributedWithString:(NSString *)orderTimeString
{
    //富文本对象
    NSMutableAttributedString *aAttributedString = [[NSMutableAttributedString alloc] initWithString:orderTimeString];
    
    //range(0,3) 字体颜色
    [aAttributedString addAttribute:NSForegroundColorAttributeName value:YT_Color(124, 126, 135, 1) range:NSMakeRange(0, orderTimeString.length)];
    
    [aAttributedString addAttribute:NSForegroundColorAttributeName value:btnColor range:NSMakeRange(6, orderTimeString.length - 6)];
    
    //range(0,3) 字体大小
    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 4)];
    
    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(6, orderTimeString.length - 6)];
    
    return aAttributedString;
}

+ (NSString *)orderNumberStringWithFormat:(NSString *)orderNumberString
{
    NSString *str = [NSString stringWithFormat:@"订单号  %@",orderNumberString];
    return str;
}

+ (NSString *)orderTimeStringWithFormat:(NSString *)orderTimeString
{
    return [NSString stringWithFormat:@"下单时间  %@",orderTimeString];
}

+ (NSString *)stringWithDeviceToekn:(NSData *)deviceToken
{
    return [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]                  stringByReplacingOccurrencesOfString: @">" withString: @""]                 stringByReplacingOccurrencesOfString: @" " withString: @""];
}

+ (BOOL)isNewVersionWithPresentVersion:(NSString *)presentVersion andAppStoreVersion:(NSString *)appStoreVersion
{
    NSMutableString *appStoreV = [NSMutableString stringWithString:appStoreVersion];
    NSMutableString *presentV = [NSMutableString stringWithString:presentVersion];
    NSString *cutAppStoreVersion = [appStoreV stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *cutPresentVersion = [presentV stringByReplacingOccurrencesOfString:@"." withString:@""];
    return [cutAppStoreVersion integerValue] > [cutPresentVersion integerValue] ? YES : NO;
}

@end
