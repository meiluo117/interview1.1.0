//
//  YT_dateTimeAndPlaceController.m
//  interview
//
//  Created by Mickey on 16/5/6.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_dateTimeAndPlaceController.h"
#import "YT_datePlaceController.h"
#import "KMDatePicker.h"
#import "DateHelper.h"
#import "NSDate+CalculateDay.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_InvestorPersonInfoModel.h"
#import "YT_investorDate2Controller.h"

@interface YT_dateTimeAndPlaceController ()<UITextFieldDelegate,KMDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UILabel *placeLable;
@property (weak, nonatomic) IBOutlet UITextField *txtFYearMonthDayHourMinute;
- (IBAction)finishBtnClick:(UIButton *)sender;
@property (strong, nonatomic) NSArray *titleArray;
@end

@implementation YT_dateTimeAndPlaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.navigationItem.title = @"约见时间和地点";
    self.titleArray = @[@"时间",@"地点"];
    self.finishBtn.layer.cornerRadius = 8.0f;
    self.finishBtn.backgroundColor = btnColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(writeDatePlace)];
    [self.tapView addGestureRecognizer:tap];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect = CGRectMake(0.0, 0.0, rect.size.width, 216.0);
    // 年月日时分
    KMDatePicker *datePicker = [[KMDatePicker alloc]
                                initWithFrame:rect
                                delegate:self
                                datePickerStyle:KMDatePickerStyleYearMonthDayHourMinute];
    _txtFYearMonthDayHourMinute.inputView = datePicker;
    _txtFYearMonthDayHourMinute.delegate = self;
}

- (void)writeDatePlace
{
    YT_datePlaceController *datePlaceVc = [[YT_datePlaceController alloc] init];
    datePlaceVc.place = self.placeLable.text;
    
    YT_WS(weakSelf);
    datePlaceVc.placeBlock = ^(NSString *msg){
        weakSelf.placeLable.text = msg;
    };
    
    [self.navigationController pushViewController:datePlaceVc animated:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.txtFYearMonthDayHourMinute = textField;
}

#pragma mark - KMDatePickerDelegate
- (void)datePicker:(KMDatePicker *)datePicker didSelectDate:(KMDatePickerDateModel *)datePickerDate {
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",
                         datePickerDate.year,
                         datePickerDate.month,
                         datePickerDate.day,
                         datePickerDate.hour,
                         datePickerDate.minute
                         ];
    self.txtFYearMonthDayHourMinute.text = dateStr;
}

- (IBAction)finishBtnClick:(UIButton *)sender {
    
    if (![self timePlace]) return;
    YT_WS(weakSelf);
    NSDictionary *params = @{@"accept":@"1",
                             @"orderId":self.orderId,
                             @"time":self.txtFYearMonthDayHourMinute.text,
                             @"address":self.placeLable.text};
    
    [YBHttpNetWorkTool post:Url_Date_InvestorAccept params:params success:^(id json) {
        
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            YT_LOG(@"投资人接受订单json:%@",json);
            [SVProgressHUD showSuccessWithStatus:json[@"msg"]];
            YT_investorDate2Controller *investorDate2Vc = [[YT_investorDate2Controller alloc] init];
            investorDate2Vc.orderID = weakSelf.orderId;
            [weakSelf.navigationController pushViewController:investorDate2Vc animated:YES];
            
        }else{
            YT_LOG(@"投资人接受订单%@",json[@"msg"]);
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        YT_LOG(@"投资人接受订单error:%@",error);
    } header:[YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:@"正在提交信息..."];
}

//判断时间和地点
- (BOOL)timePlace
{
    if (self.txtFYearMonthDayHourMinute.text.length == 0 || self.placeLable.text.length == 0) {
        [self showAlertTitle:@"提示" andDetail:@"请选择约见时间或地点"];
        return NO;
    }
    return YES;
}

//提示框
- (void)showAlertTitle:(NSString *)title andDetail:(NSString *)detail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:detail delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
@end
