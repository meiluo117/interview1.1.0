//
//  YT_HomeCell.m
//  interview
//
//  Created by 于波 on 16/3/22.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_HomeCell.h"
#import "YBStar.h"

@interface YT_HomeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *partnerLable;
@property (weak, nonatomic) IBOutlet UILabel *detailsLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (nonatomic,strong) YBStar *starView;

@end

@implementation YT_HomeCell

- (void)awakeFromNib {
    [self createUI];
}

- (void)createUI
{
    self.iconImageView.backgroundColor = [UIColor redColor];
    self.iconImageView.layer.cornerRadius = 30.0f;
    self.nameLable.textColor = YT_ColorFromRGB(0x39a16a);
    self.priceLable.textColor = YT_ColorFromRGB(0x39a16a);
    
    self.starView = [[YBStar alloc]initWithFrame:CGRectMake(15, 67, 132, 21)];
    [self.contentView addSubview:self.starView];
}

- (void)setModel:(YT_HotInvestorsModel *)model
{
    [self.starView segmentStar:@"3"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
