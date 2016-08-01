//
//  YT_CreateDateCell.m
//  interview
//
//  Created by Mickey on 16/4/27.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YT_CreateDateCell.h"
#import "YBStar.h"
#import "YT_listCreateListModel.h"
#import "YT_listCreateIndustryListModel.h"
#import "YT_CreateDateCollectionCell.h"
#import "EqualSpaceFlowLayout.h"
#import "YBDotView.h"

@interface YT_CreateDateCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,EqualSpaceFlowLayoutDelegate>{
    
    UICollectionView *_collectionView;
    
    NSMutableArray *_dataArray;
}

@property (nonatomic,weak) UIImageView *headImageView;
@property (weak, nonatomic) UILabel *nameLable;
@property (weak, nonatomic) UILabel *partnerLable;
@property (weak, nonatomic) UILabel *priceLable;
@property (nonatomic,weak) UILabel *personLable;
@property (nonatomic,weak) UILabel *orderStatusLable;
@property (nonatomic,strong)YBStar *starView;
@property (nonatomic,strong)YT_CreateDateCollectionCell *cell;
@property (nonatomic,strong)NSMutableArray *industryList;
@property (strong,nonatomic) YBDotView *dot;
@end
@implementation YT_CreateDateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = bgColor;
        //背景
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 8.0f;
        [self.contentView addSubview:bgView];
        //头像
        UIImageView *headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(13, 10, 70, 70)];
        headImageV.layer.cornerRadius = 70/2;
        headImageV.layer.masksToBounds = YES;
        headImageV.image = [UIImage imageNamed:@"morentouxiang"];
        self.headImageView = headImageV;
        [bgView addSubview:self.headImageView];
        //姓名
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 60, 20)];
        nameLable.font = [UIFont systemFontOfSize:16];
        nameLable.textColor = btnColor;
        nameLable.textAlignment = NSTextAlignmentLeft;
        self.nameLable = nameLable;
        [bgView addSubview:self.nameLable];
        //元/小时
        UILabel *yuanLable = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 50, 20, 30, 15)];
        yuanLable.font = [UIFont systemFontOfSize:12];
        yuanLable.textColor = [UIColor blackColor];
        yuanLable.textAlignment = NSTextAlignmentCenter;
        yuanLable.text = @"元/次";
        [bgView addSubview:yuanLable];
        //约谈价格
        UILabel *priceLable = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 55 - 55, 12, 60, 30)];
        priceLable.font = [UIFont systemFontOfSize:21];
        priceLable.textColor = btnColor;
        priceLable.textAlignment = NSTextAlignmentRight;
        self.priceLable = priceLable;
        [bgView addSubview:self.priceLable];
        //公司 
        UILabel *partnerLable = [[UILabel alloc] init];
        partnerLable.y = 20;
        partnerLable.height = 15;
        partnerLable.font = [UIFont systemFontOfSize:12];
        partnerLable.textColor = [UIColor blackColor];
        partnerLable.textAlignment = NSTextAlignmentLeft;
        self.partnerLable = partnerLable;
        [bgView addSubview:self.partnerLable];
        //咖啡图标
        UIImageView *coffeeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(23, 98, 12, 12)];
        coffeeImageV.image = [UIImage imageNamed:@"kafei"];
        [bgView addSubview:coffeeImageV];
        //人数
        UILabel *personLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(coffeeImageV.frame) + 8, 105, 40, 10)];
        personLable.font = [UIFont systemFontOfSize:10];
        personLable.textColor = btnColor;
        personLable.textAlignment = NSTextAlignmentLeft;
        
        self.personLable = personLable;
        [self.contentView addSubview:personLable];
        //星星
        self.starView = [[YBStar alloc]initWithFrame:CGRectMake(13, 77, 65, 23)];
        [bgView addSubview:self.starView];
        //横线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.personLable.frame) + 10, ScreenWidth - 30, 1.5)];
        lineView.backgroundColor = bgColor;
        [bgView addSubview:lineView];
        //订单
        UILabel *orderLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.headImageView.frame), CGRectGetMaxY(lineView.frame) + 5, 80, 15)];
        orderLable.text = @"订单状态";
        orderLable.textColor = [UIColor grayColor];
        orderLable.textAlignment = NSTextAlignmentLeft;
        orderLable.font = [UIFont systemFontOfSize:14];
        [orderLable sizeToFit];
        [bgView addSubview:orderLable];
        //订单状态
        UILabel *orderStatusLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(orderLable.frame) + 20, CGRectGetMinY(orderLable.frame), 200, 15)];
        orderStatusLable.textColor = btnColor;
        orderStatusLable.textAlignment = NSTextAlignmentLeft;
        orderStatusLable.font = [UIFont systemFontOfSize:14];
        
        self.orderStatusLable = orderStatusLable;
        [bgView addSubview:self.orderStatusLable];
        
        bgView.frame = CGRectMake(5, 5, ScreenWidth - 10, CGRectGetMaxY(orderStatusLable.frame) + 10);
        
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
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(95, 38, ScreenWidth - 100, 75) collectionViewLayout:layout];
    
    _collectionView.userInteractionEnabled = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerClass: [YT_CreateDateCollectionCell class]forCellWithReuseIdentifier:@"collectionId"];
    
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
    
    return _cell;
}
//设置每个Item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YT_listCreateIndustryListModel *industryModel = self.model.industryList[indexPath.item];
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


- (void)setModel:(YT_listCreateListModel *)model
{
    _model = model;
    //订单号
    self.orderStatusLable.text = model.orderStatusName;
    //姓名
    self.nameLable.text = model.realName;
    [self.nameLable sizeToFit];
    //约谈价格
    self.priceLable.text = model.price;
    [self.priceLable sizeToFit];
    self.priceLable.x = ScreenWidth - 50 - self.priceLable.width;
    //公司
    self.partnerLable.text = model.company;
    CGFloat width = ScreenWidth - 10 - CGRectGetMaxX(self.nameLable.frame) - (ScreenWidth - 10 - self.priceLable.x);
    self.partnerLable.frame = CGRectMake(CGRectGetMaxX(self.nameLable.frame) + 5, 18, width, 15);
    
    //头像
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImg]];
    //约见人数
    self.personLable.text = [NSString stringWithFormat:@"%@人",model.evaluateNum];
    //评价星星
    [self.starView segmentStar:model.star];
    
    if ([model.ifNotice isEqualToString:@"true"]) {
        [self.dot showDotWithView:self.contentView];
    }else{
        [self.dot hideDotWith:self.contentView];
    }
}

- (NSMutableArray *)industryList
{
    if (nil == _industryList) {
        self.industryList = [NSMutableArray array];
    }
    return _industryList;
}

- (YBDotView *)dot
{
    if (nil == _dot) {
        self.dot = [[YBDotView alloc] initWithFrame:CGRectMake(15, 15, 8, 8)];
    }
    return _dot;
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
