//
//  MainViewController.m
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
// 热门

#import "MainViewController.h"
#import "NetWorkTools.h"
#import "InKeCell.h"
#import "InKeModel.h"
#import "LiveViewController.h"
#import "NetUtils.h"
#import "MJAnimHeader.h"

// 映客接口
#define INKeUrl [NSString stringWithFormat:@"http://service.inke.com/api/live/gettop?lc=0000000000000045&cc=TG0001&cv=IK3.8.30_Iphone&proto=7&idfa=768901CC-814F-4358-8F71-F54BA16B251A&idfv=F5B7A445-841C-4D49-A4DB-887B9D31BDDB&devi=03b0ccddf1a8112717b7533d089d9bb448c50e6e&osversion=ios_10.000000&ua=iPhone8_1&imei=&imsi=&uid=139587564&sid=200JUbbvFT8FKXtTjZlDyh9VsrEF8uRAPSt3B8oMi2F4i0k0gsjA&conn=wifi&mtid=cef7f9ee1bbc1d9f01921eea68b0218a&mtxid=d4ee73ae06c&logid=133,5,124&count=5&multiaddr=1&s_sg=ec6dd66c26acc0cbd70caf2099810430&s_sc=100&s_st=1483420987"]


@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

//数据源
@property (nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic,strong)UITableView *mainTableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mainTableView];
    
    MJAnimHeader *header = [MJAnimHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header beginRefreshing];
    self.mainTableView.mj_header = header;
}

/**
 请求直播间数据(当有两部手机时，一个创建开启直播，另一个就能获取到直播间数据，点击进入直播页，则为直播数据，否则为假数据)
 */
- (void)getData{
     [self.livingDataArray removeAllObjects];
    __weak typeof(self)weakSelf = self;
    [[NetUtils shead] getLivingList:^(NSArray *array, NSError *error, int code) {
        if (code == 200) {
            weakSelf.livingDataArray = [array mutableCopy];
        }
    }];
}

- (void)loadData{
    //直播间数据
     [self getData];
    
    [[NetWorkTools shareInstance]getWithURLString:INKeUrl parameters:nil success:^(NSDictionary *dictionary) {
        [self.dataArr removeAllObjects];
        NSArray *listArray = [dictionary objectForKey:@"lives"];
        
        for (NSDictionary *dic in listArray) {
            InKeModel *inKeModel = [[InKeModel alloc] init];
            inKeModel.city = dic[@"city"];
            inKeModel.portrait = dic[@"creator"][@"portrait"];
            inKeModel.nick = dic[@"creator"][@"nick"];
            inKeModel.online_users = [NSString stringWithFormat:@"%@",dic[@"online_users"]];
            [self.dataArr addObject:inKeModel];
        }
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.mainTableView.mj_header endRefreshing];
    }];
}

#pragma   UITableViewDataSource  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifierId = @"InKeCellId";
    InKeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierId];
    if (cell == nil) {
        cell = [[InKeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    InKeModel *model = [self.dataArr objectAtIndex:indexPath.row];
    [cell updateCell:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveViewController *live = [[LiveViewController alloc]init];
    if (self.livingDataArray.count > 0) {
        //默认只开启一个直播（开启多个可自行判断添加）
        LivingItem *item = [self.livingDataArray objectAtIndex:0];
        live.livingItem = item;
    }
    
    [self.navigationController pushViewController:live animated:YES];

}

#pragma 加载
- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

- (UITableView *)mainTableView{
    if (_mainTableView == nil) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 113) style:UITableViewStylePlain];
        _mainTableView.delegate  = self;
        _mainTableView.dataSource = self;
        _mainTableView.rowHeight = [UIScreen mainScreen].bounds.size.width * 1.3 + 1;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc{
    self.mainTableView.dataSource = nil;
    self.mainTableView.delegate = nil;
}

@end
