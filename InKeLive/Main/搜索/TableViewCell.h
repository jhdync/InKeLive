//
//  TableViewCell.h
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@class Live_Nodes;
@interface TableViewCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewF;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewS;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewT;
@property (weak, nonatomic) IBOutlet UILabel *LabelF;
@property (weak, nonatomic) IBOutlet UILabel *LabelS;
@property (weak, nonatomic) IBOutlet UILabel *LabelT;

- (void)updataCell:(Live_Nodes *)model;

@end
