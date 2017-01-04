//
//  LiveViewController.h
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomView.h"
#import "LivingItem.h"
#import "KeyBoardInputView.h"
#import "MessageTableView.h"
#import "DanmuLaunchView.h"
#import "DanmuItemView.h"
#import "AnchorView.h"
#import "PresentView.h"
#import "GIftCell.h"
#import "PresentModel.h"
#import "SendGiftView.h"

@interface LiveViewController : UIViewController

@property (nonatomic, strong) RTMPCGuestKit *guestKit;

//底部工具栏
@property (nonatomic ,strong)BottomView *bottomTool;

   
@property (nonatomic, strong)LivingItem *livingItem;

//顶部区域
@property (nonatomic,strong)AnchorView *anchorView;

//显示连击动画区域
@property (nonatomic,strong)PresentView *presentView;

//连击样式视图
@property (nonatomic,strong)GIftCell *giftCell;

//礼物数组
@property (nonatomic,strong)NSMutableArray *giftArr;

//礼物栏
@property (nonatomic, strong)SendGiftView *giftView;

//聊天输入框
@property (nonatomic, strong) KeyBoardInputView *keyBoardView;

// 聊天面板
@property (nonatomic, strong) MessageTableView *messageTableView;

@property (nonatomic, strong) DanmuLaunchView *danmuView;

//现实动画
@property(nonatomic ,strong)UIDynamicAnimator * dynamicAnimator;
//现实行为
@property(nonatomic ,strong)UIDynamicItemBehavior * dynamicItemBehavior;
//重力行为
@property(nonatomic ,strong)UIGravityBehavior * gravityBehavior;
//碰撞行为
@property(nonatomic ,strong)UICollisionBehavior * collisionBehavior;

@end
