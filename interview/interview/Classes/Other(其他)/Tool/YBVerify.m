//
//  YBVerify.m
//  interview
//
//  Created by 于波 on 16/3/25.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YBVerify.h"

@implementation YBVerify

/**
 *  验证手机号是否为空
 *
 *  @param mobileNum 手机
 *
 *  @return 手机号为空返回YES，否则返回NO
 */
+ (BOOL)isPobileNumEmpty:(NSString *)mobileNum {
    if(mobileNum.length) return NO;
    return YES;
}

/**
 *  验证手机号合法性
 *
 *  @param mobileNum 手机号
 *
 *  @return 手机号合法返回YES，否则返回NO
 */
+ (BOOL)isPhoneNumAvailability:(NSString *)mobileNum {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 *  校验密码位数
 *
 *  @param password 密码
 *
 *  @return 密码位数是在6-12之间返回YES，否则返回NO
 */
+ (BOOL)checkLengthOfPassword:(NSString *)password {
    if(password.length >= 6 && password.length <= 18) return YES;
    
    return NO;
}

/**
 *  校验确认密码和密码是否相同
 *
 *  @param verifyPassword 确认密码
 *  @param password       密码
 *
 *  @return 密码和确认密码相同返回YES 否则返回NO
 */
+ (BOOL)checkVerifyPassword:(NSString *)verifyPassword password:(NSString *)password {
    
    if([verifyPassword isEqualToString:password]) return YES;
    
    return NO;
}

/**
 *  校验验证码位数
 *
 *  @param verificationCode 验证码
 *
 *  @return 验证码为4位返回YES 否则返回NO
 */
+ (BOOL)checkVerificationCodeLength:(NSString *)verificationCode {
    if(verificationCode.length == 4) return YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码长度为4位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    return NO;
}

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

@end
