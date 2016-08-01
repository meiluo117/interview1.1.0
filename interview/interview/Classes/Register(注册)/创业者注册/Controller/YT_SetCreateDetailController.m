//
//  YT_SetCreateDetailController.m
//  interview
//
//  Created by 于波 on 16/3/23.
//  Copyright © 2016年 于波. All rights reserved.
//
#import "YT_SetCreateDetailController.h"
#import "YT_SetCreatDetailCell.h"
#import "YT_ItemNameController.h"
#import "YT_ItemStepController.h"
#import "UIButton+YBExtension.h"
#import "YT_ItemExplainController.h"
#import "YT_TeamExplainController.h"
#import "YT_ItemTagController.h"
#import "YT_ChooseCityController.h"
#import "YT_SetCreateInfoCell.h"
#import "UploadFormData.h"
#import "YT_CreateItemsInfoModel.h"
#import "YT_CreatePersonInfoModel.h"
#import "YT_Enum.h"
#import "YT_IndustryModel.h"
#import "YT_HomeController.h"
#import "YT_TabBarController.h"
#import "YT_serviceWebController.h"
#import "STPhotoKitController.h"
#import "UIImagePickerController+ST.h"
#import "STConfig.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface YT_SetCreateDetailController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate, STPhotoKitDelegate>
@property (nonatomic,weak)UITableView *tableV;
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,weak)UIImageView *logoImageView;
@property (strong,nonatomic) NSMutableArray *itemTagArray;
@property (copy,nonatomic)NSString *itemTagStr;
@end

@implementation YT_SetCreateDetailController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableV reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arr = @[@[@"项目名称",@"项目阶段",@"行业标签",@"所在地区"],@[@"简单介绍您的项目",@"简单介绍您的团队"],@[@"项目商业计划书"]];
    self.array = [NSMutableArray arrayWithArray:arr];
    
    [self createUI];
    [self createHeadView];
    [self createFootView];
}

- (void)selectedIcon
{
    [self editImageSelected];
}

- (void)createFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    footView.backgroundColor = YT_Color(239, 239, 244, 1);
    self.tableV.tableFooterView = footView;
    
    UIButton *finishBtn = [UIButton greenBtnWithTarget:self Action:@selector(finish:) btnTitle:@"完成" btnX:20 btnY:10 andBtnWidth:ScreenWidth - 40];
    [footView addSubview:finishBtn];
    
//    UIButton *waitBnt = [UIButton otherBtnWithTarget:self Action:@selector(wait:) btnTitle:@"等会再完善" andBtnFrame:CGRectMake((ScreenWidth - 80) / 2, CGRectGetMaxY(finishBtn.frame) + 20, 80, 20)];
//    [footView addSubview:waitBnt];
}

- (void)createHeadView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    bgView.backgroundColor = [UIColor whiteColor];
    self.tableV.tableHeaderView = bgView;
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, (bgView.height - 20) / 2, 100, 20)];
    lable.text = @"项目logo";
    lable.textColor = YT_ColorFromRGB(0x878787);
    lable.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:lable];

    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 80, (bgView.height - 60) / 2, 60, 60)];
    logoImageView.userInteractionEnabled = YES;
    logoImageView.image = [UIImage imageNamed:@"touxiang"];
    logoImageView.layer.cornerRadius = logoImageView.width / 2;
    logoImageView.layer.masksToBounds = YES;
    
    self.logoImageView = logoImageView;
    UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedIcon)];
    [self.logoImageView addGestureRecognizer:tapHead];
    [bgView addSubview:self.logoImageView];
}

