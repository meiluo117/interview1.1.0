//
//  UITabBar+YBbadge.h
//  interview
//
//  Created by Mickey on 16/6/29.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (YBbadge)

/**
 *  显示小红点
 */
- (void)showBadgeOnItemIndex:(int)index;

/**
 *  隐藏小红点
 */
- (void)hideBadgeOnItemIndex:(int)index;

@end
