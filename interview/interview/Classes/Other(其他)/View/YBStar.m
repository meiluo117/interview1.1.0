//
//  YBStar.m
//  interview
//
//  Created by 于波 on 16/3/22.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YBStar.h"

@implementation YBStar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self createUI];
        //如果图片视图进行分割 分割以后的视图显示在另一个UIVIew视图上 那么被分割的视图需要在initWithCoder方法中调用一下 否则看不到分割效果
    }
    return self;
}
-(void)createUI
{
    backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 23)];//65 23
    backImageView.image = [UIImage imageNamed:@"xingxinghuise"];
    [self addSubview:backImageView];
    
    foreImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 23)];
    foreImageView.image = [UIImage imageNamed:@"xingxinglvse"];
    [self addSubview:foreImageView];
    
    //对前面的图片视图进行分割
    backImageView.clipsToBounds = YES;
    foreImageView.clipsToBounds = YES;
    //设置图片视图的停靠方向
    backImageView.contentMode = UIViewContentModeLeft;
    foreImageView.contentMode = UIViewContentModeLeft;
    
}
-(void)segmentStar:(NSString *)level
{
    foreImageView.frame = CGRectMake(0, 0, backImageView.frame.size.width * ([level doubleValue] / 5), backImageView.frame.size.height);
}

@end
