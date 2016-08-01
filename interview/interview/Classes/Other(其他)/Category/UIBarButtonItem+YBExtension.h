//
//  UIBarButtonItem+YBExtension.h
//  interview
//
//  Created by 于波 on 16/3/21.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (YBExtension)

+ (UIBarButtonItem *)itemWithTarget:(id)target
                             Action:(SEL)action
                              image:(NSString *)image
                          highImage:(NSString *)highImage;

+ (UIBarButtonItem *)itemWithTarget:(id)target
                             Action:(SEL)action
                              image:(NSString *)image;

@end
