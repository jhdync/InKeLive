//
//  PresentModel.m
//  PresentDemo
//
//  Created by siping ruan on 16/10/9.
//  Copyright © 2016年 阮思平. All rights reserved.
//

#import "PresentModel.h"

@implementation PresentModel

+ (instancetype)modelWithSender:(NSString *)sender giftName:(NSString *)giftName icon:(NSString *)icon giftImageName:(NSString *)giftImageName
{
    PresentModel *model = [[PresentModel alloc] init];
    model.sender        = sender;
    model.giftName      = giftName;
    model.icon          = icon;
    model.giftImageName = giftImageName;
    return model;
}

@end
