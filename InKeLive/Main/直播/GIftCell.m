//
//  GIftCell.m
//  InKeLive
//
//  Created by 1 on 2016/12/22.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "GIftCell.h"

@implementation GIftCell

- (instancetype)initWithRow:(NSInteger)row{
    if (self = [super initWithRow:row]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    [self addSubview:self.backView];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.giftImageView];
    [self.backView addSubview:self.senderLabel];
    [self.backView addSubview:self.lineLabel];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(2);
        make.width.height.equalTo(@32);
    }];
    
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2);
        make.right.bottom.equalTo(self).offset(-2);
        make.width.height.equalTo(@32);
    }];
    
    [self.senderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.iconImageView.mas_top);
        make.right.equalTo(self.giftImageView.mas_left).offset(-10);
        make.height.equalTo(@16);
    }];
    
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.senderLabel.mas_bottom);
        make.right.equalTo(self.giftImageView.mas_left).offset(-10);
        make.height.equalTo(@16);
    }];
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = 16;
        _iconImageView.layer.masksToBounds = YES;
        NSString *urlStr = [NSString stringWithFormat:@"http://img2.inke.cn/MTQ4MjI4NDA3NjYyOCM2NjIjanBn.jpg"];
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    }
    return _iconImageView;
}

- (UILabel *)lineLabel{
    if (!_giftLabel) {
        _giftLabel = [[UILabel alloc]init];
        _giftLabel.textColor = [UIColor orangeColor];
        _giftLabel.textAlignment = NSTextAlignmentLeft;
        _giftLabel.font = [UIFont systemFontOfSize:12];
    }
    return _giftLabel;
}


- (UILabel *)senderLabel{
    if (!_senderLabel) {
        _senderLabel = [[UILabel alloc]init];
        _senderLabel.textColor = [UIColor whiteColor];
        _senderLabel.text = @"Aync";
        _senderLabel.textAlignment = NSTextAlignmentLeft;
        _senderLabel.font = [UIFont systemFontOfSize:12];
    }
    return _senderLabel;
}

- (UIImageView *)giftImageView{
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc]init];
    }
    return _giftImageView;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = RGBA(0, 0, 0, 0.3);
        //圆角
        _backView.layer.cornerRadius = 20;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}


- (void)setPresentmodel:(PresentModel *)presentmodel{
    _presentmodel = presentmodel;
    self.senderLabel.text = presentmodel.sender;
    self.giftLabel.text = [NSString stringWithFormat:@"送了一个%@",presentmodel.giftName];
    self.giftImageView.image = [UIImage imageNamed:presentmodel.giftImageName];
}



@end
