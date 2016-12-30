//
//  BottomView.h
//  InKeLive
//
//  Created by 1 on 2016/12/13.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomView : UIView

//消息弹幕
@property (nonatomic,strong)UIButton *inforButton;

//礼物
@property (nonatomic,strong)UIButton *giftButton;

//分享
@property (nonatomic,strong)UIButton *shareButton;

@property (nonatomic, copy) void (^buttonClick)(NSInteger tag);

@property (nonatomic,strong)NSArray *imageArr;

@end
