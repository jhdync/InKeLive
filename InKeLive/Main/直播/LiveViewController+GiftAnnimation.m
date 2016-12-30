//
//  LiveViewController+GiftAnnimation.m
//  InKeLive
//
//  Created by 1 on 2016/12/15.
//  Copyright © 2016年 jh. All rights reserved.
//送礼物

#import "LiveViewController+GiftAnnimation.h"
#import "FireworksViews.h"
#import "GifViews.h"
#import "CarsViews.h"
#import "RocketViews.h"
#import "NHPlaneViews.h"
#import "ShipViews.h"

@implementation LiveViewController (GiftAnnimation)

- (void)chooseGift:(NSInteger)tag{
    switch (tag) {
        case 100:
            //鲜花
        {
             [self.presentView insertPresentMessages:@[self.giftArr[0]] showShakeAnimation:YES];
        }
            break;
        case 101:
            //泰迪熊
            [self createDynamic];
            [self.presentView insertPresentMessages:@[self.giftArr[1]] showShakeAnimation:YES];
            break;
        case 102:
            //游轮
        {
            ShipViews *ship = [ShipViews loadShipViewWithPoint:CGPointZero];
            
            [ship addAnimationsMoveToPoint:CGPointMake(-166, 400) endPoint:CGPointMake(self.view.bounds.size.width + 166, 500)];
            [self.view addSubview:ship];
            
            [self.presentView insertPresentMessages:@[self.giftArr[2]] showShakeAnimation:YES];
        }
            break;
        case 103:
            //钻石
        {
            GifViews *f = [[GifViews alloc]initWithFrame:self.view.bounds];
            [self.view addSubview:f];
        }
            break;
        case 104:
            //火箭
        {
            RocketViews *rocket = [RocketViews loadRocketViewWithPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT + 150)];
            [rocket addAnimationsMoveToPoint:CGPointMake(self.view.centerX + 20, SCREEN_HEIGHT + 150) endPoint:CGPointMake(self.view.centerX + 20, -150)];
            [self.view addSubview:rocket];
        
        }
            break;
        case 105:
            //烟花
        {
            FireworksViews *fire = [[FireworksViews alloc]initWithFrame:self.view.bounds];
            [self.view addSubview:fire];
        }
            break;
        case 106:
            //法拉利
        {
            CarsViews *car = [CarsViews loadCarViewWithPoint:CGPointZero];
            NSMutableArray *pointArrs = [[NSMutableArray alloc] init];
            CGFloat width = [UIScreen mainScreen].bounds.size.width / 2;
            [pointArrs addObject:NSStringFromCGRect(CGRectMake(width, 300, width, 300))];
            car.curveControlAndEndPoints = pointArrs;
            
            [car addAnimationsMoveToPoint:CGPointMake(self.view.bounds.size.width, 300) endPoint:CGPointMake(-166, 0)];
            [self.view addSubview:car];
            
        }
            break;
        case 107:
            //客机
        {
            NHPlaneViews *plane = [NHPlaneViews loadPlaneViewWithPoint:CGPointMake(SCREEN_WIDTH + 232, 0)];
            
            [plane addAnimationsMoveToPoint:CGPointMake(SCREEN_WIDTH, 100) endPoint:CGPointMake(-500, 410)];
            [self.view addSubview:plane];
        
        }
            break;
        default:
            break;
    }
}

//重力
- (void)createDynamic{
    if (!self.dynamicAnimator) {
        //现实动画
        self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
        //现实行为
        self.dynamicItemBehavior = [[UIDynamicItemBehavior alloc]init];
        //弹力值
        self.dynamicItemBehavior.elasticity = 0.3;
        //允许旋转
        self.dynamicItemBehavior.allowsRotation = YES;
        
        //重力行为
        self.gravityBehavior = [[UIGravityBehavior alloc]init];
        
        //碰撞行为
        self.collisionBehavior = [[UICollisionBehavior alloc]init];
        //开启刚体碰撞
        self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        
        //将行为添加到现实动画中
        [self.dynamicAnimator addBehavior:self.dynamicItemBehavior];
        [self.dynamicAnimator addBehavior:self.gravityBehavior];
        [self.dynamicAnimator addBehavior:self.collisionBehavior];
    }
    int x = arc4random() % (int)[UIScreen mainScreen].bounds.size.width;
    int size = arc4random() % 50 + 30;
    
    NSArray * imageArray = @[@"bear0@2x",@"bear1@2x",@"bear2@2x",@"heart0",@"heart1",@"heart2",@"heart3",@"heart4",@"heart5"];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 0, size, size)];
    imageView.image = [UIImage imageNamed:imageArray[arc4random() % imageArray.count]];
    [self.view addSubview:imageView];
    
    //遵循行为
    [self.dynamicItemBehavior addItem:imageView];
    [self.gravityBehavior addItem:imageView];
    [self.collisionBehavior addItem:imageView];
    
    [self performSelector:@selector(deleteImage:) withObject:imageView afterDelay:2];
}

//消除行为且删除
- (void)deleteImage:(id)object{
    UIImageView *imagView = (UIImageView *)object;
    [self.dynamicItemBehavior removeItem:imagView];
    [self.gravityBehavior removeItem:imagView];
    [self.collisionBehavior removeItem:imagView];
    [imagView removeFromSuperview];
}

@end
