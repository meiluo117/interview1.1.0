//
//  YT_HomeCollectionCell.m
//  interview
//
//  Created by 于波 on 16/3/30.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_HomeCollectionCell.h"
#import "YT_IndustryModel.h"

@implementation YT_HomeCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
//        UILabel *lable = [[UILabel alloc]init];
//        lable.font = [UIFont boldSystemFontOfSize:12];
//        lable.textAlignment = NSTextAlignmentCenter;
//        lable.textColor = YT_ColorFromRGB(0xbbbbbb);

//        self.label = lable;
//        [self.contentView addSubview:self.label];
        
//        self.layer.borderWidth = 1.0f;
//        self.layer.borderColor = YT_Color(74, 163, 106, 1).CGColor;
        self.backgroundColor = YT_ColorFromRGB(0xf9f9f9);
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
    }
    return self;
}

- (UILabel *)label
{
    if (nil == _label) {
        UILabel *lable = [[UILabel alloc]init];
        lable.font = [UIFont boldSystemFontOfSize:12];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = YT_ColorFromRGB(0xbbbbbb);
        self.label = lable;
        [self.contentView addSubview:self.label];
    }
    return _label;
}

- (void)setModel:(YT_IndustryModel *)model
{
    _model = model;
    self.label.text = model.value;
//    [self.label sizeToFit];
//    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    YT_LOG(@"2222222222222222222222");
    [self.label sizeToFit];
    for (id obj in self.contentView.subviews) {
        if ([obj isKindOfClass:[UILabel class]]) {
//            ((UILabel *)obj).center = CGPointMake(self.contentView.frame.size.width/2, self.contentView.frame.size.height/2);
            ((UILabel *)obj).center = self.contentView.center;
        }
    }

}



@end
