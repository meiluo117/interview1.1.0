//
//  YBAdvertScrollView.h
//  interview
//
//  Created by 于波 on 16/3/22.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDCycleScrollView;
@protocol jumpAdvertWebViewDelegate <NSObject>

- (void)tapPicIndexID:(NSInteger)advertID;

@end

@interface YBAdvertScrollView : UIView

//@property (nonatomic,strong) UIScrollView *advScrollView;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;

//接收传入数据源的数组
@property (nonatomic,strong) NSArray *advArr;

//公开初始化方法 可将广告页面数据源传递过来 进行显示
- (instancetype)initWithFrame:(CGRect)frame andDataSource:(NSArray*)array;

@property (nonatomic,weak) id<jumpAdvertWebViewDelegate>advertDelegate;

@end
