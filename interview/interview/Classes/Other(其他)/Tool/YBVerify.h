//
//  YBVerify.h
//  interview
//
//  Created by 于波 on 16/3/25.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBVerify : NSObject

/**
 *  验证手机号是否为空
 *
 *  @param mobileNum 手机
 *
 *  @return 手机号为空返回YES，否则返回NO
 */
+ (BOOL)isPobileNumEmpty:(NSString *)mobileNum;

/**
 *  验证手机号合法性
 *
 *  @param mobileNum 手机号
 *
 *  @return 手机号合法返回YES，否则返回NO
 */
+ (BOOL)isPhoneNumAvailability:(NSString *)mobileNum;

/**
 *  校验密码位数
 *
 *  @param password 密码
 *
 *  @return 密码位数是在6-12之间返回YES，否则返回NO
 */
+ (BOOL)checkLengthOfPassword:(NSString *)password;

/**
 *  校验确认密码和密码是否相同
 *
 *  @param verifyPassword 确认密码
 *  @param password       密码
 *
 *  @return 密码和确认密码相同返回YES 否则返回NO
 */
+ (BOOL)checkVerifyPassword:(NSString *)verifyPassword password:(NSString *)password;

/**
 *  校验验证码位数
 *
 *  @param verificationCode 验证码
 *
 *  @return 验证码为4位返回YES 否则返回NO
 */
+ (BOOL)checkVerificationCodeLength:(NSString *)verificationCode;

/**
 *  校验身份证
 *
 *  @param identityCard 身份证号
 *
 *  @return 
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
@end
