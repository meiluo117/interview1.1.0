//
//  AppDelegate.h
//  interview
//
//  Created by 于波 on 16/3/12.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong,nonatomic) NSDictionary *userInfoDict;
@property (assign,nonatomic) BOOL isNewVersion;
@property (strong, nonatomic) UIWindow *window;

/*
问题一：app未启动，收到两条推送消息，点击其中一条进入app并push出相应页面，此时点击push出来的页面的返回，是否正确？是否获取我的那个接口，并在tabbar“我”显示小红点？（因为只是读了其中一条推送消息，还有另外一条没有读，需要tabbar“我”，还显示一个小红点）
 
 √ 问题二：推送进入投资人接受或者拒绝的页面，投资人点击拒绝，跳转22拒绝页面，点击返回，不是返回tabbar“我”，而是返回上一页
 
 √ 问题三：app没启动 点击推送进入相关页面并已读  但是在tabbar“我”的红点还显示
 
 √ 问题四：app在后台，定留在tabbar“我”，没有跳转
 
 √ 问题五：app在前台，在tabbar“我”，收到推送消息，tabbar“我”显示红点，但是我约的的投资人或者约见团队上面的红点不显示
 
 √ 问题六：收到推送，点击icon进入app，app从后台进入前台，tabbar”我“不显示红点  ？？？？
 
√ 问题七：版本更新
 
 问题八：用户没登录，收到广播信息
 
 问题九：重新检查注册流程，以免出现请求的转圈不消失的情况
 
√ 问题十 ： 在tabbar“我”，进入后台，在进入前台，tabbar“我”显示红点，但是我越的投资人没有红点
 
 */

@end

