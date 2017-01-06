//
//  RecommendModel.h
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User_Nodes,Users,User,Live_Nodes,Lives,Creator;
@interface RecommendModel : NSObject


@property (nonatomic, strong) NSArray<Live_Nodes *> *live_nodes;

@property (nonatomic, assign) NSInteger dm_error;

@property (nonatomic, strong) NSArray<User_Nodes *> *user_nodes;

@property (nonatomic, copy) NSString *error_msg;


@end
@interface User_Nodes : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<Users *> *users;

@end

@interface Users : NSObject

@property (nonatomic, copy) NSString *relation;

@property (nonatomic, strong) User *user;

@property (nonatomic, copy) NSString *reason;

@end

@interface User : NSObject

@property (nonatomic, copy) NSString *third_platform;

@property (nonatomic, assign) NSInteger rank_veri;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, assign) NSInteger gmutex;

@property (nonatomic, assign) NSInteger verified;

@property (nonatomic, copy) NSString *emotion;

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, assign) NSInteger inke_verify;

@property (nonatomic, copy) NSString *verified_reason;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *birth;

@property (nonatomic, copy) NSString *hometown;

@property (nonatomic, copy) NSString *portrait;

@property (nonatomic, copy) NSString *veri_info;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, copy) NSString *profession;

@end

@interface Live_Nodes : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<Lives *> *lives;

@end

@interface Lives : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, assign) NSInteger room_id;

@property (nonatomic, assign) NSInteger online_users;

@property (nonatomic, assign) NSInteger version;

@property (nonatomic, assign) NSInteger rotate;

@property (nonatomic, assign) NSInteger multi;

@property (nonatomic, assign) NSInteger link;

@property (nonatomic, copy) NSString *share_addr;

@property (nonatomic, assign) NSInteger slot;

@property (nonatomic, strong) Creator *creator;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, assign) NSInteger group;

@property (nonatomic, copy) NSString *stream_addr;

@property (nonatomic, assign) NSInteger pub_stat;

@property (nonatomic, assign) NSInteger optimal;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger status;

@end

@interface Creator : NSObject

@property (nonatomic, copy) NSString *third_platform;

@property (nonatomic, assign) NSInteger rank_veri;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, assign) NSInteger gmutex;

@property (nonatomic, assign) NSInteger verified;

@property (nonatomic, copy) NSString *emotion;

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, assign) NSInteger inke_verify;

@property (nonatomic, copy) NSString *verified_reason;

@property (nonatomic, copy) NSString *birth;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *portrait;

@property (nonatomic, copy) NSString *hometown;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *veri_info;

@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, copy) NSString *profession;

@end

