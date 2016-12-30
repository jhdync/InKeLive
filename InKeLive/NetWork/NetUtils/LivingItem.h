//
//  LivingItem.h
//  InKeLive
//
//  Created by 1 on 2016/12/14.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LivingItem : NSObject

@property (nonatomic, strong) NSString *hosterId;    // 主播ID
@property (nonatomic, strong) NSString *rtmp_url;    // rtmp 推流地址
@property (nonatomic, strong) NSString *rtmp;
@property (nonatomic, strong) NSString *hls_url;     // hls 地址
@property (nonatomic, strong) NSString *topic;       // 标题
@property (nonatomic, strong) NSString *andyrtcId;   // anyrtcID
@property (nonatomic, strong) NSString *LiveMembers; // 观看人数
@property (nonatomic, strong) NSNumber *isAudioOnly; // 是否是音频直播

@end
