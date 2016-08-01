//
//  YBDotView.m
//  interview
//
//  Created by Mickey on 16/6/30.
//  Copyright © 2016年 于波. All rights reserved.
//
#define dotWidthAndHeight 8.0f

#import "YBDotView.h"

@implementation YBDotView

- (void)showDotWithView:(UIView *)view
{
    [view addSubview:self];
    self.hidden = NO;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = dotWidthAndHeight / 2;
        self.width = dotWidthAndHeight;
        self.height = dotWidthAndHeight;
        
//        self.backgroundColor = YT_ColorFromRGB(0xa6e2c6);
        self.backgroundColor = [UIColor redColor];
        
    }
    return self;
}

- (void)removeDotWithView:(UIView *)view
{
    for (UIView *dot in view.subviews) {
        if ([dot isKindOfClass:[YBDotView class]]) {
            [dot removeFromSuperview];
        }
    }
}

- (void)hideDotWith:(UIView *)view
{
    self.hidden = YES;
}

@end
