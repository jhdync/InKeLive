//
//  ShipViews.m
//  InKeLive
//
//  Created by 1 on 2016/12/15.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "ShipViews.h"


@interface ShipViews ()<CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *seaImage;

@property (weak, nonatomic) IBOutlet UIImageView *shipView;

@property (strong, nonatomic) UIImageView *seaImageView;

@property (nonatomic, copy) NSMutableArray *animations;

@end

@implementation ShipViews

- (NSMutableArray *)animations{
    
    if (_animations == nil) {
        _animations = [[NSMutableArray alloc] init];
    }
    return _animations;
}

+ (instancetype)loadShipViewWithPoint:(CGPoint)point{
    ShipViews *ship = [[NSBundle mainBundle]loadNibNamed:@"ShipViews" owner:self options:nil].lastObject;
    ship.frame = CGRectMake(point.x, point.y, 166,100);
    [ship setShipScrewImages:nil];
    return ship;
}


//CGPointMake(0, 100)  end:CGPointMake(self.view.bounds.size.width +166, 500)
- (void)addAnimationsMoveToPoint:(CGPoint)movePoints endPoint:(CGPoint)endPoint{
    
    CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, movePoints.x, movePoints.y);
    
    [self.curveControlAndEndPoints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = CGRectFromString(obj);
        CGPathAddQuadCurveToPoint(path, NULL, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    }];
    
    CGPathAddQuadCurveToPoint(path, NULL, endPoint.x, endPoint.y, endPoint.x, endPoint.y);
    position.path = path;
    position.duration = 5.0f;
    position.speed = 0.7;
    position.removedOnCompletion = NO;
    position.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 5.0f;
    scaleAnimation.beginTime = 0.0f;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:2.5];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    NSValue *value1 = [NSNumber numberWithFloat:-M_PI/180*8];
    NSValue *value2 = [NSNumber numberWithFloat:M_PI/180*8];
    NSValue *value3 = [NSNumber numberWithFloat:-M_PI/180*8];
    anima.values = @[value1,value2,value3];
    anima.repeatCount = MAXFLOAT;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 7.0f;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.delegate = self;
    animationGroup.animations = @[position,scaleAnimation,anima];
    
    if (self.animations.count == 0) {
        [self.animations addObject:animationGroup];
        [self.layer addAnimation:animationGroup forKey:@"shipView"];
        
    }else{
        [self.animations addObject:animationGroup];
    }
}


- (void)setShipScrewImages:(NSArray *)imageArray{
    NSMutableArray *tempArr = [NSMutableArray array];
    UIImage *image0 =  [UIImage imageNamed:@"ship_move_water_2"];
    UIImage *image1 = [UIImage imageNamed:@"ship_move_water_1"];
    UIImage *image2 = [UIImage imageNamed:@"ship_water"];
    [tempArr addObject:image0];
    [tempArr addObject:image1];
    [tempArr addObject:image2];

    self.seaImage.animationImages = tempArr;
    
    self.seaImage.animationDuration = 0.1f;
    
    self.seaImage.animationRepeatCount = 0;
    
    [self.seaImage startAnimating];

}


#pragma CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.seaImage stopAnimating];
    self.seaImage.animationImages = nil;
    
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}


#pragma 加载
- (NSArray *)curveControlAndEndPoints{
    if (!_curveControlAndEndPoints) {
        NSMutableArray *pointArrs = [[NSMutableArray alloc] init];
        CGFloat width = [UIScreen mainScreen].bounds.size.width / 2;
        [pointArrs addObject:NSStringFromCGRect(CGRectMake(width, 450, width, 450))];
        _curveControlAndEndPoints = pointArrs;
    };
    return _curveControlAndEndPoints;
}


@end
