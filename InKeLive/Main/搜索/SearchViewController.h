//
//  SearchViewController.h
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendView.h"
#import "TableViewCell.h"
#import "RecommendCell.h"
#import "SearchView.h"

@interface SearchViewController : UIViewController{
    RecommendView *_recommendView;
}

@property (nonatomic,strong)UITableView *recommdTableView;

//标题
@property (nonatomic,strong)NSMutableArray *sectionTitleArr;

//
@property (nonatomic,strong)NSMutableArray *dataArr;

//今日推荐数组
@property (nonatomic,strong)NSMutableArray *recommdArr;

@property (nonatomic,strong)SearchView *searchView;

@end
