//
//  UIButton+YBExtension.h
//  interview
//
//  Created by 于波 on 16/3/23.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YBExtension)


+ (UIButton *)greenBtnWithTarget:(id)target Action:(SEL)action btnTitle:(NSString *)title btnX:(CGFloat)btnX btnY:(CGFloat)btnY andBtnWidth:(CGFloat)btnWidth;

+ (UIButton *)otherBtnWithTarget:(id)target Action:(SEL)action btnTitle:(NSString *)title andBtnFrame:(CGRect)btnFrame;

+ (UIButton *)chooseBtnWithTarget:(id)target Action:(SEL)action btnTitle:(NSString *)title andBtnFrame:(CGRect)btnFrame;

+ (UIButton *)dateBtnWithTarget:(id)target Action:(SEL)action btnTitle:(NSString *)title andBtnFrame:(CGRect)btnFrame;
@end
