//
//  YT_InvestorForMeInfoController.m
//  interview
//
//  Created by 于波 on 16/4/12.
//  Copyright © 2016年 于波. All rights reserved.
//

typedef NS_ENUM(NSInteger, PhotoType)
{
    PhotoTypeIcon,
    PhotoTypeRectangle,
};

#import "YT_InvestorForMeInfoController.h"
#import "YT_CardCell.h"
#import "UIButton+YBExtension.h"
#import "YT_SetNameController.h"
#import "YT_SetCompanyController.h"
#import "YT_SetJobController.h"
#import "YT_ItemTagController.h"
#import "YT_SuccessfulCaseController.h"
#import "YT_SetWechatController.h"
#import "YT_SetCreateInfoCell.h"
#import "YT_InvestorPersonInfoModel.h"
#import "YT_ChooseCityController.h"
#import "YT_Enum.h"
#import "UploadFormData.h"
#import "YT_InvestorIntroduceController.h"
#import "YT_itemTagForMeController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "STPhotoKitController.h"
#import "UIImagePickerController+ST.h"
#import "STConfig.h"

@interface YT_InvestorForMeInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate, STPhotoKitDelegate>
@property (nonatomic,strong)NSArray *titleArray;
@property (assign,nonatomic) NSInteger imageStatus;
@property (nonatomic,weak)UIImageView *headImageView;
@property (nonatomic,weak)UIImageView *cardImageView;
@property (nonatomic, assign) PhotoType type;
@end

@implementation YT_InvestorForMeInfoController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createheadView];
//    [self createFootView];
}
- (void)createheadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
    headView.backgroundColor = YT_Color(226, 252, 240, 1);
    self.tableView.tableHeaderView = headView;
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 80) / 2, 30, 80, 80)];
    [headView addSubview:headImageView];
    headImageView.layer.cornerRadius = 80 / 2;
    if ([YT_InvestorPersonInfoModel sharedPersonInfoModel].headImg.length != 0) {
        [headImageView sd_setImageWithURL:[NSURL URLWithString:[YT_InvestorPersonInfoModel sharedPersonInfoModel].headImg]];
    }else{
        headImageView.image = [UIImage imageNamed:@"touxiang"];
    }
    
    headImageView.userInteractionEnabled = YES;
    headImageView.layer.masksToBounds = YES;
    headImageView.tag = 1000;
    self.headImageView = headImageView;
    UITapGestureRecognizer *tapToCancelKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedIcon)];
    [self.headImageView addGestureRecognizer:tapToCancelKeyboard];
    
    UILabel *headLable = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 100) / 2, CGRectGetMaxY(headImageView.frame) + 5, 100, 30)];
    [headView addSubview:headLable];
    headLable.textColor = [UIColor grayColor];
    headLable.text = @"头像";
    headLable.textAlignment = NSTextAlignmentCenter;
    headLable.font = [UIFont systemFontOfSize:14];
}

//- (void)createFootView
//{
//    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
//    footView.backgroundColor = YT_Color(239, 239, 244, 1);
//    self.tableView.tableFooterView = footView;
//    UIButton *finishBtn = [UIButton greenBtnWithTarget:self Action:@selector(finishBtnClick:) btnTitle:@"完成" btnX:20 btnY:10 andBtnWidth:ScreenWidth - 40];
//    [footView addSubview:finishBtn];
//}

- (void)createUI {
    self.navigationItem.title = @"个人信息";
    self.titleArray = @[@[@"真实姓名",@"地区",@"公司",@"职位",@"关注领域",@"投资案例"],@[@"微信",@"手机号"],@[@"个人简介"]];
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    tableV.bounces = NO;
    tableV.showsVerticalScrollIndicator = NO;
    tableV.showsHorizontalScrollIndicator = NO;
    self.tableView = tableV;
}

- (void)selectedIcon
{
    self.type = PhotoTypeIcon;
    [self editImageSelected];
}

- (void)selectedRectangle{
    self.type = PhotoTypeRectangle;
    [self editImageSelected];
}

