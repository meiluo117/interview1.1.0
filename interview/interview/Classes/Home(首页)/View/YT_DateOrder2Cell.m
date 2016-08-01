//
//  YT_DateOrder2Cell.m
//  interview
//
//  Created by Mickey on 16/5/22.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_DateOrder2Cell.h"
#import "YBStar.h"
#import "YT_DateOrder2CollectionViewCell.h"
#import "YT_DateOrderInfoRequestModel.h"
#import "YT_DateOrderInfoDataModel.h"
#import "YT_DateOrderInfoIndustryListModel.h"
#import "EqualSpaceFlowLayout.h"

@interface YT_DateOrder2Cell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,EqualSpaceFlowLayoutDelegate>{
    
    UICollectionView *_collectionView;
    NSMutableArray *_dataArray;
}
@property (nonatomic,weak) UIImageView *headImageView;
@property (weak, nonatomic) UILabel *nameLable;
@property (weak, nonatomic) UILabel *partnerLable;
@property (weak, nonatomic) UILabel *priceLable;
@property (nonatomic,weak) UILabel *personLable;
@property (nonatomic,strong)YBStar *starView;
@property (nonatomic,strong)YT_DateOrder2CollectionViewCell *cell;
@property (nonatomic,strong)NSMutableArray *industryList;
@property (weak, nonatomic) UILabel *phoneLable;
@property (weak, nonatomic) UILabel *wechatLable;
@property (weak, nonatomic) UIButton *btnPhoneNumber;
@property (weak, nonatomic) UIButton *btnWechatNumber;
@end

@implementation YT_DateOrder2Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(13, 10, 70, 70)];
        headImageV.layer.cornerRadius = 70/2;
        headImageV.layer.masksToBounds = YES;
        self.headImageView = headImageV;
        [self.contentView addSubview:self.headImageView];
        
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(95, 15, 60, 20)];
        nameLable.font = [UIFont systemFontOfSize:18];
        nameLable.textColor = btnColor;
        nameLable.textAlignment = NSTextAlignmentLeft;
        self.nameLable = nameLable;
        [self.contentView addSubview:self.nameLable];
        
        UILabel *yuanLable = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 40, 20, 30, 15)];
        yuanLable.font = [UIFont systemFontOfSize:12];
        yuanLable.textColor = [UIColor blackColor];
        yuanLable.textAlignment = NSTextAlignmentCenter;
        yuanLable.text = @"元/次";
        [self.contentView addSubview:yuanLable];
        
        UILabel *priceLable = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 55 - 55, 10, 55, 30)];
        priceLable.font = [UIFont systemFontOfSize:23];
        priceLable.textColor = btnColor;
        priceLable.textAlignment = NSTextAlignmentRight;
        self.priceLable = priceLable;
        [self.contentView addSubview:self.priceLable];
        
        //        UILabel *partnerLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 100, 15)];
        UILabel *partnerLable = [[UILabel alloc] init];
        partnerLable.font = [UIFont systemFontOfSize:12];
        partnerLable.textColor = [UIColor blackColor];
        partnerLable.textAlignment = NSTextAlignmentLeft;
        self.partnerLable = partnerLable;
        [self.contentView addSubview:self.partnerLable];
        
        UIImageView *coffeeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(23, 98, 12, 12)];
        coffeeImageV.image = [UIImage imageNamed:@"kafei"];
        [self.contentView addSubview:coffeeImageV];
        
        UILabel *personLable = [[UILabel alloc] initWithFrame:CGRectMake(38, 100, 40, 10)];
        personLable.font = [UIFont systemFontOfSize:10];
        personLable.textColor = btnColor;
        personLable.textAlignment = NSTextAlignmentLeft;
        self.personLable = personLable;
        [self.contentView addSubview:personLable];
        
        self.starView = [[YBStar alloc]initWithFrame:CGRectMake(13, 77, 65, 23)];
        [self.contentView addSubview:self.starView];
        
        //灰色分割线
        UIView *grayLineView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(coffeeImageV.frame) + 10, ScreenWidth - 10, 1)];
        grayLineView.backgroundColor = YT_Color(228, 228, 228, 1);
        [self.contentView addSubview:grayLineView];
        //手机title
        UILabel *lableN = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(grayLineView.frame) + 10, 30, 20)];
        lableN.text = @"手机";
        lableN.font = [UIFont systemFontOfSize:14];
        lableN.textColor = YT_Color(149, 149, 149, 1);
        lableN.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:lableN];
        //微信title
        UILabel *lableW = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lableN.frame) + 10, 30, 20)];
        lableW.text = @"微信";
        lableW.font = [UIFont systemFontOfSize:14];
        lableW.textColor = YT_Color(149, 149, 149, 1);
        lableW.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:lableW];
        
        //手机button
        UIButton *btnPhone = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPhone.frame = CGRectMake(CGRectGetMaxX(lableN.frame) + 5, CGRectGetMaxY(grayLineView.frame) + 10, 130, 20);
        [btnPhone setTitleColor:btnColor forState:UIControlStateNormal];
        btnPhone.titleLabel.font = [UIFont systemFontOfSize:16];
        btnPhone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btnPhone addTarget:self action:@selector(callForMe) forControlEvents:UIControlEventTouchUpInside];
        self.btnPhoneNumber = btnPhone;
        [self.contentView addSubview:self.btnPhoneNumber];
        
        //微信button
        UIButton *btnWechat = [UIButton buttonWithType:UIButtonTypeCustom];
        btnWechat.frame = CGRectMake(CGRectGetMaxX(lableW.frame) + 5, CGRectGetMaxY(self.btnPhoneNumber.frame) + 10, self.width - CGRectGetMaxX(lableW.frame) - 20, 20);
        [btnWechat setTitleColor:btnColor forState:UIControlStateNormal];
        btnWechat.titleLabel.font = [UIFont systemFontOfSize:14];
        btnWechat.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btnWechat addTarget:self action:@selector(copyWechatNumber) forControlEvents:UIControlEventTouchUpInside];
        self.btnWechatNumber = btnWechat;
        [self.contentView addSubview:self.btnWechatNumber];
        
        [self creatCollectionView];
    }
    return self;
}

