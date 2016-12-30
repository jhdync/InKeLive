//
//  AttentionController.m
//  InKeLive
//
//  Created by 1 on 2016/12/26.
//  Copyright © 2016年 jh. All rights reserved.
//

#import "AttentionController.h"
#import "EmptyView.h"

@interface AttentionController ()

@property (nonatomic,strong)EmptyView *emptyView;

@end

@implementation AttentionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.emptyView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (EmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc]initWithFrame:self.view.bounds];
    }
    return _emptyView;
}

@end
