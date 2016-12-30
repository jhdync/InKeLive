//
//  CameraViewController.h
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetUtils.h"
#import "AnchorView.h"

@interface CameraViewController : UIViewController

@property (nonatomic, strong) NSString *livingName;

@property (nonatomic, assign) BOOL isAudioLiving;

//拉流地址
@property (nonatomic,copy)NSString *adressStr;

//消息弹幕
@property (nonatomic,strong)UIButton *inforButton;

@property (nonatomic,strong)AnchorView *anchorView;

@end
