//
//  YT_DateOrderCell.m
//  interview
//
//  Created by Mickey on 16/5/20.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_DateOrderCell.h"
#import "YBStar.h"
#import "YT_DateOrderCollectionCell.h"
#import "YT_DateOrderInfoRequestModel.h"
#import "YT_DateOrderInfoDataModel.h"
#import "YT_DateOrderInfoIndustryListModel.h"
#import "EqualSpaceFlowLayout.h"

@interface YT_DateOrderCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,EqualSpaceFlowLayoutDelegate>{
    
    UICollectionView *_collectionView;
    
    NSMutableArray *_dataArray;
}
@property (nonatomic,weak) UIImageView *headImageView;
@property (weak, nonatomic) UILabel *nameLable;
@property (weak, nonatomic) UILabel *partnerLable;
@property (weak, nonatomic) UILabel *priceLable;
@property (nonatomic,weak) UILabel *personLable;
@property (nonatomic,strong)YBStar *starView;
@property (nonatomic,strong)YT_DateOrderCollectionCell *cell;
@property (nonatomic,strong)NSMutableArray *industryList;
@end

@implementation YT_DateOrderCell

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
        
        [self creatCollectionView];
    }
    return self;
}

-(void)creatCollectionView
{
    EqualSpaceFlowLayout *layout = [[EqualSpaceFlowLayout alloc]init];
    layout.delegate = self;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(90, 35, ScreenWidth - 100, 75) collectionViewLayout:layout];
    
    _collectionView.userInteractionEnabled = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerClass: [YT_DateOrderCollectionCell class]forCellWithReuseIdentifier:@"collectionId"];
    
    [self.contentView addSubview:_collectionView];
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

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
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
}

- (NSMutableArray *)industryList
{
    if (nil == _industryList) {
        self.industryList = [NSMutableArray array];
    }
    return _industryList;
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
