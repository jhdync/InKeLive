//
//  HomeViewController.h
//  InKeLive
//
//  Created by 1 on 2016/12/26.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopTitleView.h"

@interface HomeViewController : UIViewController

@property (nonatomic,strong)TopTitleView *titleView;

@property (nonatomic,strong)UIScrollView *homeScrollView;

@end
