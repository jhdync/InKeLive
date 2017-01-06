//
//  RecommendCell.h
//  InKeLive
//
//  Created by 1 on 2017/1/5.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@class User;
@interface RecommendCell : UITableViewCell

//头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

//昵称、等级
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTextLabel;

//关注
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic,copy)void (^payAttenBlock)(NSInteger row);

- (void)updataCell:(User *)model relation:(NSString *)relation;
@end
