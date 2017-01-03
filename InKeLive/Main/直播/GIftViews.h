//
//  GIftViews.h
//  InKeLive
//
//  Created by 1 on 2017/1/3.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GIftViews : UIView

//礼物图片
@property (nonatomic,strong)UIImageView *giftImageView;

//连击
@property (nonatomic,strong)UIButton *hitButton;

- (instancetype)initWithFrame:(CGRect)frame imageStr:(NSString *)str;

@end
