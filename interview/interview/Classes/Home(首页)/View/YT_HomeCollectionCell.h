//
//  YT_HomeCollectionCell.h
//  interview
//
//  Created by 于波 on 16/3/30.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YT_IndustryModel;
@interface YT_HomeCollectionCell : UICollectionViewCell
@property (nonatomic,weak)UILabel *label;
@property (nonatomic,strong)YT_IndustryModel *model;


@end
