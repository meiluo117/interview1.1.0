//
//  YT_InvestorForMeDateCell.h
//  interview
//
//  Created by 于波 on 16/4/12.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YT_listDateInvestorListModel;

@interface YT_InvestorForMeDateCell : UITableViewCell
/**
 *  团队名称
 */
@property (weak, nonatomic) IBOutlet UILabel *TeamNameLable;
/**
 *  白色背景
 */
@property (weak, nonatomic) IBOutlet UIView *bgView;
/**
 *  约见时间
 */
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLable;
/**
 *  约见地点
 */
@property (weak, nonatomic) IBOutlet UILabel *datePlaceLable;
/**
 *  订单时间
 */
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLable;
/**
 *  订单状态
 */
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLable;//projectFounderName
/**
 *  创业者姓名
 */


@property (strong,nonatomic)YT_listDateInvestorListModel *model;

@end
