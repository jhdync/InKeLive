//
//  NearCell.h
//  InKeLive
//
//  Created by 1 on 2016/12/26.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearModel.h"

@interface NearCell : UICollectionViewCell

//头像
@property (nonatomic,strong)UIImageView *iconImageView;

//距离
@property (nonatomic,strong)UILabel *distanceLabel;

@property (nonatomic,strong)NSMutableArray *arr;

- (void)updateCell:(NearModel *)nearModel;

- (void)showAnimation;

@end
