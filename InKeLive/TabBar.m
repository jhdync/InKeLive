//
//  TabBar.m
//  51AutoPersonNew
//
//  Created by auto on 16/3/31.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "TabBar.h"


@interface TabBar ()

@property (strong, nonatomic) UIButton *cameraButton;

@end

@implementation TabBar

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cameraButton setBackgroundImage:[UIImage imageNamed:@"tab_launch"] forState:UIControlStateNormal];
        [cameraButton addTarget:self action:@selector(cameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
        cameraButton.size = cameraButton.currentBackgroundImage.size;
        
        self.cameraButton = cameraButton;
        [self addSubview:cameraButton];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.cameraButton.centerY = self.height * 0.5;
    
    CGFloat tabBarItemWidth = self.width / 3;
    self.cameraButton.centerX= self.width * 0.5;
    CGFloat tabBarItemIndex = 0;
    for (UIView *childItem in self.subviews) {
        if ([childItem isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            childItem.width = tabBarItemWidth;
            childItem.x = tabBarItemIndex*tabBarItemWidth;
            tabBarItemIndex ++;
            if (tabBarItemIndex == 1) {
                tabBarItemIndex ++;
            }
        }
    }
}

- (void)cameraButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraButtonClick:)]) {
        [self.delegate cameraButtonClick:self];
    }
}


@end
