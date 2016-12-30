//
//  CarsViews.h
//  InKeLive
//
//  Created by 1 on 2016/12/15.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarsViews : UIView


@property (nonatomic,strong,nullable)NSMutableArray *carArr;

@property (nullable, nonatomic, copy) NSArray *curveControlAndEndPoints;

+ (nullable instancetype)loadCarViewWithPoint:(CGPoint)point;

- (void)addAnimationsMoveToPoint:(CGPoint)movePoints endPoint:(CGPoint)endPoint;

@end
