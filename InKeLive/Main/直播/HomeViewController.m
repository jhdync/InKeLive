//
//  HomeViewController.m
//  InKeLive
//
//  Created by 1 on 2016/12/26.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "HomeViewController.h"
#import "MainViewController.h"
#import "AttentionController.h"
#import "NearbyController.h"
#import "BaseViewController.h"
#import "SearchViewController.h"

@interface HomeViewController ()<UIScrollViewDelegate>

@end

@implementation HomeViewController{
    NSMutableArray *_arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = self.titleView;
    UIImage *leftImg = [UIImage imageNamed:@"left_search"];
    leftImg = [leftImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImg style:UIBarButtonItemStylePlain target:self action:@selector(enterSearchClick)];
    UIImage *rightImg = [UIImage imageNamed:@"right_message"];
    rightImg = [rightImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImg style:UIBarButtonItemStylePlain target:self action:nil];
    [self.view addSubview:self.homeScrollView];
    [self initChildViewControllers];
}

- (void)initChildViewControllers{
    //关注
    AttentionController *attentVC = [[AttentionController alloc]init];
    [self addChildViewController:attentVC];
    
    //热门
    MainViewController*mainVc = [[MainViewController alloc]init];
    [self addChildViewController:mainVc];
    
    //附近
    NearbyController *nearVc = [[NearbyController alloc]init];
    [self addChildViewController:nearVc];
    
    _arr = [NSMutableArray arrayWithObjects:attentVC,mainVc,nearVc,nil];
    
    for (NSInteger i=0; i<self.childViewControllers.count; i++) {
        UIViewController *cls = self.childViewControllers[i];
        cls.view.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49 - 64);
        [self.homeScrollView addSubview:cls.view];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.titleView scrollMove:(scrollView.contentOffset.x/SCREEN_WIDTH + 50)];
}

- (void)enterSearchClick{
    SearchViewController *searchVc = [[SearchViewController alloc]init];
    BaseViewController *baseVc = [[BaseViewController alloc]initWithRootViewController:searchVc];
    [self presentViewController:baseVc animated:YES completion:nil];
}


#pragma  加载
- (TopTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[TopTitleView alloc]initWithFrame:CGRectMake(0, 0, 240, 44)];
        WEAKSELF;
        [_titleView setTitleClick:^(NSInteger tag) {
            CGPoint point = CGPointMake((tag - 50) * SCREEN_WIDTH ,weakSelf.homeScrollView.contentOffset.y);
            
            [weakSelf.homeScrollView setContentOffset:point animated:YES];
        }];
    }
    return _titleView;
}

- (UIScrollView *)homeScrollView{
    if (!_homeScrollView) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _homeScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _homeScrollView.contentSize = CGSizeMake(3 * SCREEN_WIDTH, 0);
        _homeScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        _homeScrollView.showsHorizontalScrollIndicator = NO;
        _homeScrollView.pagingEnabled = YES;
        _homeScrollView.bounces = NO;
        _homeScrollView.delegate = self;
        _homeScrollView.userInteractionEnabled = YES;
        _homeScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _homeScrollView;
}

@end
