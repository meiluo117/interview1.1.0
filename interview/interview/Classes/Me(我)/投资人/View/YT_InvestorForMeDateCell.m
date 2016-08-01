//
//  YT_InvestorForMeDateCell.m
//  interview
//
//  Created by 于波 on 16/4/12.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_InvestorForMeDateCell.h"
#import "YT_listDateInvestorListModel.h"

@interface YT_InvestorForMeDateCell ()
@property (weak, nonatomic) IBOutlet UIView *hotDotView;

@end

@implementation YT_InvestorForMeDateCell

- (void)setBgView:(UIView *)bgView
{
    _bgView = bgView;
    bgView.layer.cornerRadius = 8.0f;
}

- (void)setModel:(YT_listDateInvestorListModel *)model
{
    _model = model;
    self.orderStatusLable.text = model.orderStatusName;
    self.orderTimeLable.text = model.updateTime;
    self.dateTimeLable.text = model.meetTime;
    self.datePlaceLable.text = model.meetAddress;
    self.TeamNameLable.text = model.projectFounderName;
    
    if ([model.ifNotice isEqualToString:@"true"]) {
        self.hotDotView.hidden = NO;
    }else{
        self.hotDotView.hidden = YES;
    }
}

- (void)awakeFromNib {
    self.backgroundColor = bgColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
