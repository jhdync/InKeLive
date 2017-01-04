//
//  SendGiftView.h
//  InKeLive
//
//  Created by 1 on 2017/1/3.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftViewCell.h"

@interface SendGiftView : UIView<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    UIPageControl *_pageControl;
    //礼物标记
    NSInteger _reuse;
}

//礼物栏
@property (nonatomic,strong)UICollectionView *giftCollectionView;

//底部充值  发送
@property (nonatomic,strong)UIView *rechargeView;

//充值按钮
@property (nonatomic,strong)UIButton *rechargeButton;

//发送礼物按钮
@property (nonatomic,strong)UIButton *senderButton;

@property (nonatomic,strong)UIPageControl *pageControl;

@property (nonatomic,copy)void (^giftClick)(NSInteger tag);

@property (nonatomic,copy)void (^grayClick)();

@property (nonatomic,strong)NSMutableArray *dataArr;

- (void)popShow;

@end
