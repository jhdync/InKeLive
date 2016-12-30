//
//  NearModel.m
//  InKeLive
//
//  Created by 1 on 2016/12/27.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "NearModel.h"

@implementation NearModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setUpdic:(NSDictionary *)dic{
    _portrait = [[dic objectForKey:@"creator"] objectForKey:@"portrait"];
    _level = [[dic objectForKey:@"creator"] objectForKey:@"level"];
    _city = [dic objectForKey:@"city"];
    _distance = [dic objectForKey:@"distance"];
}

@end
