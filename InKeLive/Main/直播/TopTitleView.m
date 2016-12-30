//
//  TopTitleView.m
//  InKeLive
//
//  Created by 1 on 2016/12/26.
//  Copyright © 2016年 jh. All rights reserved.
// 首页titleView

#import "TopTitleView.h"
#import "MyControlTool.h"

#define bWidth self.width/self.titleArr.count

@implementation TopTitleView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        for (NSInteger i = 0; i < self.titleArr.count; i++) {
            WEAKSELF;
            UIButton *buttons = [MyControlTool buttonWithText:self.titleArr[i] textColor:[UIColor whiteColor] font:18 tag:50 + i frame:CGRectMake(i * bWidth, 0, bWidth, 44) clickBlock:^(id x) {
                UIButton *button = (UIButton *)x;
                [weakSelf scrollMove:button.tag];
                if (weakSelf.titleClick) {
                    weakSelf.titleClick(button.tag);
                }
            }];
            
            
            [self addSubview:buttons];
            
            if (i == 1) {
                [buttons.titleLabel sizeToFit];
                self.lineImageView.frame = CGRectMake(bWidth, 40, buttons.titleLabel.width, 3);
                self.lineImageView.centerX = buttons.centerX;
                [self addSubview:self.lineImageView];
            }
        }
    }
    return self;
}


- (void)scrollMove:(NSInteger)tag{
    UIButton *buttons = (UIButton *)[self viewWithTag:tag];
    [UIView animateWithDuration:0.3 animations:^{
        self.lineImageView.centerX = buttons.centerX;
    }];
}

#pragma 加载
- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"关注",@"热门",@"附近"];
    }
    return _titleArr;
}

- (UIImageView *)lineImageView{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc]init];
        _lineImageView.backgroundColor = [UIColor yellowColor];
    }
    return _lineImageView;
}


@end
