//
//  YT_CreateDateCollectionCell.h
//  interview
//
//  Created by Mickey on 16/5/25.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YT_listCreateIndustryListModel;
@interface YT_CreateDateCollectionCell : UICollectionViewCell
@property (strong,nonatomic) YT_listCreateIndustryListModel *model;
@property (nonatomic,weak)UILabel *label;
@end