- (void)sendImageRequest:(NSString *)url
{
    YT_WS(weakSelf);
    [UploadFormData sharedImageModel].name = @"file";
    [UploadFormData sharedImageModel].fileName = @"headImage.jpeg";
    [UploadFormData sharedImageModel].mimeType = @"image/jpeg";
    UploadFormData *uploadParams = [UploadFormData sharedImageModel];
    
    [YBHttpNetWorkTool post:url params:nil uploadParams:uploadParams success:^(id json) {
        YT_LOG(@"上传头像json%@",json);
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDict = json[@"data"];
            switch (self.type) {
                case PhotoTypeIcon:
                    [YT_InvestorPersonInfoModel sharedPersonInfoModel].headImg = dataDict[@"url"];
                    [weakSelf.headImageView sd_setImageWithURL:dataDict[@"url"]];
                    break;
                    
                case PhotoTypeRectangle:
                    [YT_InvestorPersonInfoModel sharedPersonInfoModel].card = dataDict[@"url"];
                    [weakSelf.cardImageView sd_setImageWithURL:dataDict[@"url"]];
                    break;
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        YT_LOG(@"投资人上传头像error%@",error);
    } header:[YT_InvestorPersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:@"正在上传..."];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.titleArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return 1;
    }else{
        return [self.titleArray[section] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return 220.0f;
    }else{
        return 60.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            YT_SetNameController *setNameVc = [[YT_SetNameController alloc] init];
            [self.navigationController pushViewController:setNameVc animated:YES];
        }else if (indexPath.row == 1){
            YT_ChooseCityController *chooseCityVc = [[YT_ChooseCityController alloc] init];
            [self.navigationController pushViewController:chooseCityVc animated:YES];
        }else if (indexPath.row == 2){
            YT_SetCompanyController *setCompanyVc = [[YT_SetCompanyController alloc] init];
            [self.navigationController pushViewController:setCompanyVc animated:YES];
        }else if (indexPath.row == 3){
            YT_SetJobController *setJobVc = [[YT_SetJobController alloc] init];
            [self.navigationController pushViewController:setJobVc animated:YES];
        }else if (indexPath.row == 4){
            YT_ItemTagController *itemTagVc = [[YT_ItemTagController alloc] init];
            [self.navigationController pushViewController:itemTagVc animated:YES];
        }else if (indexPath.row == 5){
            YT_SuccessfulCaseController *successfulCaseVc = [[YT_SuccessfulCaseController alloc] init];
            [self.navigationController pushViewController:successfulCaseVc animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            YT_SetWechatController *setWechat = [[YT_SetWechatController alloc] init];
            [self.navigationController pushViewController:setWechat animated:YES];
        }
    }else{
        YT_InvestorIntroduceController *investorIntroduceVc = [[YT_InvestorIntroduceController alloc] init];
        [self.navigationController pushViewController:investorIntroduceVc animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *setCreateInfo = @"setCreateInfo";
    
    YT_SetCreateInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:setCreateInfo];
    if (indexPath.section != 3) {
        
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YT_SetCreateInfoCell" owner:self options:nil] lastObject];
        }
        cell.titleLable.text = self.titleArray[indexPath.section][indexPath.row];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {//真实姓名
                cell.infoLable.text = [YT_InvestorPersonInfoModel sharedPersonInfoModel].realName;
                if (cell.infoLable.text.length == 0) {
                    cell.infoLable.text = @"(必填)";
                }
            }else if (indexPath.row == 1){//地区
                cell.infoLable.text = [YT_Enum productCityStatus:[[YT_InvestorPersonInfoModel sharedPersonInfoModel].provinceId integerValue]];
                if (cell.infoLable.text.length == 0) {
                    cell.infoLable.text = @"(必填)";
                }
            }else if (indexPath.row == 2){//公司
                cell.infoLable.text = [YT_InvestorPersonInfoModel sharedPersonInfoModel].company;
                if (cell.infoLable.text.length == 0) {
                    cell.infoLable.text = @"(必填)";
                }
            }else if (indexPath.row == 3){//职位
                cell.infoLable.text = [YT_InvestorPersonInfoModel sharedPersonInfoModel].position;
                if (cell.infoLable.text.length == 0) {
                    cell.infoLable.text = @"(必填)";
                }
            }else if (indexPath.row == 4){//相关领域
                cell.infoLable.text = [YT_InvestorPersonInfoModel sharedPersonInfoModel].itemTagTitle;
                if (cell.infoLable.text.length == 0) {
                    cell.infoLable.text = @"(必填)";
                }
            }else{//投资案例
                cell.infoLable.text = [YT_InvestorPersonInfoModel sharedPersonInfoModel].investorCase;
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {//微信
                cell.infoLable.text = [YT_InvestorPersonInfoModel sharedPersonInfoModel].wechat;
            }else{//手机号
                cell.infoLable.text = [YT_InvestorPersonInfoModel sharedPersonInfoModel].mobile;
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }else{//自我介绍
            cell.infoLable.text = [YT_InvestorPersonInfoModel sharedPersonInfoModel].introduce;
        }
        return cell;
        
    }else{
        YT_CardCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"YT_CardCell" owner:self options:nil] lastObject];
        cell.cardImageView.tag = 1001;
        UITapGestureRecognizer *tapToCancelKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedRectangle)];
        self.cardImageView = cell.cardImageView;
        [self.cardImageView addGestureRecognizer:tapToCancelKeyboard];
        if ([YT_InvestorPersonInfoModel sharedPersonInfoModel].card.length != 0) {
            [cell.cardImageView sd_setImageWithURL:[NSURL URLWithString:[YT_InvestorPersonInfoModel sharedPersonInfoModel].card]];
        }else{
            [cell.cardImageView setImage:[UIImage imageNamed:@"ic_placehold_for_card"]];
        }
        return cell;
    }
}

