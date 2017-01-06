//
//  SearchView.m
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.searchBar];
        [self addSubview:self.cancleButton];
    }
    return self;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 75, 30)];
        [_searchBar setSearchBarStyle:UISearchBarStyleDefault];
        
        //_searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.backgroundImage = [UIImage imageNamed:@"global_searchbox_bg"];
        
        _searchBar.layer.cornerRadius = 14;
        _searchBar.layer.masksToBounds = YES;
        [_searchBar setPlaceholder:@"请输入昵称/印客号"];
        
    }
    return _searchBar;
}

//取消
- (void)cancleClick{
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

- (UIButton *)cancleButton{
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.frame = CGRectMake(self.searchBar.width + 5, 0, 50, 30);
        [_cancleButton addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _cancleButton;
}

@end
