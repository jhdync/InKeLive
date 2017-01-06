//
//  MoreViewController.h
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InKeCell.h"

@interface MoreViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

//关键字
@property (nonatomic,copy)NSString *keywordStr;

@property (nonatomic,strong)UITableView *moreTableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

@end
