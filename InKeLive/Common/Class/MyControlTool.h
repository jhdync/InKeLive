//
//  MyControlTool.h
//  InKeLive
//
//  Created by 1 on 2016/12/22.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyControlTool : NSObject

/**
 文字按钮
 */
+ (UIButton *)buttonWithText:(NSString *)text textColor:(UIColor *)textColor font:(NSInteger)font tag:(NSInteger)tag frame:(CGRect)frame clickBlock:(void(^)(id x))clickBlock;

@end
