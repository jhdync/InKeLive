//
//  GiftView.m
//  InKeLive
//
//  Created by 1 on 2016/12/15.
//  Copyright © 2016年 jh. All rights reserved.
//礼物栏

#import "GiftView.h"

#define BackColor RGBA(0, 0, 0, 0.8)
#define GifGetY SCREEN_HEIGHT - 200

@implementation GiftView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
        [self addSubview:self.bottomView];
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    for (NSInteger i = 0; i < 8; i++) {
        if (i < 4) {
            UIButton *upButton = [UIButton buttonWithType:UIButtonTypeCustom];
            upButton.frame = CGRectMake(i * SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, 100);
            [upButton setTitle:self.giftArr[i] forState:UIControlStateNormal];
            [upButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            upButton.tag = 100 + i;
            [upButton addTarget:self action:@selector(giftClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.bottomView addSubview:upButton];
        } else {
            UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
            downButton.frame = CGRectMake((i - 4) * SCREEN_WIDTH/4, 100, SCREEN_WIDTH/4, 100);
            [downButton setTitle:self.giftArr[i] forState:UIControlStateNormal];
            downButton.tag = 100 + i;
            [downButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [downButton addTarget:self action:@selector(giftClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.bottomView addSubview:downButton];
        }
    }
}

- (void)giftClick:(UIButton *)sender{
    if (self.giftClick) {
        self.giftClick(sender.tag);
    }
}

- (void)popShow{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

- (NSArray *)giftArr{
    return @[@"鲜花",@"泰迪熊",@"游轮",@"钻石",@"火箭",@"烟花",@"法拉利",@"客机"];
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, GifGetY, CGRectGetWidth(self.frame), 200)];
        _bottomView.backgroundColor = BackColor;
    }
    return _bottomView;
}

//点击上方灰色区域移除视图
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.grayClick) {
        self.grayClick();
    }
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:self];
    if ( point.y < GifGetY) {
        [self removeFromSuperview];
    }
}


@end
