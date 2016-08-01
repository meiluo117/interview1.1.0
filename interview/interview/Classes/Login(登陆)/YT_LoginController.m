//
//  YT_LoginController.m
//  interview
//
//  Created by 于波 on 16/3/22.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_LoginController.h"
#import "YT_HomeController.h"
#import "YT_TabBarController.h"
#import "YT_RegisterController.h"
#import "YT_RegisterNewPageController.h"
#import "YT_ForgetPwdController.h"
#import "YBVerify.h"
#import <MJExtension.h>
#import "YT_CreatePersonInfoModel.h"
#import "YT_InvestorPersonInfoModel.h"
#import "YT_ResponseModel.h"
#import "YT_InvestorItemsInfoModel.h"
#import "YT_CreateItemsInfoModel.h"
#import "YT_CommonConstList.h"
#import "UIView+FDCollapsibleConstraints.h"
#import "UMessage.h"
#import "YT_OtherUrl.h"

@interface YT_LoginController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *warningLable;
@property (weak, nonatomic) IBOutlet UIView *warningView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageV;
- (IBAction)loginBtnClick:(UIButton *)sender;
- (IBAction)forgetBtnClick:(UIButton *)sender;
- (IBAction)registerBtnClick:(UIButton *)sender;
@property (nonatomic, assign) BOOL expanding;
@end

@implementation YT_LoginController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.warningView.alpha = 0.0f;
    self.logoImageV.fd_collapsed = YES;
    YT_LOG(@"%f--%f",self.view.center.x,self.view.center.y);
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if(!IS_IPHONE_6P)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.center = CGPointMake(ScreenWidth/2, ScreenHeight/2 - 60);
        }];
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
            self.logoImageV.fd_collapsed = YES;
            [self.view layoutSubviews];
        } completion:^(BOOL finished) {
            self.expanding = !self.expanding;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
        self.logoImageV.fd_collapsed = NO;
        [self.view layoutSubviews];
    } completion:^(BOOL finished) {
        self.expanding = !self.expanding;
    }];
}

- (void)createUI
{
    //点击消除键盘
    UITapGestureRecognizer *tapToCancelKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
    [self.view addGestureRecognizer:tapToCancelKeyboard];
    
    self.phoneTextField.delegate = self;
    self.phoneTextField.tag = 10000;
    self.pwdTextField.delegate = self;
    self.phoneTextField.backgroundColor = YT_Color(226, 252, 240, 1);
    self.pwdTextField.backgroundColor = YT_Color(226, 252, 240, 1);
    self.loginBtn.backgroundColor = YT_Color(73, 161, 106, 1);
    self.loginBtn.layer.cornerRadius = 8.0f;
    
    self.warningView.alpha = 0.0f;
}

//文本校验
- (BOOL)verifyTextField{
    //检验手机号是否为空
    if([YBVerify isPobileNumEmpty:self.phoneTextField.text]){
        [self showWarning:@"手机号不能为空"];
        return NO;
    }
    //检验手机号是否合法
    if(![YBVerify isPhoneNumAvailability:self.phoneTextField.text]){
        [self showWarning:@"请输入正确的手机号"];
        return NO;
    }
    //检验密码位数
    if(![YBVerify checkLengthOfPassword:self.pwdTextField.text]){
        [self showWarning:@"请输入6-18为密码"];
        return NO;
    }
    return YES;
}

//消除键盘
-(void)cancelKeyboard{
    [self.view endEditing:YES];
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)loginBtnClick:(UIButton *)sender {
    if (![self verifyTextField]) return;
    [self sendRequest];
}

