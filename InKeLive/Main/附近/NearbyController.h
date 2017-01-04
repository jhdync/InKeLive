//
//  NearbyController.h
//  InKeLive
//
//  Created by 1 on 2016/12/26.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NearHeadReusableView.h"

@interface NearbyController : UIViewController<UIActionSheetDelegate>{
    //限制条件
    NSString *_limitStr;
}

@property (nonatomic,strong)UICollectionView *nearCollectView;

@property (nonatomic,strong)NSMutableArray *dataArr;

//定位
@property (nonatomic,strong)CLLocationManager *locationManager;

//请求url
@property (nonatomic,copy)NSString *requestUrl;

//选择弹框
@property (nonatomic,strong)UIActionSheet *actionSheet;

@end
