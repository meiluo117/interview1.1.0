//
//  YT_SetCreateInfoCell.m
//  interview
//
//  Created by 于波 on 16/3/23.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_SetCreateInfoCell.h"

@implementation YT_SetCreateInfoCell

- (void)awakeFromNib {
    self.titleLable.textColor = YT_ColorFromRGB(0x878787);
    self.infoLable.textColor = YT_ColorFromRGB(0x878787);
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    self.infoLable.font = [UIFont systemFontOfSize:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