- (void)createUI
{
    self.NavTitle = @"完善项目信息";
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.bounces = NO;
    tableV.showsVerticalScrollIndicator = NO;
    tableV.showsHorizontalScrollIndicator = NO;
    self.tableV = tableV;
    [self.view addSubview:self.tableV];
    
    NSString *str = [NSMutableString string];
    for (YT_IndustryModel *model in [YT_CreatePersonInfoModel sharedPersonInfoModel].industryList) {
        str = [str stringByAppendingFormat:@"%@,",model.value];
        [self.itemTagArray addObject:model.value];//将每个行业标签添加到数组
    }
    
    if (self.itemTagStr.length != 0) {
        self.itemTagStr = [str substringToIndex:str.length - 1];
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * setCreateInfo = @"setCreateInfo";
    
    YT_SetCreateInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:setCreateInfo];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YT_SetCreateInfoCell" owner:self options:nil] lastObject];
    }
    cell.titleLable.text = self.array[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.infoLable.text = [YT_CreatePersonInfoModel sharedPersonInfoModel].name;
            if (cell.infoLable.text.length == 0) {//项目名称
                cell.infoLable.text = @"(必填)";
            }
        }else if (indexPath.row == 1){//项目阶段
            cell.infoLable.text = [YT_Enum productItemStatus:[[YT_CreatePersonInfoModel sharedPersonInfoModel].stage integerValue]];
            if (cell.infoLable.text.length == 0) {
                cell.infoLable.text = @"(必填)";
            }
        }else if (indexPath.row == 2){
        
            cell.infoLable.text = [YT_CreatePersonInfoModel sharedPersonInfoModel].itemTagTitle;
            if (cell.infoLable.text.length == 0) {
                cell.infoLable.text = self.itemTagStr;
            }
            
            if (cell.infoLable.text.length == 0) {//行业标签
                cell.infoLable.text = @"(必填)";
            }
        }else if (indexPath.row == 3){
            cell.infoLable.text = [YT_Enum productCityStatus:[[YT_CreatePersonInfoModel sharedPersonInfoModel].provinceId integerValue]];
            if (cell.infoLable.text.length == 0) {//地区
                cell.infoLable.text = @"(必填)";
            }
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.infoLable.text = [YT_CreatePersonInfoModel sharedPersonInfoModel].introduce;

        }else if (indexPath.row == 1){//介绍您的团队
            cell.infoLable.text = [YT_CreatePersonInfoModel sharedPersonInfoModel].apntTeamIntro;
        }
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.array[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            YT_ItemNameController *itemNameVc = [[YT_ItemNameController alloc] init];
            [self.navigationController pushViewController:itemNameVc animated:YES];
        }else if (indexPath.row == 1){
            YT_ItemStepController *itemStepVc = [[YT_ItemStepController alloc] init];
            [self.navigationController pushViewController:itemStepVc animated:YES];
        }else if (indexPath.row == 2){
            YT_ItemTagController *itemTagVc = [[YT_ItemTagController alloc] init];
            [itemTagVc.indexArrayTitle addObjectsFromArray:self.itemTagArray];
            [self.navigationController pushViewController:itemTagVc animated:YES];
        }else if (indexPath.row == 3){
            YT_ChooseCityController *chooseCity = [[YT_ChooseCityController alloc] init];
            [self.navigationController pushViewController:chooseCity animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            YT_ItemExplainController *itemExplainVc = [[YT_ItemExplainController alloc] init];
            [self.navigationController pushViewController:itemExplainVc animated:YES];
        }else if (indexPath.row == 1){
            YT_TeamExplainController *teamExplainVc = [[YT_TeamExplainController alloc] init];
            [self.navigationController pushViewController:teamExplainVc animated:YES];
        }
    }else if (indexPath.section == 2){
        YT_serviceWebController *upBPVc = [[YT_serviceWebController alloc] init];
        upBPVc.navTitle = @"上传方法";
        upBPVc.url = Url_UpBP;
        [self.navigationController pushViewController:upBPVc animated:YES];
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

- (void)finish:(UIButton *)btn
{
    if ([YT_CreatePersonInfoModel sharedPersonInfoModel].name.length == 0 || [YT_CreatePersonInfoModel sharedPersonInfoModel].stage.length == 0 || [YT_CreatePersonInfoModel sharedPersonInfoModel].provinceId.length == 0 || [YT_CreatePersonInfoModel sharedPersonInfoModel].itemTag.length == 0) {
        [self showAlertTitle:@"提示" andDetail:@"请填写（必填）项"];
    }else{
//        [self sendFinishRequest];
        UITabBarController *tabBar = [[YT_TabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabBar;
    }
}

- (void)wait:(UIButton *)btn
{
    //稍后在设置 跳转首页
    UITabBarController *tabBar = [[YT_TabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBar;
}

//提示框
- (void)showAlertTitle:(NSString *)title andDetail:(NSString *)detail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:detail delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

////选择logo
//- (void)chooseLogoPic
//{
//    YT_WS(weakSelf);
//    UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:@"选择您的照片" message:@"您可以从相机拍摄照片或者从相册中选择" preferredStyle:UIAlertControllerStyleActionSheet];
//    [self presentViewController:alerVc animated:YES completion:nil];
//    
//    UIAlertAction *actionCamera     = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [weakSelf pickImageBySourceType:UIImagePickerControllerSourceTypeCamera];
//    }];
//    UIAlertAction *actionImagePicker = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [weakSelf pickImageBySourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
//    }];
//    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        
//    }];
//    [alerVc addAction:actionCamera];
//    [alerVc addAction:actionImagePicker];
//    [alerVc addAction:actionCancel];
//}
//
//- (void)pickImageBySourceType:(UIImagePickerControllerSourceType)sourceType{
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.delegate        = self;
//    imagePicker.sourceType      = sourceType;
//    imagePicker.allowsEditing   = YES;
//    [self presentViewController:imagePicker animated:YES completion:nil];
//}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    UIImage *image = (UIImage *)info[@"UIImagePickerControllerEditedImage"];
//    NSData *data = UIImageJPEGRepresentation(image, 0);
//    [UploadFormData sharedImageModel].data = data;
////    self.logoImageView.image = [UIImage imageWithData:data];
//    [self sendImageRequest];
//}

- (void)sendImageRequest
{
    YT_WS(weakSelf);
    [UploadFormData sharedImageModel].name = @"file";
    [UploadFormData sharedImageModel].fileName = @"headImage.jpeg";
    [UploadFormData sharedImageModel].mimeType = @"image/jpeg";
    UploadFormData *uploadParams = [UploadFormData sharedImageModel];
    
    [YBHttpNetWorkTool post:Url_Up_Logo params:nil uploadParams:uploadParams success:^(id json) {
        YT_LOG(@"上传logojson%@",json);
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDict = json[@"data"];
            [YT_CreatePersonInfoModel sharedPersonInfoModel].logo = dataDict[@"url"];
            [weakSelf.logoImageView sd_setImageWithURL:dataDict[@"url"]];
            [weakSelf sendItmeLogoRequest:dataDict[@"url"]];
            YT_LOG(@"上传logo成功");
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        YT_LOG(@"创业者上传头像error%@",error);
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:@"正在上传..."];
}

- (void)sendItmeLogoRequest:(NSString *)logoString
{
    NSDictionary *params = @{@"type":@"8",
                             @"value":logoString,
                             @"projectId":[YT_CreatePersonInfoModel sharedPersonInfoModel].projectId};
    
    [YBHttpNetWorkTool post:Url_ItemProduct_logo params:params success:^(id json) {
        
        NSInteger statusCode = [json[@"code"] integerValue];
        if (statusCode == 1) {
            
        }else{
            
        }
    } failure:^(NSError *error) {
        
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:nil];
}
//提交最后数据
- (void)sendFinishRequest
{
    if ([YT_CreatePersonInfoModel sharedPersonInfoModel].projectId.length == 0) {
        [YT_CreatePersonInfoModel sharedPersonInfoModel].projectId = @"";
    }if ([YT_CreatePersonInfoModel sharedPersonInfoModel].logo.length == 0) {
        [YT_CreatePersonInfoModel sharedPersonInfoModel].logo = @"";
    }if ([YT_CreatePersonInfoModel sharedPersonInfoModel].apntTeamIntro.length == 0) {
        [YT_CreatePersonInfoModel sharedPersonInfoModel].apntTeamIntro = @"";
    }if ([YT_CreatePersonInfoModel sharedPersonInfoModel].introduce.length == 0) {
        [YT_CreatePersonInfoModel sharedPersonInfoModel].introduce = @"";
    }
    
    NSDictionary *params = @{@"projectId":[YT_CreatePersonInfoModel sharedPersonInfoModel].projectId,
                             @"projectName":[YT_CreatePersonInfoModel sharedPersonInfoModel].name,
                             @"city":[YT_CreatePersonInfoModel sharedPersonInfoModel].provinceId,
                             @"industry":[YT_CreatePersonInfoModel sharedPersonInfoModel].itemTag,
                             @"stage":[YT_CreatePersonInfoModel sharedPersonInfoModel].stage,
                             @"logo":[YT_CreatePersonInfoModel sharedPersonInfoModel].logo,
                             @"introduce":[YT_CreatePersonInfoModel sharedPersonInfoModel].introduce,
                             @"apntTeamIntro":[YT_CreatePersonInfoModel sharedPersonInfoModel].apntTeamIntro,
                             @"bp":@"",
                             @"bpName":@""};
    [YBHttpNetWorkTool post:Url_CreatePerson_Items params:params success:^(id json) {
        YT_LOG(@"提交全部项目信息json:%@",json);
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            UITabBarController *tabBar = [[YT_TabBarController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBar;
            
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        YT_LOG(@"提交全部项目信息error:%@",error);
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:@"正在提交信息..."];
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

#pragma mark - --- delegate 视图委托 ---

#pragma mark - 1.STPhotoKitDelegate的委托

- (void)photoKitController:(STPhotoKitController *)photoKitController resultImage:(UIImage *)resultImage
{
    self.logoImageView.image = resultImage;
    NSData *data = UIImageJPEGRepresentation(resultImage, 0.5);
    [UploadFormData sharedImageModel].data = data;
    [self sendImageRequest];
}

#pragma mark - 2.UIImagePickerController的委托
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        STPhotoKitController *photoVC = [STPhotoKitController new];
        [photoVC setDelegate:self];
        [photoVC setImageOriginal:imageOriginal];
        
        [photoVC setSizeClip:CGSizeMake(ScreenWidth - 20, ScreenWidth - 20)];
        
        [self presentViewController:photoVC animated:YES completion:nil];
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)array
{
    if (nil == _array) {
        self.array = [NSMutableArray array];
    }
    return _array;
}

- (NSMutableArray *)itemTagArray
{
    if (nil == _itemTagArray) {
        self.itemTagArray = [NSMutableArray array];
    }
    return _itemTagArray;
}

@end
