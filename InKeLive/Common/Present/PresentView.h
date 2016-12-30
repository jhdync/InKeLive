//
//  PresentView.h
//  PresentDemo
//
//  Created by 阮思平 on 16/10/2.
//  Copyright © 2016年 阮思平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentViewCell.h"

@protocol PresentViewDelegate;

@interface PresentView : UIView

/**
 *  cell高度(默认40)
 */
@property (assign, nonatomic) CGFloat cellHeight;
/**
 *  礼物动画展示时间(默认3秒)
 */
@property (assign, nonatomic)NSTimeInterval showTime;
/**
 *  轨道总数
 */
@property (assign, nonatomic, readonly) NSInteger rows;
@property (weak, nonatomic) id<PresentViewDelegate> delegate;
/**
 *  获取对应轨道上的cell
 */
- (__kindof PresentViewCell *)cellForRowAtIndex:(NSUInteger)index;
/**
 *  插入送礼消息
 *
 *  @param models 礼物模型数组中的模型必须遵守PresentModelAble协议
 *  @param flag   是否需要连乘动画
 */
- (void)insertPresentMessages:(NSArray<id <PresentModelAble>> *)models showShakeAnimation:(BOOL)flag;
/**
 释放相关引用变量
 */
- (void)releaseVariable;

@end

@protocol PresentViewDelegate <NSObject>

@required
/**
 *  返回自定义cell样式
 */
- (PresentViewCell *)presentView:(PresentView *)presentView cellOfRow:(NSInteger)row;
/**
 *  礼物动画即将展示的时调用，根据礼物消息类型为自定义的cell设置对应的模型数据用于展示
 *
 *  @param cell        用来展示动画的cell
 *  @param model       礼物模型
 */
- (void)presentView:(PresentView *)presentView
         configCell:(PresentViewCell *)cell
              model:(id<PresentModelAble>)model;

@optional

/**
 *  cell点击事件
 */
- (void)presentView:(PresentView *)presentView didSelectedCellOfRowAtIndex:(NSUInteger)index;

/**
 一组连乘动画执行完成回调
 */
- (void)presentView:(PresentView *)presentView animationCompleted:(NSInteger)shakeNumber model:(id<PresentModelAble>)model;

@end