#pragma mark - --- delegate 视图委托 ---

#pragma mark - 1.STPhotoKitDelegate的委托

- (void)photoKitController:(STPhotoKitController *)photoKitController resultImage:(UIImage *)resultImage
{
    NSData *data = nil;
    switch (self.type) {
        case PhotoTypeIcon:
            self.headImageView.image = resultImage;
            data = UIImageJPEGRepresentation(resultImage, 0.5);
            [UploadFormData sharedImageModel].data = data;
            [self sendImageRequest:Url_Up_Head];
            break;
        case PhotoTypeRectangle:
            self.cardImageView.image = resultImage;
            data = UIImageJPEGRepresentation(resultImage, 0.5);
            [UploadFormData sharedImageModel].data = data;
            [self sendImageRequest:Url_Up_Card];
            break;
        default:
            break;
    }
}
#pragma mark - 2.UIImagePickerController的委托
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        STPhotoKitController *photoVC = [STPhotoKitController new];
        [photoVC setDelegate:self];
        [photoVC setImageOriginal:imageOriginal];
        
        switch (self.type) {
            case PhotoTypeIcon:
                [photoVC setSizeClip:CGSizeMake(ScreenWidth - 20, ScreenWidth - 20)];
                break;
            case PhotoTypeRectangle:
                [photoVC setSizeClip:CGSizeMake(ScreenWidth - 20, ((ScreenWidth - 20)/16) * 10)];
                break;
            default:
                break;
        }
        
        [self presentViewController:photoVC animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - --- event response 事件相应 ---
- (void)editImageSelected
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择您的照片" message:@"您可以从相机拍摄照片或者从相册中选择" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([controller isAvailableCamera] && [controller isSupportTakingPhotos]) {
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }else {
            YT_LOG(@"%s %@", __FUNCTION__, @"相机权限受限");
        }
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [controller setDelegate:self];
        if ([controller isAvailablePhotoLibrary]) {
            [self presentViewController:controller animated:YES completion:nil];
        }    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:action0];
    [alertController addAction:action1];
    [alertController addAction:action2];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
