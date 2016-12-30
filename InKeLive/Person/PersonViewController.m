//
//  PersonViewController.m
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "PersonViewController.h"

@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.personTableView];
}

#pragma UITableViewDelegate UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.personHeadView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return SCREEN_HEIGHT/2;
    }
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.titleArr[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 0.1;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = RGB(245, 251, 251);
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellId = @"personCenterCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    (self.personTableView.contentOffset.y > 0) ? (self.personTableView.backgroundView.hidden = YES):(self.personTableView.backgroundView.hidden = NO);
}


#pragma 加载
- (UITableView *)personTableView{
    if (!_personTableView) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _personTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStyleGrouped];
        _personTableView.delegate = self;
        _personTableView.dataSource = self;
        _personTableView.showsVerticalScrollIndicator = NO;
        _personTableView.rowHeight = 70;
        _personTableView.separatorColor = RGBA(0, 0, 0, 0.1);
        
        //backView下拉
        UIView *backView = [[UIView alloc]initWithFrame:self.view.bounds];
        backView.backgroundColor = RGB(36, 215, 200);
        _personTableView.backgroundView = backView;
        
        [[UITableView appearance] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [[UITableView appearance] setSeparatorInset:UIEdgeInsetsZero];
        [[UITableViewCell appearance] setSeparatorInset:UIEdgeInsetsZero];
        
        if ([UITableView instancesRespondToSelector:@selector(setLayoutMargins:)]) {
            [[UITableView appearance] setLayoutMargins:UIEdgeInsetsZero];
            [[UITableViewCell appearance] setLayoutMargins:UIEdgeInsetsZero];
            [[UITableViewCell appearance] setPreservesSuperviewLayoutMargins:NO];
        }
    }
    return _personTableView;
}

- (PersonHeadView *)personHeadView{
    if (!_personHeadView) {
        _personHeadView = [[[NSBundle mainBundle]loadNibNamed:@"PersonHeadView" owner:self options:nil]lastObject];
    }
    return _personHeadView;
}

- (NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@[@"映票贡献榜",@"短视频",@"收益",@"账户"],@[@"等级",@"实名制"],@[@"设置"]];
    }
    return _titleArr;
}

@end
