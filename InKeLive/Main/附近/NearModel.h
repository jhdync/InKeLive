//
//  NearModel.h
//  InKeLive
//
//  Created by 1 on 2016/12/27.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearModel : NSObject

//头像
@property (nonatomic,copy)NSString *portrait;

//等级
@property (nonatomic,copy)NSString *level;

//城市
@property (nonatomic,copy)NSString *city;

//距离
@property (nonatomic,copy)NSString *distance;

- (void)setUpdic:(NSDictionary *)dic;

@end
