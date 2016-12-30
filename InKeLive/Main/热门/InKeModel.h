//
//  InKeModel.h
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InKeModel : NSObject

/**
 *  详情
 */
@property(nonatomic,strong)NSDictionary * creator;

/**
 *  播放流
 */
@property(nonatomic,copy)NSString * stream_addr;
/**
 *  在线
 */
@property(nonatomic,copy)NSString  *online_users;

/**
 *  id
 */
@property(nonatomic,copy)NSString * ID;

/**
 *  头像
 */
@property(nonatomic,copy)NSString * portrait;

/**
 *  名字
 */
@property(nonatomic,copy)NSString * nick;

/**
 *  地区
 */
@property(nonatomic,copy)NSString * city;


@end
