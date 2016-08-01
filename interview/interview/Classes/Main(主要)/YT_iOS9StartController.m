//
//  YT_iOS9StartController.m
//  interview
//
//  Created by Mickey on 16/7/27.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_iOS9StartController.h"

@interface YT_iOS9StartController ()
@property (weak, nonatomic) IBOutlet UIImageView *startImageView;

@end

@implementation YT_iOS9StartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IPHONE_6P) {
        self.startImageView.image = [UIImage imageNamed:@"1242x2208@3x"];
    }else if (IS_IPHONE_6){
        self.startImageView.image = [UIImage imageNamed:@"750x1334"];
    }else if (IS_IPHONE_5){
        self.startImageView.image = [UIImage imageNamed:@"640x1136"];
    }else if (IS_IPHONE_4_OR_LESS){
        self.startImageView.image = [UIImage imageNamed:@"640x960"];
    }
}

@end
