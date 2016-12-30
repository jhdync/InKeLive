//
//  EmptyView.m
//  InKeLive
//
//  Created by 1 on 2016/12/22.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "EmptyView.h"

#define BackGroundColor RGB(239, 239, 239)
#define EmptyMargin (SCREEN_WIDTH - 200)/2

@implementation EmptyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = BackGroundColor;
        [self addSubview:self.emptyImageView];
        [self addSubview:self.skipButton];
        [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(EmptyMargin);
            make.right.equalTo(self).offset(-EmptyMargin);
            make.height.width.offset(200);
        }];
        
        [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.emptyImageView.mas_bottom).offset(10);
            make.left.right.width.equalTo(self.emptyImageView);
            make.height.equalTo(@20);
        }];
        
        
    }
    return self;
}


- (UIButton *)skipButton{
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipButton setTitle:@"去看看最新精彩直播" forState:UIControlStateNormal];
        [_skipButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _skipButton;
}


- (UIImageView *)emptyImageView{
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc]init];
        _emptyImageView.image = [UIImage imageNamed:@"live_empty_bg@2x"];
    }
    return _emptyImageView;
}

@end
