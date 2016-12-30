//
//  MyControlTool.m
//  InKeLive
//
//  Created by 1 on 2016/12/22.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "MyControlTool.h"

@implementation MyControlTool

+ (UIButton *)buttonWithText:(NSString *)text textColor:(UIColor *)textColor font:(NSInteger)font tag:(NSInteger)tag frame:(CGRect)frame clickBlock:(void(^)(id x))clickBlock{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    //点击事件
    if (clickBlock) {
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:clickBlock];
    }
    return button;

}

@end
