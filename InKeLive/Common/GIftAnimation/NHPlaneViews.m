//
//  NHPlaneView.m
//  NHGiftAnimation
//
//  Created by simope on 16/7/8.
//  Copyright © 2016年 NegHao.W. All rights reserved.
//

#import "NHPlaneViews.h"

@interface NHPlaneViews ()
@property (nonatomic, strong) UIImageView *planeWing;
@property (weak, nonatomic) IBOutlet UIImageView *planeScrew;

@end

@implementation NHPlaneViews

+ (instancetype)loadPlaneViewWithPoint:(CGPoint)point{
    NHPlaneViews *plane = [[NSBundle mainBundle]loadNibNamed:@"NHPlaneViews" owner:self options:nil].lastObject;
    plane.frame = CGRectMake(point.x, point.y, 232, 92);
    [plane setPoints];
    [plane setPlaneScrewImages:nil];
    return plane;
}


//起点(NHBounds.width, 100)   终点(x = -500, y = 410)
- (void)addAnimationsMoveToPoint:(CGPoint)movePoints endPoint:(CGPoint)endPoint{
    
    CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //路径轨迹
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, movePoints.x, movePoints.y);
    
    [self.curveControlAndEndPoints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = CGRectFromString(obj);
        CGPathAddQuadCurveToPoint(path, NULL, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    }];
    
    CGPathAddQuadCurveToPoint(path, NULL, endPoint.x, endPoint.y, endPoint.x, endPoint.y);
    position.path = path;
    position.duration = 4.f;
    position.speed = 0.6;
    position.removedOnCompletion = NO;
    position.fillMode = kCAFillModeForwards;
    position.calculationMode = kCAAnimationCubicPaced;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.5];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.duration = 1.0;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 7.f;
    animationGroup.delegate = self;
    animationGroup.autoreverses = NO;
    animationGroup.repeatCount = 0;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.animations = @[scaleAnimation,position];
    [self.layer addAnimation:animationGroup forKey:@"planeViews"];
}


- (void)setPlaneScrewImages:(NSArray *)imageArray{
    NSMutableArray* images = [NSMutableArray array];
    for(int i = 1;i<4;i++){
        NSString *imageStr = [NSString stringWithFormat:@"plane-screw-1-%d",i];
        NSString *path = [[NSBundle mainBundle] pathForResource:imageStr ofType:@"png"];
        UIImage *planeImage = [UIImage imageWithContentsOfFile:path];
        [images addObject:planeImage];
    }
    _planeScrew.animationImages = images;
    _planeScrew.animationDuration = 0.05;
    _planeScrew.animationRepeatCount = 0;
    [_planeScrew startAnimating];
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}


- (void)setPoints{
    _scaleToValue = [NSNumber numberWithFloat:2.0];
    _scaleFromValue = [NSNumber numberWithFloat:0.7];
    
    NSMutableArray *pointArrs = [[NSMutableArray alloc] init];
    [pointArrs addObject:NSStringFromCGRect(CGRectMake(290, 250, 290, 250))];
    [pointArrs addObject:NSStringFromCGRect(CGRectMake(290, 250, 290, 250))];
    [pointArrs addObject:NSStringFromCGRect(CGRectMake(290, 250, 290, 250))];
    [pointArrs addObject:NSStringFromCGRect(CGRectMake(290, 250, 290, 250))];
    //控制点
    self.curveControlAndEndPoints = pointArrs;
}


@end
