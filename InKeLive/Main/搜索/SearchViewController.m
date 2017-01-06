//
//  SearchViewController.m
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "SearchViewController.h"
#import "NetWorkTools.h"
#import "RecommendModel.h"
#import "MJExtension.h"
#import "LiveViewController.h"
#import "MoreViewController.h"

@class User_Nodes,Users,User,Live_Nodes,Lives,Creator;

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.searchView;
    [self.view addSubview:self.recommdTableView];
    [self loadData];
}


- (void)loadData{
    [[NetWorkTools shareInstance]getWithURLString:SEARCHURL parameters:nil success:^(NSDictionary *dictionary) {
        RecommendModel *model = [RecommendModel mj_objectWithKeyValues:dictionary];
        for (NSInteger i = 0; i < model.live_nodes.count; i++) {
            [self.sectionTitleArr addObject:model.live_nodes[i].title];
            [self.dataArr addObject:model.live_nodes[i]];
        }
        //今日推荐
        for (NSInteger i = 0; i < model.user_nodes[0].users.count; i++) {
            [self.recommdArr addObject:model.user_nodes[0].users[i]];
        }
        [self.recommdTableView reloadData];
    } failure:^(NSError *error) {
        
    }];

}

#pragma UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == self.sectionTitleArr.count ? self.recommdArr.count : 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitleArr.count + 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _recommendView = [[[NSBundle mainBundle]loadNibNamed:@"RecommendView" owner:self options:nil]lastObject];
    if (self.sectionTitleArr.count > 0) {
        if (section < self.sectionTitleArr.count) {
            _recommendView.recommedTitle.text = self.sectionTitleArr[section];
        } else {
            _recommendView.recommedTitle.text = @"今日推荐";
            _recommendView.recommendButton.hidden = YES;
        }
    }
    
    WEAKSELF;
    [_recommendView setRecommdMoreClick:^(NSString *keyStr) {
        MoreViewController *moreVc = [[MoreViewController alloc]init];
        moreVc.keywordStr = keyStr;
        [weakSelf.navigationController pushViewController:moreVc animated:YES];
    }];
    
    return _recommendView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == self.sectionTitleArr.count ? 60 : 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section < self.sectionTitleArr.count){
        //好声音、小清新、搞笑达人
        TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:0].lastObject;
        }
        Live_Nodes *model = self.dataArr[indexPath.section];
        [cell updataCell:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        //今日推荐
        RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendCellID"];
        cell.addButton.tag = indexPath.row;
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"RecommendCell" owner:self options:0].lastObject;
        }
        
        [cell setPayAttenBlock:^(NSInteger row) {
            //向服务器发起关注、取消关注请求
            //......
            
            //获取Users 改变 relation 刷新某一行状态
            Users *userModel = self.recommdArr[indexPath.row];
            if (userModel.relation.length == 0) {
                userModel.relation = @"following";
            } else {
                userModel.relation = @"";
            }
            
            //刷新点击关注、取消关注的那一行
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:self.sectionTitleArr.count];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
        Users *userModel = self.recommdArr[indexPath.row];
        [cell updataCell:userModel.user relation:userModel.relation];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != self.sectionTitleArr.count) {
        LiveViewController *liveVC = [[LiveViewController alloc]init];
        [self.navigationController pushViewController:liveVC animated:YES];
    }
}

#pragma 加载
- (UITableView *)recommdTableView{
    if (!_recommdTableView) {
        _recommdTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _recommdTableView.delegate = self;
        _recommdTableView.dataSource = self;
        _recommdTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_recommdTableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"UITableViewCellId"];
        [_recommdTableView registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellReuseIdentifier:@"RecommendCellID"];
    }
    return _recommdTableView;
}

//搜索栏
- (SearchView *)searchView{
    if (!_searchView) {
        _searchView = [[SearchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        WEAKSELF;
        [_searchView setCancleBlock:^{
            [AutoCommon hideKeyBoard];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _searchView;
}

//标题数组
- (NSMutableArray *)sectionTitleArr{
    if (!_sectionTitleArr) {
        _sectionTitleArr = [NSMutableArray array];
    }
    return _sectionTitleArr;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

//今日热门
- (NSMutableArray *)recommdArr{
    if (!_recommdArr) {
        _recommdArr = [NSMutableArray array];
    }
    return _recommdArr;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

@end
