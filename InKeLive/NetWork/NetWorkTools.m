//
//  NetWorkTools.m
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "NetWorkTools.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"

#define TIMEOUT 10.0f

@implementation NetWorkTools

+ (id)shareInstance{
    static dispatch_once_t onceToken;
    static NetWorkTools *tools = nil;
    dispatch_once(&onceToken, ^{
        tools = [[NetWorkTools alloc]init];
    });

    return tools;
}

-(AFHTTPRequestOperationManager *)baseHtppRequest{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    //设置网络请求为忽略本地缓存  直接请求服务器
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"text/html", @"application/json", nil];
    return manager;
}



#pragma mark GET请求 
- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(NSDictionary * dictionary))success
                 failure:(void (^)(NSError * error))failure {
    AFHTTPRequestOperationManager *manager = [self baseHtppRequest];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *appDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (responseObject) {
            success(appDic);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }
    }];
}

@end
