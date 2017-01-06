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

//定义变量用于存储原设置
static BOOL SDImageCacheOldShouldDecompressImages = YES;
static BOOL SDImagedownloderOldShouldDecompressImages = YES;

static NSString * identifier = @"NearById";

@interface NearbyController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,CLLocationManagerDelegate>{
    NSInteger index;
}

@end

@implementation NearbyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //定位成功只刷新一次
    index = 0;
    //默认查看全部
    _limitStr = @"看全部";
    
     [self.view addSubview:self.nearCollectView];
    [self.locationManager startUpdatingLocation];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //保存原设置，禁用解压缩
    SDImageCache *canche = [SDImageCache sharedImageCache];
    SDImageCacheOldShouldDecompressImages = canche.shouldDecompressImages;
    canche.shouldDecompressImages = NO;
    
    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    SDImagedownloderOldShouldDecompressImages = downloder.shouldDecompressImages;
    downloder.shouldDecompressImages = NO;
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NearHeadReusableViewId" forIndexPath:indexPath];
    
    if ([reusableView isKindOfClass:[NearHeadReusableView class]]) {
        NearHeadReusableView *headView = (NearHeadReusableView *)reusableView;
        [headView.chooseButton setTitle:_limitStr forState:UIControlStateNormal];
        WEAKSELF;
        [headView setChooseCondition:^{
            [weakSelf setUpAcition];
        }];
    }
    
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 50);
}

//选择限制条件
- (void)setUpAcition{
    [self.actionSheet showInView:self.view];
}


#pragma CLLocationManagerDelegate
//定位成功
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    if (index == 1) {
        return;
    }
    self.requestUrl = [NSString stringWithFormat:NearByUrl,newLocation.coordinate.latitude,newLocation.coordinate.longitude];
    [self.locationManager stopUpdatingLocation];
    [self setUpLocation];
    index++;
}
//定位失败
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    self.requestUrl = [NSString stringWithFormat:NearFakeUrl];
    [self setUpLocation];
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //限制条件未知  0为查看全部  1查看女生  2为男生
    NSString *limitStr = [NSString stringWithFormat:@"&interest=%zd",buttonIndex];

    if ([self.requestUrl rangeOfString:@"&interest"].location == NSNotFound) {
         self.requestUrl = [NSString stringWithFormat:@"%@%@",self.requestUrl,limitStr];
    } else {
        NSArray *arr = [self.requestUrl componentsSeparatedByString:@"&interest"];
        self.requestUrl = [NSString stringWithFormat:@"%@%@",arr[0],limitStr];
    }
    switch (buttonIndex) {
        case 0:
            _limitStr = @"看全部";
            break;
        case 1:
            _limitStr = @"只看女";
            break;
        case 2:
            _limitStr = @"只看男";
            break;
        default:
            break;
    }
    
    
    [self loadData];
}

#pragma 加载

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
        [_nearCollectView registerNib:[UINib nibWithNibName:@"NearHeadReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NearHeadReusableViewId"];
    }
    return _nearCollectView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UIActionSheet *)actionSheet{
    if (!_actionSheet) {
        _actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"看全部",@"只看女",@"只看男" ,nil];
    }
    return _actionSheet;
}

#pragma dealloc
- (void)dealloc{
    self.nearCollectView.dataSource = nil;
    self.nearCollectView.delegate = nil;
    self.locationManager.delegate = nil;
    
    //恢复原设置
    SDImageCache *canche = [SDImageCache sharedImageCache];
    canche.shouldDecompressImages = SDImageCacheOldShouldDecompressImages;
    
    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    downloder.shouldDecompressImages = SDImagedownloderOldShouldDecompressImages;
}


@end
