//
//  UIButton+YBExtension.m
//  interview
//
//  Created by 于波 on 16/3/23.
//  Copyright © 2016年 于波. All rights reserved.
//
#import "UIButton+YBExtension.h"

@implementation UIButton (YBExtension)

+ (UIButton *)greenBtnWithTarget:(id)target Action:(SEL)action btnTitle:(NSString *)title btnX:(CGFloat)btnX btnY:(CGFloat)btnY andBtnWidth:(CGFloat)btnWidth
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = btnColor;
    btn.layer.cornerRadius = 8.0f;
    btn.frame = CGRectMake(btnX, btnY, btnWidth, 40);
    return btn;
}

+ (UIButton *)otherBtnWithTarget:(id)target Action:(SEL)action btnTitle:(NSString *)title andBtnFrame:(CGRect)btnFrame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:YT_ColorFromRGB(0x39a16a) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = btnFrame;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    return btn;
}

+ (UIButton *)chooseBtnWithTarget:(id)target Action:(SEL)action btnTitle:(NSString *)title andBtnFrame:(CGRect)btnFrame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:@"xuanxiang-bai"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"xuanxiang-lv"] forState:UIControlStateSelected];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.frame = btnFrame;
    return btn;
}

+ (UIButton *)dateBtnWithTarget:(id)target Action:(SEL)action btnTitle:(NSString *)title andBtnFrame:(CGRect)btnFrame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:YT_ColorFromRGB(0xacdcc1) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:@"111-bai"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"111-lv"] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.frame = btnFrame;
    
    return btn;
}

@end
