//
//  NearCell.m
//  InKeLive
//
//  Created by 1 on 2016/12/26.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "NearCell.h"

@implementation NearCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    [self addSubview:self.iconImageView];
    [self addSubview:self.distanceLabel];
    [self addSubview:self.rankImageView];

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-25);
    }];

    [self.rankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(4);
        make.left.equalTo(self);
        make.bottom.equalTo(self).offset(-4);
        make.width.equalTo(@36);
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rankImageView.mas_right).offset(5);
        make.bottom.right.equalTo(self);
        make.top.equalTo(self.iconImageView.mas_bottom);
    }];
}

//距离、定位、图片真实，等级随机取
- (void)updateCell:(NearModel *)nearModel{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *rankArr = [data allKeys];
    
    int index = arc4random()%rankArr.count;
    
    NSString *rankUrl = rankArr[index];
    
    //随机取一个等级吧
    [self.rankImageView sd_setImageWithURL:[NSURL URLWithString:rankUrl] placeholderImage:[UIImage imageNamed:@"leavel_empty"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:nearModel.portrait] placeholderImage:[UIImage imageNamed:@"live_empty_bg"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    if (nearModel.distance.length > 0) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%@",nearModel.distance];
    } else {
        //距离远的只显示城市
        if (nearModel.city.length > 0) {
            self.distanceLabel.text = [NSString stringWithFormat:@"%@",nearModel.city];
        } else {
            //没有显示火星
            self.distanceLabel.text = [NSString stringWithFormat:@"火星"];
        }
    }
}

- (void)showAnimation{
    self.iconImageView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
    [UIView animateWithDuration:0.25 animations:^{
        self.iconImageView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}

#pragma 加载
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}

- (UILabel *)distanceLabel{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc]init];
        _distanceLabel.textAlignment = NSTextAlignmentLeft;
        _distanceLabel.textColor = [UIColor grayColor];
        _distanceLabel.font = [UIFont systemFontOfSize:15];
    }
    return _distanceLabel;
}

- (UIImageView *)rankImageView{
    if (!_rankImageView) {
        _rankImageView = [[UIImageView alloc]init];
    }
    return _rankImageView;
}

@end
