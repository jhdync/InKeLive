//
//  BottomView.m
//  InKeLive
//
//  Created by 1 on 2016/12/13.
//  Copyright © 2016年 jh. All rights reserved.
//底部工具栏

#import "BottomView.h"

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.1);
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    for (NSInteger i = 0; i < self.imageArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:self.imageArr[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        if (i == 0) {
            button.frame = CGRectMake(10, 10, 40, 40);
        } else{
            button.frame = CGRectMake((SCREEN_WIDTH-180)+(i-1) * 60, 10, 40, 40);
        }
        [self addSubview:button];
    }
}

- (void)bottomClick:(id)sender{
    UIButton *tagButton = (UIButton *)sender;
    if (self.buttonClick) {
        self.buttonClick(tagButton.tag);
    }
}

- (NSArray *)imageArr{
    if (_imageArr == nil) {
        _imageArr = @[@"mg_room_btn_liao_h",@"mg_room_btn_liwu_h",@"mg_room_btn_fenxiang_h"];
    }
    return _imageArr;
}

@end
