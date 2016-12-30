//
//  NearbyController.m
//  InKeLive
//
//  Created by 1 on 2016/12/26.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "NearbyController.h"
#import "NearCell.h"
#import "NetWorkTools.h"
#import "NearModel.h"
#import "MJAnimHeader.h"
#import "LiveViewController.h"
#import "LiveViewController.h"

#define margin 3
#define SideWh (SCREEN_WIDTH - 2 * margin)/3
#define Ratio 1.3

static NSString * identifier = @"NearById";

@interface NearbyController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,CLLocationManagerDelegate>{
    NSInteger index;
}

@end

@implementation NearbyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    index = 0;
     [self.view addSubview:self.nearCollectView];
    [self.locationManager startUpdatingLocation];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setUpLocation{
    MJAnimHeader *header = [MJAnimHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header beginRefreshing];
    self.nearCollectView.mj_header = header;
}

- (void)loadData{
    [[NetWorkTools shareInstance] getWithURLString:self.requestUrl parameters:nil success:^(NSDictionary *dictionary) {
        [self.dataArr removeAllObjects];
        for (NSDictionary *dic in dictionary[@"lives"]) {
            NearModel *model = [[NearModel alloc]init];
            [model setUpdic:dic];
            [self.dataArr addObject:model];
        }
        [self.nearCollectView.mj_header endRefreshing];
        [self.nearCollectView reloadData];
    } failure:^(NSError *error) {
    }];
}



#pragma UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SideWh, SideWh * Ratio);
}


#pragma UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NearCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NearModel *model = self.dataArr[indexPath.row];
    [cell updateCell:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LiveViewController *live = [[LiveViewController alloc]init];
    [self.navigationController pushViewController:live animated:YES];
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NearCell *nearCell = (NearCell *)cell;
    [nearCell showAnimation];
    
}

- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        //创建定位对象
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter =100.0;
        [_locationManager requestWhenInUseAuthorization];
    }
    return _locationManager;
}

#pragma CLLocationManagerDelegate
//定位成功
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    if (index == 1) {
        return;
    }
    self.requestUrl = [NSString stringWithFormat:@"http:/service.ingkee.com/api/live/near_recommend?uid=247164228&latitude=%f&longitude=%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
    [self.locationManager stopUpdatingLocation];
    [self setUpLocation];
    index++;
}
//定位失败
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    self.requestUrl = [NSString stringWithFormat:@"http:/service.ingkee.com/api/live/near_recommend?uid=247164228&latitude=31.347102&longitude=121.5117"];
    [self setUpLocation];
}

#pragma 加载
- (UICollectionView *)nearCollectView{
    if (!_nearCollectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = margin;
        layout.minimumInteritemSpacing = margin;
        _nearCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 113)  collectionViewLayout:layout];
        _nearCollectView.backgroundColor = [UIColor whiteColor];
        _nearCollectView.delegate = self;
        _nearCollectView.dataSource = self;
        [_nearCollectView registerClass:[NearCell class] forCellWithReuseIdentifier:identifier];
    }
    return _nearCollectView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


@end
