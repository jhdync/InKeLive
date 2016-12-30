//
//  CarsViews.m
//  InKeLive
//
//  Created by 1 on 2016/12/15.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "CarsViews.h"

@interface CarsViews ()<CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *afterWheel;
@property (weak, nonatomic) IBOutlet UIImageView *beforeWheel;
@property (weak, nonatomic) IBOutlet UIImageView *carBackImage;
@property (weak, nonatomic) IBOutlet UIImageView *light;


@property (nonatomic, copy) NSMutableArray *animations;

@end

@implementation CarsViews

+ (instancetype)loadCarViewWithPoint:(CGPoint)point{
    CarsViews *car = [[NSBundle mainBundle]loadNibNamed:@"CarsViews" owner:self options:nil].lastObject;
    car.frame = CGRectMake(point.x, point.y, 166, 70);
    [car setPlaneScrewImages:nil];
    return car;
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
    position.duration = 5.0;
    position.speed = 0.7;
    position.removedOnCompletion = NO;
    position.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 2.0f;
    scaleAnimation.beginTime = 0.0f;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.7];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.5];;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 7.f;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.delegate = self;
    animationGroup.animations = @[position,scaleAnimation];
    
    if (self.animations.count == 0) {
        [self.animations addObject:animationGroup];
        [self.layer addAnimation:animationGroup forKey:@"carView"];
    }else{
        [self.animations addObject:animationGroup];
    }
}


- (void)setPlaneScrewImages:(NSArray *)imageArray{
    
    NSMutableArray* after = [NSMutableArray array];
    for(int i = 1;i<4;i++){
        [after addObject: [UIImage imageNamed:[NSString stringWithFormat:@"porche-f%d",i]]];
    }
    _afterWheel.animationImages = after;
    _afterWheel.animationDuration = 0.05;
    _afterWheel.animationRepeatCount = 0;
    [_afterWheel startAnimating];
    
    NSMutableArray* before = [NSMutableArray array];
    for(int i = 1;i<4;i++){
        [before addObject: [UIImage imageNamed:[NSString stringWithFormat:@"porche-b%d",i]]];
    }
    _beforeWheel.animationImages = before;
    _beforeWheel.animationDuration = 0.05;
    _beforeWheel.animationRepeatCount = 0;
    [_beforeWheel startAnimating];
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima.fromValue = [NSNumber numberWithFloat:0.2f];
    anima.toValue = [NSNumber numberWithFloat:1.5f];
    anima.duration = 1.2f;
    anima.repeatCount = 3;
    [_light.layer addAnimation:anima forKey:@"scaleAnimation"];
    
    UIImage *yellowImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"3" ofType:@"png"]];
    UIImage *redImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"]];
    
    NSArray *imageArr = @[redImage,yellowImage,redImage];
    _carBackImage.animationImages = imageArr;
    
    _carBackImage.animationDuration = 1.8f;
    
    _carBackImage.animationRepeatCount = 1;
    
    [_carBackImage startAnimating];
    //释放内存
    [self performSelector:@selector(deleteImages) withObject:nil afterDelay:1];
}

- (void)deleteImages{
    [_carBackImage stopAnimating];
    _carBackImage.animationImages = nil;
}

#pragma CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}


#pragma 加载
- (NSArray *)curveControlAndEndPoints{
    if (!_curveControlAndEndPoints) {
        NSMutableArray *pointArrs = [[NSMutableArray alloc] init];
        CGFloat width = [UIScreen mainScreen].bounds.size.width / 2;
        [pointArrs addObject:NSStringFromCGRect(CGRectMake(width, 300, width, 300))];
        _curveControlAndEndPoints = pointArrs;
    };
    return _curveControlAndEndPoints;
}

- (NSMutableArray *)animations{
    
    if (_animations == nil) {
        _animations = [[NSMutableArray alloc] init];
    }
    return _animations;
}

@end
