//
//  AnchorView.h
//  InKeLive
//
//  Created by 1 on 2016/12/20.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnchorView : UIView

//头像
@property (nonatomic,strong)UIImageView *iconImageView;

//直播
@property (nonatomic,strong)UILabel *liveLabel;

//在线人数
@property (nonatomic,strong)UILabel *lineLabel;

//连麦按钮
@property (nonatomic,strong)UIButton *payButton;

@property (nonatomic, copy) void (^anchorClick)();

@end
