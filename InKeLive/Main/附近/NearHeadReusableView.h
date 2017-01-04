//
//  NearHeadReusableView.h
//  InKeLive
//
//  Created by 1 on 2016/12/26.
//  Copyright © 2017年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearHeadReusableView : UICollectionReusableView

//点击事件
@property (nonatomic,copy)void(^chooseCondition)();

@property (weak, nonatomic) IBOutlet UIButton *chooseButton;

@end
