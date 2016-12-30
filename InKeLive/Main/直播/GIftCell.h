//
//  GIftCell.h
//  InKeLive
//
//  Created by 1 on 2016/12/22.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "PresentViewCell.h"
#import "PresentModel.h"

@interface GIftCell : PresentViewCell

@property (strong, nonatomic) PresentModel *presentmodel;

//背景圆角
@property(nonatomic,strong)UIView *backView;

//送礼物者头像
@property (nonatomic,strong)UIImageView *iconImageView;

//送礼物者名
@property(nonatomic,strong)UILabel *senderLabel;

//礼物名
@property (nonatomic,strong)UILabel *giftLabel;

//礼物
@property (nonatomic,strong)UIImageView *giftImageView;

@end
