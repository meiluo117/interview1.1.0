//
//  YT_SetCreatDetailCell.m
//  interview
//
//  Created by 于波 on 16/3/23.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_SetCreatDetailCell.h"

@implementation YT_SetCreatDetailCell

- (void)awakeFromNib {
    self.logoImageView.userInteractionEnabled = YES;
    self.logoImageView.layer.cornerRadius = 25.0f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
