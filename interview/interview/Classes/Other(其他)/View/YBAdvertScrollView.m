//
//  YBAdvertScrollView.m
//  interview
//
//  Created by 于波 on 16/3/22.
//  Copyright © 2016年 于波. All rights reserved.
//

#define ScrollView_Height ScreenWidth/15 * 9

#import "YBAdvertScrollView.h"
#import "SDCycleScrollView.h"

@interface YBAdvertScrollView ()<SDCycleScrollViewDelegate>{
    UIPageControl * _pageControl;
    NSTimer * _timer;
}

@end

@implementation YBAdvertScrollView

- (instancetype)initWithFrame:(CGRect)frame andDataSource:(NSArray *)array
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        //将所传递过来的数据源转换为全局变量(属性)
        self.advArr = array;
        
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScrollView_Height) delegate:self placeholderImage:[UIImage imageNamed:@"tupianyujiazai"]];
        
        cycleScrollView.delegate = self;
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;

        //    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        cycleScrollView.imageURLStringsGroup = self.advArr;
        self.cycleScrollView = cycleScrollView;
        
        
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cycleScrollView.frame), ScreenWidth, 10)];
        grayView.backgroundColor = YT_Color(244, 244, 244, 1);
        [self addSubview:grayView];
        
        UILabel *hotLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(grayView.frame), ScreenWidth, 20)];
        [self addSubview:hotLable];
        hotLable.text = @"热门投资人";
        hotLable.font = [UIFont systemFontOfSize:14];
        
        self.frame = CGRectMake(0, 0, ScreenWidth, _cycleScrollView.height + grayView.height + hotLable.height);
        
        [self addSubview:_cycleScrollView];
    }
    return self;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.advertDelegate respondsToSelector:@selector(tapPicIndexID:)]) {
        [self.advertDelegate tapPicIndexID:(long)index];
    }
}

@end
