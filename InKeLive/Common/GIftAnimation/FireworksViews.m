//
//  FireworksViews.m
//  NHGiftAnimationExample
//
//  Created by 1 on 2016/12/7.
//  Copyright © 2016年 jh. All rights reserved.
//粒子动画

#import "FireworksViews.h"

@implementation FireworksViews

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self sendGranule];
    }
    return self;
}

- (void)sendGranule{
    // 发射器
    // Cells spawn in the bottom, moving up
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    CGRect viewBounds = self.layer.bounds;
    fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
    fireworksEmitter.emitterSize	= CGSizeMake(viewBounds.size.width/2.0, 0.0);//发射器大小
    fireworksEmitter.emitterMode	= kCAEmitterLayerOutline;//发射器的发射模式
    fireworksEmitter.emitterShape	= kCAEmitterLayerLine;//发射器的形状
    fireworksEmitter.renderMode		= kCAEmitterLayerAdditive;
    fireworksEmitter.seed = (arc4random()%100)+1;
    
    //烟火
    CAEmitterCell* rocket = [CAEmitterCell emitterCell];
    
    rocket.birthRate		= 2.0;//出生率，每秒产生cell的数量
    rocket.emissionRange	=M_PI/9;  // some variation in angle
    rocket.velocity			= 380;//速度
    rocket.velocityRange	= 380;//速度范围
    rocket.yAcceleration	= 100;//y方向加速度分量
    rocket.lifetime			= 1.02;	// 生命周期  lifetimeRange生命周期范围
    
    rocket.contents			= (id) [[UIImage imageNamed:@"talk_gift"] CGImage];//设置图片
    rocket.scale			= 0.2;//缩放比例  scaleRange：缩放比例范围  scaleSpeed：缩放比例速度
    //    rocket.color			= [[UIColor colorWithRed:1 green:0 blue:0 alpha:1] CGColor];
    rocket.greenRange		= 1.0;	  //粒子在rgb三个色相上的容差和透明度的容差
    rocket.redRange			= 1.0;
    rocket.blueRange		= 1.0;
    
    rocket.spinRange		= M_PI;
    
    
    //爆炸
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    
    burst.birthRate			= 1.0;
    burst.velocity			= 0;
    burst.scale				= 2.5;
    burst.redSpeed			=-1.5;
    burst.blueSpeed			=+1.5;
    burst.greenSpeed		=+1.0;
    burst.lifetime			= 0.35;
    
    // and finally, the sparks
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate			= 30;
    spark.velocity			= 125;
    spark.emissionRange		= 2* M_PI;
    spark.yAcceleration		= 75;
    spark.lifetime			= 3;
    
    spark.contents			= (id) [[UIImage imageNamed:@"talk_gift"] CGImage];
    spark.scale		        =1.5;
    spark.scaleSpeed		=-0.2;
    spark.greenSpeed		=-0.1;
    spark.redSpeed			= 0.4;
    spark.blueSpeed			=-0.1;
    spark.alphaSpeed		=-0.5;  ////粒子在RGB三个色相上的变化速度和透明度的变化速度
    spark.spin				= 2* M_PI;//自旋转角度
    spark.spinRange			= 2* M_PI;//自旋转角度范围
    
    // putting it together
    fireworksEmitter.emitterCells	= [NSArray arrayWithObject:rocket];
    rocket.emitterCells				= [NSArray arrayWithObject:burst];
    burst.emitterCells				= [NSArray arrayWithObject:spark];
    [self.layer addSublayer:fireworksEmitter];
    
     [self performSelector:@selector(deleteFire:) withObject:nil afterDelay:3];
}

//消失
- (void)deleteFire:(id)object{
    [self removeFromSuperview];
}

@end
