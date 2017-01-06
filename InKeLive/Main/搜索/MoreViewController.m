//
//  MoreViewController.m
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "MoreViewController.h"
#import "NetWorkTools.h"
#import "MJAnimHeader.h"
#import "LiveViewController.h"

@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.moreTableView];
    if (self.keywordStr.length == 0) {
        self.keywordStr = @"更多";
    }
    self.navigationItem.title = self.keywordStr;
    
    UIImage *leftImg = [UIImage imageNamed:@"messagechat_pop_back"];
    leftImg = [leftImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImg style:UIBarButtonItemStylePlain target:self action:@selector(enterSearchClick)];
    
    MJAnimHeader *header = [MJAnimHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header beginRefreshing];
    self.moreTableView.mj_header = header;
}

- (void)loadData{
    NSString *requestUrl = [NSString stringWithFormat:SEARCHMOREURL,self.keywordStr];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[NetWorkTools shareInstance] getWithURLString:requestUrl parameters:nil success:^(NSDictionary *dictionary) {
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
        [self.moreTableView reloadData];
        [self.moreTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.moreTableView.mj_header endRefreshing];
    }];
}

- (void)enterSearchClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

#pragma UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InKeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"INKeCellId"];
    if (!cell) {
        cell = [[InKeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"INKeCellId"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    InKeModel *model = [self.dataArr objectAtIndex:indexPath.row];
    [cell updateCell:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveViewController *liveVC = [[LiveViewController alloc]init];
    [self.navigationController pushViewController:liveVC animated:YES];
}


#pragma 加载
- (UITableView *)moreTableView{
    if (!_moreTableView) {
        _moreTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _moreTableView.delegate = self;
        _moreTableView.dataSource = self;
        _moreTableView.rowHeight = [UIScreen mainScreen].bounds.size.width * 1.3 + 1;
        _moreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _moreTableView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


@end
