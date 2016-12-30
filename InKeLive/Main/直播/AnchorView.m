//
//  AnchorView.m
//  InKeLive
//
//  Created by 1 on 2016/12/20.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "AnchorView.h"

@implementation AnchorView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.1);
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    self.layer.cornerRadius = 15;
    self.layer.masksToBounds = YES;
    [self addSubview:self.iconImageView];
    [self addSubview:self.liveLabel];
    [self addSubview:self.lineLabel];
    [self addSubview:self.payButton];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(2);
        make.width.height.equalTo(@32);
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2);
        make.right.bottom.equalTo(self).offset(-2);
        make.width.equalTo(@32);
    }];
    
    [self.liveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.iconImageView.mas_top);
        make.right.equalTo(self.payButton.mas_left).offset(-10);
        make.height.equalTo(@16);
    }];
    
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.liveLabel.mas_bottom);
        make.right.equalTo(self.payButton.mas_left).offset(-10);
        make.height.equalTo(@16);
    }];
}

//连麦按钮
- (void)payButtonClick{
    if (self.anchorClick) {
        self.anchorClick();
    }
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = 16;
        _iconImageView.layer.masksToBounds = YES;
        NSString *urlStr = [NSString stringWithFormat:@"http://img2.inke.cn/MTQ4MTcwOTgyNTIyNCM3OTcjanBn.jpg"];
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    }
    return _iconImageView;
}

- (UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.textColor = [UIColor whiteColor];
        _lineLabel.text = @"0人在线";
        _lineLabel.textAlignment = NSTextAlignmentLeft;
        _lineLabel.font = [UIFont systemFontOfSize:8];
    }
    return _lineLabel;
}

- (UIButton *)payButton{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.layer.borderWidth = 1;
        _payButton.layer.borderColor = RGB(36, 216, 200).CGColor;
        _payButton.layer.cornerRadius = 16;
        _payButton.layer.masksToBounds = YES;
        [_payButton setImage:[UIImage imageNamed:@"room_lianmai_apply"] forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

- (UILabel *)liveLabel{
    if (!_liveLabel) {
        _liveLabel = [[UILabel alloc]init];
        _liveLabel.textColor = [UIColor whiteColor];
        _liveLabel.text = @"直播";
        _liveLabel.textAlignment = NSTextAlignmentLeft;
        _liveLabel.font = [UIFont systemFontOfSize:10];
    }
    return _liveLabel;
}

@end
