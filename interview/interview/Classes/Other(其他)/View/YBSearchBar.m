//
//  YBSearchBar.m
//  微博Text
//
//  Created by 于波 on 16/3/1.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YBSearchBar.h"

@implementation YBSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.font = [UIFont systemFontOfSize:14];
        self.placeholder = @"搜索投资人姓名/公司";
        self.background = [UIImage imageNamed:@"sosuokuang2"];
        self.returnKeyType = UIReturnKeySearch;
        self.layer.cornerRadius = 3;
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"fangdajing"];
        searchIcon.width = 30;
        searchIcon.height = 30;
        searchIcon.contentMode = UIViewContentModeCenter;//设置图片不拉伸 居中
        
        //添加小放大镜到testfiled的左侧
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

+ (instancetype)searchBar
{
    return [[self alloc] init];
}


@end