- (void)sendRequest
{
    YT_WS(weakSelf);
    NSString *loginInfo = [NSString stringWithFormat:@"%@?password=%@&username=%@&source=1",Url_Login,self.pwdTextField.text,self.phoneTextField.text];
    
    [YBHttpNetWorkTool post:loginInfo params:nil success:^(id json) {
        YT_LOG(@"登录完成----%@",json);
        NSInteger statusCode = [json[@"code"] integerValue];
        if (statusCode == 1) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDict = json[@"data"];
            [weakSelf registerUMengAliasWithUserId:dataDict[@"userId"]];
            [weakSelf savaData:dataDict];
        }else{
            [SVProgressHUD dismiss];
            [weakSelf showWarning:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [weakSelf showWarning:@"链接超时"];
    } ShowWithStatusText:@"正在登陆..."];
}
//保存用户名密码并请求个人信息
- (void)savaData:(id)obj
{
    YT_WS(weakSelf);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:weakSelf.phoneTextField.text forKey:USER_PHONE];
    [userDefaults setObject:weakSelf.pwdTextField.text forKey:USER_PASSWORD];
    [userDefaults setObject:obj[@"ticket"] forKey:USER_TOKEN];
    [userDefaults synchronize];
    
    NSInteger type = [obj[@"type"] integerValue];
    YT_LOG(@"身份:%ld",(long)type);
    if (type == 1) {
        [userDefaults setObject:@"touzi" forKey:USER_ID];
        [YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket = obj[@"ticket"];
    }else{
        [userDefaults setObject:@"chuangye" forKey:USER_ID];
        [YT_CreatePersonInfoModel sharedPersonInfoModel].ticket = obj[@"ticket"];
        [YT_CreatePersonInfoModel sharedPersonInfoModel].projectId = obj[@"projectId"];
    }
    
    [weakSelf sendGetUserRequest:[userDefaults objectForKey:USER_TOKEN] andUserType:type];
}

- (void)sendGetUserRequest:(NSString *)token andUserType:(NSInteger)userType
{
    YT_WS(weakSelf);
    [YBHttpNetWorkTool post:Url_UserInfo params:nil success:^(id json) {
        YT_LOG(@"----%@",json[@"msg"]);
        NSInteger statusCode = [json[@"code"] integerValue];
        if (statusCode == 1) {
            NSDictionary *dataDict = json[@"data"];
            NSMutableArray *itemTagTitleArray = [NSMutableArray array];
            NSString *indexString = [NSMutableString string];
            
            if (userType == 1) {
                [SVProgressHUD dismiss];
                [YT_InvestorPersonInfoModel mj_objectWithKeyValues:dataDict];
                
                for (YT_InvestorItemsInfoModel *model in [YT_InvestorPersonInfoModel sharedPersonInfoModel].industryList) {
                    [itemTagTitleArray addObject:model.value];
                }
                [YT_InvestorPersonInfoModel sharedPersonInfoModel].itemArray = [itemTagTitleArray copy];
                
                for (NSString *str in itemTagTitleArray) {
                    indexString = [indexString stringByAppendingFormat:@"%@,",str];
                    [YT_InvestorPersonInfoModel sharedPersonInfoModel].itemTagTitle = [indexString substringToIndex:indexString.length - 1];
                }
                
            }else{
                [YT_CreatePersonInfoModel mj_objectWithKeyValues:dataDict];
                
                for (YT_CreateItemsInfoModel *model in [YT_CreatePersonInfoModel sharedPersonInfoModel].industryList) {
                    [itemTagTitleArray addObject:model.value];
                }
                [YT_CreatePersonInfoModel sharedPersonInfoModel].itemArray = [itemTagTitleArray copy];
                
                for (NSString *str in itemTagTitleArray) {
                    indexString = [indexString stringByAppendingFormat:@"%@,",str];
                    [YT_CreatePersonInfoModel sharedPersonInfoModel].itemTagTitle = [indexString substringToIndex:indexString.length - 1];
                }
                
                
                NSString *itemIndex = [NSMutableString string];
                for (YT_CreateItemsInfoModel *model in [YT_CreatePersonInfoModel sharedPersonInfoModel].industryList) {
                    itemIndex = [itemIndex stringByAppendingFormat:@"%@,",model.index];
                    [YT_CreatePersonInfoModel sharedPersonInfoModel].itemTag = [itemIndex substringToIndex:itemIndex.length - 1];
                }
            }
            //跳转首页小动画 UIViewAnimationOptionTransitionFlipFromBottom
            [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                YT_TabBarController *tabBar = [[YT_TabBarController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = tabBar;
            }completion:NULL];
            
        }else{
            [SVProgressHUD dismiss];
            [weakSelf removeUserInfo];
            [weakSelf showWarning:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf removeUserInfo];
    } header:token ShowWithStatusText:@"正在登陆..."];
}
//忘记密码
- (IBAction)forgetBtnClick:(UIButton *)sender {
    YT_ForgetPwdController *forgetPwdVc = [[YT_ForgetPwdController alloc] init];
    [self.navigationController pushViewController:forgetPwdVc animated:YES];
}
//注册
- (IBAction)registerBtnClick:(UIButton *)sender
{
//    YT_RegisterController *registerVc = [[YT_RegisterController alloc] init];
    YT_RegisterNewPageController *registerVc = [[YT_RegisterNewPageController alloc] init];
    [self.navigationController pushViewController:registerVc animated:YES];
}

- (void)showWarning:(NSString *)warningStr
{
    self.warningLable.text = warningStr;
    self.warningView.alpha = 1.0f;
    [UIView animateWithDuration:WarningTime animations:^{
        self.warningView.alpha = 0.0f;
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@""]) return YES;
    
    if (textField.tag == 10000 && textField.text.length >= 11) {
        return NO;
    }else{
        return YES;
    }
}

- (void)removeUserInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USER_PHONE];
    [userDefaults removeObjectForKey:USER_PASSWORD];
    [userDefaults removeObjectForKey:USER_TOKEN];
    [userDefaults synchronize];
    [[YT_CreatePersonInfoModel sharedPersonInfoModel] clear];
    [[YT_InvestorPersonInfoModel sharedPersonInfoModel] clear];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerUMengAliasWithUserId:(NSString *)userId
{
    [UMessage addAlias:userId type:PushAlias response:^(id responseObject, NSError *error) {
        YT_LOG(@"addAlias_responseObject---%@",responseObject);
    }];
}
@end
