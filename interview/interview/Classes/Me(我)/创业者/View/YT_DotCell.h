//
//  YT_DotCell.h
//  interview
//
//  Created by Mickey on 16/7/5.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBDotView;
@interface YT_DotCell : UITableViewCell
@property (weak,nonatomic)UILabel *titleLable;


- (void)showDotViewWithTitleLable:(UILabel *)lable;

- (void)hideDot;

@end
