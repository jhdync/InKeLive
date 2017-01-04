//
//  GiftViewCell.m
//  InKeLive
//
//  Created by 1 on 2017/1/4.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "GiftViewCell.h"

@implementation GiftViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
        self.giftImageView.image = [UIImage imageNamed:@"1"];
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    [self addSubview:self.giftImageView];
    [self addSubview:self.hitButton];
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self).offset(25);
    }];
    
    [self.hitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.height.width.equalTo(@25);
    }];
}

- (UIImageView *)giftImageView{
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc]init];
        _giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _giftImageView;
}

- (UIButton *)hitButton{
    if (!_hitButton) {
        _hitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hitButton setImage:[UIImage imageNamed:@"pop_gift_lian"] forState:UIControlStateNormal];
        [_hitButton setImage:[UIImage imageNamed:@"button_choose-on"] forState:UIControlStateSelected];
    }
    return _hitButton;
}

@end
