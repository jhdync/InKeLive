//
//  PresentModel.h
//  PresentDemo
//
//  Created by siping ruan on 16/10/9.
//  Copyright © 2016年 阮思平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PresentModelAble.h"

@interface PresentModel : NSObject<PresentModelAble>

@property (copy, nonatomic) NSString *sender;
@property (copy, nonatomic) NSString *giftName;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *giftImageName;
@property (assign, nonatomic) NSInteger giftNumber;

+ (instancetype)modelWithSender:(NSString *)sender
                       giftName:(NSString *)giftName
                           icon:(NSString *)icon
                  giftImageName:(NSString *)giftImageName;

@end
