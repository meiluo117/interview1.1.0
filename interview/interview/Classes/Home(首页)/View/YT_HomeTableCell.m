
//  YT_HomeTableCell.m
//  interview
//
//  Created by 于波 on 16/3/28.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_HomeTableCell.h"
#import "YBStar.h"
#import "YT_HomeCollectionCell.h"
#import "YT_ResponseModel.h"
#import "YT_ItemModel.h"
#import "YT_DataModel.h"
#import "YT_IndustryModel.h"
#import "HXTagsView.h"
#import "HXTagView.h"
#import "EqualSpaceFlowLayout.h"

@interface YT_HomeTableCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,EqualSpaceFlowLayoutDelegate>{
    
    UICollectionView *_collectionView;
    NSMutableArray *_dataArray;
}
@property (nonatomic,weak) UIImageView *headImageView;
@property (weak, nonatomic) UILabel *nameLable;
@property (weak, nonatomic) UILabel *partnerLable;
@property (weak, nonatomic) UILabel *priceLable;
@property (nonatomic,weak) UILabel *personLable;
@property (nonatomic,strong)YBStar *starView;
@property (nonatomic,strong)YT_HomeCollectionCell *cell;
@property (nonatomic,strong)NSMutableArray *industryList;
@property (strong,nonatomic) HXTagsView *tagsView;
@end

@implementation YT_HomeTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(13, 10, 65, 65)];
        headImageV.layer.cornerRadius = 65/2;
        headImageV.layer.masksToBounds = YES;
        self.headImageView = headImageV;
        [self.contentView addSubview:self.headImageView];
        
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(93, 13, 60, 20)];
        nameLable.font = [UIFont systemFontOfSize:20];
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
        
        UILabel *priceLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(yuanLable.frame) - 55, 5, 65, 30)];
        priceLable.font = [UIFont systemFontOfSize:30];
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
        
        self.starView = [[YBStar alloc]initWithFrame:CGRectMake(14, 77, 65, 23)];
        [self.contentView addSubview:self.starView];
        
        [self creatCollectionView];
    }
    return self;
}

-(void)creatCollectionView
{
    EqualSpaceFlowLayout *layout = [[EqualSpaceFlowLayout alloc]init];
    layout.delegate = self;
    
    //collectionview 滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(85, 35, ScreenWidth - 90, 75) collectionViewLayout:layout];
    
    _collectionView.userInteractionEnabled = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerClass: [YT_HomeCollectionCell class]forCellWithReuseIdentifier:@"collectionId"];
    [self.contentView addSubview:_collectionView];
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.model.industryList.count >= 6) {
        return 6;
    }else{
        return self.model.industryList.count;
    }
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionId" forIndexPath:indexPath];
    
    if (nil == _cell) {
        _cell = [[YT_HomeCollectionCell alloc] init];
    }
    if (self.self.model.industryList.count > indexPath.item) {
        _cell.model = self.model.industryList[indexPath.item];

        [_cell layoutIfNeeded];
    }
    return _cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//设置每个Item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YT_IndustryModel *industryModel = self.model.industryList[indexPath.item];
    CGSize size = [industryModel.value sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12]}];
    return CGSizeMake(size.width + 20, size.height + 6);
}

////定义每个UICollectionView 的 margin(边缘)
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}

//每个item之间的间距(横向)
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

- (void)setModel:(YT_ItemModel *)model
{
    _model = model;
    //名字
    self.nameLable.text = model.name;
//    [self.nameLable sizeToFit];
    //约谈价格
    self.priceLable.text = model.price;
//    [self.priceLable sizeToFit];
//    self.priceLable.x = ScreenWidth - 40 - self.priceLable.width;
    
    //公司
    self.partnerLable.text = model.company;
//    CGFloat width = ScreenWidth - CGRectGetMaxX(self.nameLable.frame) - (ScreenWidth - self.priceLable.x) - 5;
//    self.partnerLable.frame = CGRectMake(CGRectGetMaxX(self.nameLable.frame) + 5, 20, width, 15);
    //头像
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    //人数
    self.personLable.text = [NSString stringWithFormat:@"%@人",model.orderNum];
    //星星
    [self.starView segmentStar:model.evaluate];
    
    [_collectionView reloadData];
    
}

- (void)layoutSubviews
{
//    YT_LOG(@"11111111111111111");
    [super layoutSubviews];
    [self.nameLable sizeToFit];
    [self.priceLable sizeToFit];
    self.priceLable.x = ScreenWidth - 40 - self.priceLable.width;
    CGFloat width = ScreenWidth - CGRectGetMaxX(self.nameLable.frame) - (ScreenWidth - self.priceLable.x) - 5;
    self.partnerLable.frame = CGRectMake(CGRectGetMaxX(self.nameLable.frame) + 5, 20, width, 15);
}

- (void)awakeFromNib {
    // Initialization code
}

- (NSMutableArray *)industryList
{
    if (nil == _industryList) {
        self.industryList = [NSMutableArray array];
    }
    return _industryList;
}

@end
