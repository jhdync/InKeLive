//
//  RecommendModel.m
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "RecommendModel.h"

@implementation RecommendModel


+ (NSDictionary *)objectClassInArray{
    return @{@"user_nodes" : [User_Nodes class], @"live_nodes" : [Live_Nodes class]};
}

@end
@implementation User_Nodes

+ (NSDictionary *)objectClassInArray{
    return @{@"users" : [Users class]};
}

@end


@implementation Users

@end


@implementation User

@end


@implementation Live_Nodes

+ (NSDictionary *)objectClassInArray{
    return @{@"lives" : [Lives class]};
}

@end


@implementation Lives

@end


@implementation Creator

@end


