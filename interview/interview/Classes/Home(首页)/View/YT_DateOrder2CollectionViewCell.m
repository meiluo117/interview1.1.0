//
//  YT_DateOrder2CollectionViewCell.m
//  interview
//
//  Created by Mickey on 16/5/22.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_DateOrder2CollectionViewCell.h"
#import "YT_DateOrderInfoIndustryListModel.h"

@implementation YT_DateOrder2CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *lable = [[UILabel alloc]init];
        lable.font = [UIFont boldSystemFontOfSize:12];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = YT_ColorFromRGB(0xbbbbbb);
        
        self.label = lable;
        [self.contentView addSubview:self.label];
        
//        self.layer.borderWidth = 1.0f;
//        self.layer.borderColor = YT_Color(74, 163, 106, 1).CGColor;
        self.backgroundColor = YT_ColorFromRGB(0xf9f9f9);
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setModel:(YT_DateOrderInfoIndustryListModel *)model
{
    _model = model;
    self.label.text = model.value;
    [self.label sizeToFit];
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (id obj in self.contentView.subviews) {
        if ([obj isKindOfClass:[UILabel class]]) {
            ((UILabel *)obj).center = self.contentView.center;
        }
    }
}


@end
