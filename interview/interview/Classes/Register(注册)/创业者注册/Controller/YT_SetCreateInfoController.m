//
//  YT_SetCreateInfoController.m
//  interview
//
//  Created by 于波 on 16/3/23.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_SetCreateInfoController.h"
#import "YT_SetCreateInfoCell.h"
#import "YT_SetNameController.h"
#import "YT_SetCreateDetailController.h"
#import "YT_SetWechatController.h"
#import "YT_CreatePersonInfoModel.h"
#import "UploadFormData.h"
#import "STPhotoKitController.h"
#import "UIImagePickerController+ST.h"
#import "STConfig.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface YT_SetCreateInfoController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate, STPhotoKitDelegate>
@property (nonatomic,weak)UITableView *tableV;
@property (nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic,weak)UIImageView *headImageV;
@end

@implementation YT_SetCreateInfoController

- (NSMutableArray *)titleArray
{
    if (nil == _titleArray) {
        self.titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableV reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.isExistBtn = YES;
    [self createUI];
    [self createheadView];
    
    self.NavTitle = self.navTitleString;
    NSArray *titleArr = @[@"真实姓名",@"微信号",@"手机号"];
    self.titleArray = [NSMutableArray arrayWithArray:titleArr];
}

- (void)createheadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
    headView.backgroundColor = YT_Color(226, 252, 240, 1);
    self.tableV.tableHeaderView = headView;
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 80) / 2, 30, 80, 80)];
    [headView addSubview:headImageView];
    headImageView.layer.cornerRadius = 80 / 2;
    headImageView.layer.masksToBounds = YES;
    if ([YT_CreatePersonInfoModel sharedPersonInfoModel].headImg.length != 0) {
        [headImageView sd_setImageWithURL:[NSURL URLWithString:[YT_CreatePersonInfoModel sharedPersonInfoModel].headImg]];
    }else{
        headImageView.image = [UIImage imageNamed:@"touxiang"];
    }
    headImageView.userInteractionEnabled = YES;
    self.headImageV = headImageView;
    UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedIcon)];
    [self.headImageV addGestureRecognizer:tapHead];
    
    UILabel *headLable = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 100) / 2, CGRectGetMaxY(headImageView.frame) + 5, 100, 30)];
    [headView addSubview:headLable];
    headLable.textColor = [UIColor grayColor];
    headLable.text = @"头像";
    headLable.textAlignment = NSTextAlignmentCenter;
    headLable.font = [UIFont systemFontOfSize:14];
}

- (void)selectedIcon
{
    [self editImageSelected];
}

//- (void)chooseHeadPic
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
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    UIImage *image = (UIImage *)info[@"UIImagePickerControllerEditedImage"];
//    NSData *data = UIImageJPEGRepresentation(image, 0);
//    [UploadFormData sharedImageModel].data = data;
////    self.headImageV.image = [UIImage imageWithData:data];
//    [self sendImageRequest];
//}

- (void)sendImageRequest
{
    YT_WS(weakSelf);
    [UploadFormData sharedImageModel].name = @"file";
    [UploadFormData sharedImageModel].fileName = @"headImage.jpeg";
    [UploadFormData sharedImageModel].mimeType = @"image/jpeg";
    UploadFormData *uploadParams = [[UploadFormData alloc] init];
    
    [YBHttpNetWorkTool post:Url_Up_Head params:nil uploadParams:uploadParams success:^(id json) {
        YT_LOG(@"上传头像json%@",json);
        NSInteger status = [json[@"code"] integerValue];
        if (status == 1) {
            [SVProgressHUD dismiss];
            NSDictionary *dataDict = json[@"data"];
            [YT_CreatePersonInfoModel sharedPersonInfoModel].headImg = dataDict[@"url"];
            [weakSelf.headImageV sd_setImageWithURL:dataDict[@"url"]];
            YT_LOG(@"上传头像成功");
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        YT_LOG(@"创业者上传头像error%@",error);
    } header:[YT_CreatePersonInfoModel sharedPersonInfoModel].ticket ShowWithStatusText:@"正在上传..."];
}

- (void)createUI
{
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 403) style:UITableViewStylePlain];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.bounces = NO;
    tableV.showsVerticalScrollIndicator = NO;
    tableV.showsHorizontalScrollIndicator = NO;
    self.tableV = tableV;
    [self.view addSubview:self.tableV];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 8.0f;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = btnColor;
    btn.frame = CGRectMake(20, CGRectGetMaxY(self.tableV.frame) + 30, ScreenWidth - 40, 40);
    [btn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn = btn;
    if (!self.isExistBtn) {
        self.nextBtn.hidden = YES;
    }else{
        self.nextBtn.hidden = NO;
    }
    [self.view addSubview:self.nextBtn];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * string = @"setCreateInfo";
    
    YT_SetCreateInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YT_SetCreateInfoCell" owner:self options:nil] lastObject];
    }
    cell.titleLable.text = self.titleArray[indexPath.row];
    
    if (indexPath.row == 0) {
        cell.infoLable.text = [YT_CreatePersonInfoModel sharedPersonInfoModel].realName;
        if (cell.infoLable.text.length == 0) {
            cell.infoLable.text = @"(必填)";
        }
        
    }else if (indexPath.row == 1){
        cell.infoLable.text = [YT_CreatePersonInfoModel sharedPersonInfoModel].wechat;
        
    }else{
        cell.infoLable.text = [YT_CreatePersonInfoModel sharedPersonInfoModel].mobile;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        YT_SetNameController *setNameVc = [[YT_SetNameController alloc] init];
        [self.navigationController pushViewController:setNameVc animated:YES];
    }else if (indexPath.row == 1){
        YT_SetWechatController *setWecharVc = [[YT_SetWechatController alloc] init];
        [self.navigationController pushViewController:setWecharVc animated:YES];
    }
}

- (void)next:(UIButton *)btn
{
    if ([YT_CreatePersonInfoModel sharedPersonInfoModel].realName.length == 0) {
        [self showAlertTitle:@"提示" andDetail:@"请填写您的真实姓名"];
    }else if ([YT_CreatePersonInfoModel sharedPersonInfoModel].headImg.length == 0){
        [self showAlertTitle:@"提示" andDetail:@"请上传头像"];
    }else{
        YT_SetCreateDetailController *setCreateDetailVc = [[YT_SetCreateDetailController alloc] init];
        [self.navigationController pushViewController:setCreateDetailVc animated:YES];
    }
}

- (void)showAlertTitle:(NSString *)title andDetail:(NSString *)detail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:detail delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
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
    self.headImageV.image = resultImage;
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

@end
