//
//  CameraView.h
//  InKeLive
//
//  Created by 1 on 2016/12/13.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraView : UIView

//直播
@property (nonatomic,strong)UIButton *liveButton;

//短视频
@property (nonatomic,strong)UIButton *videoButton;

@property (nonatomic,strong)UIButton *closeButton;

@property (nonatomic,strong)UIView *backView;


@property (nonatomic, copy) void (^buttonClick)(NSInteger tag);

- (void)popShow;

@end
