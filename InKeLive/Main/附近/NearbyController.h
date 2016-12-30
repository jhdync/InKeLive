//
//  NearbyController.h
//  InKeLive
//
//  Created by 1 on 2016/12/26.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NearbyController : UIViewController

@property (nonatomic,strong)UICollectionView *nearCollectView;

@property (nonatomic,strong)NSMutableArray *dataArr;

//定位
@property (nonatomic,strong)CLLocationManager *locationManager;

@property (nonatomic,copy)NSString *requestUrl;

@end
