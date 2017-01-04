//
//  SendGiftView.m
//  InKeLive
//
//  Created by 1 on 2017/1/3.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "SendGiftView.h"
#import "MyControlTool.h"
#import "FlowLayout.h"

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
    [self addSubview:self.giftCollectionView];
    [self addSubview:self.rechargeView];
    [self.rechargeView addSubview:self.rechargeButton];
    [self.rechargeView addSubview:self.senderButton];
}

//弹出礼物
- (void)popShow{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

//点击上方灰色区域移除视图
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:self];
    if ( point.y < GifGetY) {
        if (self.grayClick) {
            self.grayClick();
        }
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

#pragma
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GiftViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RegisterId" forIndexPath:indexPath];
    if (self.dataArr.count > 0) {
        cell.giftImageView.image = [UIImage imageNamed:self.dataArr[indexPath.row]];
        if (_reuse == indexPath.row) {
            cell.hitButton.selected = YES;
        } else {
            cell.hitButton.selected = NO;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GiftViewCell *cell = (GiftViewCell *)[self.giftCollectionView cellForItemAtIndexPath:indexPath];
    if (!cell.hitButton.selected) {
        for (UIView *view in self.giftCollectionView.subviews) {
            //遍历所有cell，重置为未连击状态
            if ([view isKindOfClass:[GiftViewCell class]]) {
                GiftViewCell *cell = (GiftViewCell *)view;
                cell.hitButton.selected = NO;
            }
        }
        cell.hitButton.selected = YES;
        //可以发送礼物
        self.senderButton.backgroundColor = RGB(36, 215, 200);
        self.senderButton.enabled = YES;
        _reuse = indexPath.row;
    } else {
        cell.hitButton.selected = NO;
        //未有选中，禁用发送按钮
        self.senderButton.backgroundColor = [UIColor grayColor];
        self.senderButton.enabled = NO;
        _reuse = 100;
        return;
    }
}


#pragma 加载
//滑动
- (UICollectionView *)giftCollectionView{
    if (!_giftCollectionView) {
        FlowLayout *flowLay = [[FlowLayout alloc]init];
        flowLay.minimumLineSpacing = 0;
        flowLay.minimumInteritemSpacing = 0;
        flowLay.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLay.itemSize = CGSizeMake(SCREEN_WIDTH/4, 110);
        
        _giftCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, GifGetY, SCREEN_WIDTH, 220) collectionViewLayout:flowLay];
        _giftCollectionView.backgroundColor = RGBA(0, 0, 0, 0.3);
        _giftCollectionView.bounces = NO;
        _giftCollectionView.delegate = self;
        _giftCollectionView.dataSource = self;
        _giftCollectionView.pagingEnabled = YES;
        
        [_giftCollectionView registerClass:[GiftViewCell class] forCellWithReuseIdentifier:@"RegisterId"];
    }
    return _giftCollectionView;
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
            if (self.giftClick) {
                self.giftClick(_reuse);
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

//礼物图片
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        for (NSInteger i = 0; i < 24; i++) {
            NSString *imagePath=[NSString stringWithFormat:@"yipitiezhi0%zd",i + 1];
            [_dataArr addObject:imagePath];
        }
    }
    return _dataArr;
}



@end
