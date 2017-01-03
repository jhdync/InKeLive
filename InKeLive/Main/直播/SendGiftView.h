//
//  SendGiftView.h
//  InKeLive
//
//  Created by 1 on 2017/1/3.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendGiftView : UIView<UIScrollViewDelegate>{
    UIPageControl *_pageControl;
}

//顶部scrollView
@property (nonatomic,strong)UIScrollView *giftScrollView;

//底部充值
@property (nonatomic,strong)UIView *rechargeView;

//充值按钮
@property (nonatomic,strong)UIButton *rechargeButton;

//发送礼物按钮
@property (nonatomic,strong)UIButton *senderButton;

@property (nonatomic,strong)UIPageControl *pageControl;

@property (nonatomic,copy)void (^giftClick)(NSInteger tag);

@property (nonatomic,copy)void (^grayClick)();

- (void)popShow;

@end
