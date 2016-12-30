//
//  NetWorkTools.h
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkTools : NSObject

+ (id)shareInstance;

//Get请求
- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(NSDictionary * dictionary))success
                 failure:(void (^)(NSError * error))failure;

@end
