//
//  SendGiftView.m
//  InKeLive
//
//  Created by 1 on 2017/1/3.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "SendGiftView.h"
#import "MyControlTool.h"
#import "GIftViews.h"

#define GifGetY SCREEN_HEIGHT - 280
#define Collor_Simple RGBA(0, 0, 0, 0.58)
#define Collor_Deep RGBA(0, 0, 0, 0.6)

@implementation SendGiftView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    [self.rechargeView addSubview:self.pageControl];
    [self addSubview:self.giftScrollView];
    [self addSubview:self.rechargeView];
    [self.rechargeView addSubview:self.rechargeButton];
    [self.rechargeView addSubview:self.senderButton];
    
    
    for (NSInteger i = 0; i < 24; i++) {
        NSString *imagePath=[NSString stringWithFormat:@"yipitiezhi0%zd",i + 1];
        if ((i/4)%2 == 0) {
            GIftViews *upButton = [[GIftViews alloc]initWithFrame:CGRectMake((i%4) * SCREEN_WIDTH/4 + (i/8) * SCREEN_WIDTH, 0, SCREEN_WIDTH/4, 110) imageStr:imagePath];
            upButton.tag = 100 + i;
            //显示边线
            if (i%2 == 0) {
                upButton.backgroundColor = Collor_Simple;
            } else {
                upButton.backgroundColor = Collor_Deep;
            }
            [self.giftScrollView addSubview:upButton];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(giftViewClick:)];
            [upButton addGestureRecognizer:tap];
            
            UIView *singleTagView = [tap view];
            singleTagView.tag = 100 + i;
            
        } else {
             GIftViews *downButton = [[GIftViews alloc]initWithFrame:CGRectMake((i%4) * SCREEN_WIDTH/4 + (i/8) * SCREEN_WIDTH, 110, SCREEN_WIDTH/4, 110) imageStr:imagePath];
            downButton.tag = 100 + i;
            //显示边线
            if (i%2 != 0) {
                downButton.backgroundColor = Collor_Simple;
            } else {
                downButton.backgroundColor = Collor_Deep;
            }
            [self.giftScrollView addSubview:downButton];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(giftViewClick:)];
            [downButton addGestureRecognizer:tap];
            
            UIView *singleTagView = [tap view];
            singleTagView.tag = 100 + i;
        }
    }

}

- (void)giftViewClick:(UITapGestureRecognizer *)tap{
    GIftViews *giftView = [self viewWithTag:[tap view].tag];
    //同一个选中
    if (giftView.hitButton.selected) {
        giftView.hitButton.selected = NO;
        self.senderButton.backgroundColor = [UIColor grayColor];
        self.senderButton.enabled = NO;
        return;
    }
    //不同选中
    for (GIftViews *view in self.giftScrollView.subviews) {
        if (view.hitButton.selected) {
            view.hitButton.selected = NO;
        }
    }
    giftView.hitButton.selected = YES;
    self.senderButton.backgroundColor = RGB(36, 215, 200);
    self.senderButton.tag = giftView.tag;
    self.senderButton.enabled = YES;
}



//弹出礼物框
- (void)popShow{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
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

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    self.pageControl.currentPage = page;
}


#pragma 加载
//滑动
- (UIScrollView *)giftScrollView{
    if (!_giftScrollView) {
        _giftScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, GifGetY, SCREEN_WIDTH, 220)];
        _giftScrollView.pagingEnabled = YES;
        _giftScrollView.delegate = self;
        _giftScrollView.bounces = NO;
        _giftScrollView.showsVerticalScrollIndicator = NO;
        _giftScrollView.showsHorizontalScrollIndicator = NO;
        _giftScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    }
    return _giftScrollView;
}

//底部
- (UIView *)rechargeView{
    if (!_rechargeView) {
        _rechargeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 60, SCREEN_WIDTH, 60)];
        _rechargeView.backgroundColor = RGBA(0, 0, 0, 0.6);
    }
    return _rechargeView;
}

//充值按钮
- (UIButton *)rechargeButton{
    if (!_rechargeButton) {
        _rechargeButton = [MyControlTool buttonWithText:@"充值" textColor:RGB(249, 179, 61) font:17 tag:0 frame:CGRectMake(0, 0, 100, 60) clickBlock:^(id x) {
        }];

    }
    return _rechargeButton;
}

//发送礼物
- (UIButton *)senderButton{
    if (!_senderButton) {
        _senderButton = [MyControlTool buttonWithText:@"发送" textColor:[UIColor whiteColor] font:17 tag:0 frame:CGRectMake(SCREEN_WIDTH - 70, 17, 60, 26) clickBlock:^(id x) {
            UIButton *sender = (UIButton *)x;
            if (self.giftClick) {
                self.giftClick(sender.tag);
            }
        }];
        _senderButton.layer.cornerRadius = 12;
        _senderButton.layer.masksToBounds = YES;
        [_senderButton setBackgroundColor:RGB(36, 215, 200)];
    }
    return _senderButton;
}

//分页
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 20, 5, 40, 20)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 3;
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    }
    return _pageControl;
}



@end
