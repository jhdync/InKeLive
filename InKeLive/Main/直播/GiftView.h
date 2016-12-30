//
//  GiftView.h
//  InKeLive
//
//  Created by 1 on 2016/12/15.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftView : UIView

//底部礼物栏
@property (nonatomic,strong)UIView *bottomView;

@property (nonatomic,strong)NSArray *giftArr;

@property (nonatomic,copy)void (^giftClick)(NSInteger tag);

@property (nonatomic,copy)void (^grayClick)();

- (void)popShow;

@end
