//
//  YT_DotCell.m
//  interview
//
//  Created by Mickey on 16/7/5.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_DotCell.h"
#import "YBDotView.h"

@interface YT_DotCell()
@property (strong,nonatomic) YBDotView *dotView;
@end

@implementation YT_DotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        self.height = 60;
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, (self.height - 20) / 2, 40, 20)];
        lable.textColor = YT_ColorFromRGB(0x878787);
        lable.font = [UIFont systemFontOfSize:14];
        self.titleLable = lable;
        [self.contentView addSubview:self.titleLable];
        
        
    }
    return self;
}

- (void)showDotViewWithTitleLable:(UILabel *)lable
{
    self.dotView = [[YBDotView alloc] init];
    self.dotView.x = CGRectGetMaxX(lable.frame) + 7;
    self.dotView.y = (self.height - 9) / 2;
    [self.contentView addSubview:self.dotView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLable sizeToFit];
}

- (void)hideDot
{
    [self removeDotView];
}

- (void)removeDotView
{
    if (_dotView) {
        for (UIView *dot in self.contentView.subviews) {
            if ([dot isKindOfClass:[YBDotView class]]) {
                [dot removeFromSuperview];
            }
        }
    }
    
}

@end
