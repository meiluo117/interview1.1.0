//
//  YT_CardCell.m
//  interview
//
//  Created by 于波 on 16/3/23.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_CardCell.h"

@implementation YT_CardCell

- (void)awakeFromNib {
    self.cardImageView.userInteractionEnabled = YES;
    self.cardImageView.layer.cornerRadius = 5;
    self.cardImageView.layer.masksToBounds = YES;
//    self.cardImageView.image = [UIImage imageNamed:]
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
