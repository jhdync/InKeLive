//
//  RocketViews.h
//  NHGiftAnimationExample
//
//  Created by 1 on 2016/12/7.
//  Copyright © 2016年 jh All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RocketViews : UIView

@property (nullable, nonatomic, copy) NSArray *curveControlAndEndPoints;

+ (nullable instancetype)loadRocketViewWithPoint:(CGPoint)point;

- (void)addAnimationsMoveToPoint:(CGPoint)movePoints endPoint:(CGPoint)endPoint;

@end