-(void)creatCollectionView
{
    EqualSpaceFlowLayout *layout = [[EqualSpaceFlowLayout alloc]init];
    layout.delegate = self;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(85, 35, ScreenWidth - 100, 75) collectionViewLayout:layout];
    
    _collectionView.userInteractionEnabled = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerClass: [YT_DateOrder2CollectionViewCell class]forCellWithReuseIdentifier:@"collectionId"];
    
    [self.contentView addSubview:_collectionView];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.model.industryList.count >= 6) {
        return 6;
    }else{
        return self.model.industryList.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionId" forIndexPath:indexPath];
    
    _cell.model = self.model.industryList[indexPath.item];
    [_cell setNeedsLayout];
    return _cell;
    
}
//设置每个Item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YT_DateOrderInfoIndustryListModel *industryModel = self.model.industryList[indexPath.item];
    CGSize size = [industryModel.value sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12]}];
    return CGSizeMake(size.width + 20, size.height + 6);
}

//定义每个UICollectionView 的 margin(边缘)
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}

//每个item之间的间距(横向)
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

- (void)setModel:(YT_DateOrderInfoDataModel *)model
{
    _model = model;
    //名字
    self.nameLable.text = model.realName;
    [self.nameLable sizeToFit];
    //约谈价格
    self.priceLable.text = model.price;
    self.priceLable.x = ScreenWidth - 40 - self.priceLable.width;
    //公司
    self.partnerLable.text = model.company;
    CGFloat width = ScreenWidth - CGRectGetMaxX(self.nameLable.frame) - (ScreenWidth - self.priceLable.x);
    self.partnerLable.frame = CGRectMake(CGRectGetMaxX(self.nameLable.frame) + 5, 20, width, 15);
    //头像
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    //人数
    self.personLable.text = [NSString stringWithFormat:@"%@人",model.hasMeetFounders];
    //星星
    [self.starView segmentStar:model.star];
    //手机号
    [self.btnPhoneNumber setTitle:model.mobile forState:UIControlStateNormal];
    //微信号
//    self.wechatLable.text = model.wechat;
    [self.btnWechatNumber setTitle:model.wechat forState:UIControlStateNormal];
    
}

- (NSMutableArray *)industryList
{
    if (nil == _industryList) {
        self.industryList = [NSMutableArray array];
    }
    return _industryList;
}

- (void)callForMe
{
    [self showAlertWithTitleString:self.btnPhoneNumber.titleLabel.text andIsPhoneNum:YES];
}

- (void)copyWechatNumber
{
    [self showAlertWithTitleString:self.btnWechatNumber.titleLabel.text andIsPhoneNum:NO];
}

- (void)showAlertWithTitleString:(NSString *)titleStr andIsPhoneNum:(BOOL)isPhoneNumber
{
    if (isPhoneNumber) {
        UIAlertView *alertPhone = [[UIAlertView alloc] initWithTitle:@"是否拨打电话?" message:titleStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        alertPhone.tag = 10000;
        [alertPhone show];
    }else{
        UIAlertView *alertWechat = [[UIAlertView alloc] initWithTitle:@"是否复制微信号?" message:titleStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"复制", nil];
        alertWechat.tag = 10001;
        [alertWechat show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            
            NSString *call = [NSString stringWithFormat:@"tel://%@",self.btnPhoneNumber.titleLabel.text];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:call]];
        }
    }else if (alertView.tag == 10001){
        if (buttonIndex == 1) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.btnWechatNumber.titleLabel.text;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
