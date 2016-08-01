//
//  YBStar.h
//  interview
//
//  Created by 于波 on 16/3/22.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBStar : UIView
{
    UIImageView * backImageView;
    UIImageView * foreImageView;
}

//设置星级 将star图片进行分割
-(void)segmentStar:(NSString *)level;

@end
