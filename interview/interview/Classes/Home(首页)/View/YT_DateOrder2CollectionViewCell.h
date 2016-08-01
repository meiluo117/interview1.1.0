//
//  YT_DateOrder2CollectionViewCell.h
//  interview
//
//  Created by Mickey on 16/5/22.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YT_DateOrderInfoIndustryListModel;
@interface YT_DateOrder2CollectionViewCell : UICollectionViewCell
@property (nonatomic,weak)UILabel *label;
@property (nonatomic,strong)YT_DateOrderInfoIndustryListModel *model;
@end
