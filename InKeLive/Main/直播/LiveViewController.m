//
//  LiveViewController.m
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//直播详情页（游客端）拉流

#import "LiveViewController.h"
#import "LiveViewController+GiftAnnimation.h"
#import "ASHUD.h"
#import "UMSocialUIManager.h"
#import "WXApi.h"
#import "UMSocialShareUIConfig.h"
#import "DMHeartFlyView.h"

@interface LiveViewController ()<RTMPCGuestRtmpDelegate,RTMPCGuestRtcDelegate,UIGestureRecognizerDelegate,KeyBoardInputViewDelegate,PresentViewDelegate>
//最上层的视图
@property (nonatomic,strong)UIView *topSideView;
//直播窗口
@property (nonatomic,strong)UIView *showView;
//占位图
@property (nonatomic,strong)UIImageView *backdropView;

//关闭直播
@property (nonatomic,strong)UIButton *closeButton;

//连麦视屏窗口数
@property (nonatomic,strong)NSMutableArray *remoteArray;

//分享平台
@property (nonatomic, nonnull,strong)NSMutableArray *platformArr;

@property (nonatomic,strong)NSString *adressStr;

@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, strong) NSString *userIcon;


@end

@implementation LiveViewController{
    bool use_cap_;
    UITapGestureRecognizer *tapGesture;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    
    //拉流
    //    [self getAdress];
    [self repareStartPlay];
    //RTC连麦
    [self prepareRtc];
}

//- (void)getAdress{
//    WEAKSELF;
//    [[NetUtil shead]getRTMPAddress:@"test001" withAppName:@"huilive" withType:2 withStreamId:@"123456" withSecretKey:nil withReturn:^(NSDictionary *dict, int code) {
//        if (dict && code == 200) {
//            weakSelf.adressStr = [dict objectForKey:@"url"];
//            [weakSelf repareStartPlay];
//            [weakSelf prepareRtc];
//        }
//    }];
//}

//游客端RTC连麦
- (void)prepareRtc{
    self.guestKit.rtc_delegate = self;
    
    NSString *strUrl = [NSString stringWithFormat:@"http://img2.inke.cn/MTQ4MTI4NTI4NTMxMyMzNjYjanBn.jpg"];
    
    NSDictionary *customDict = [NSDictionary dictionaryWithObjectsAndKeys:@"AnyRTC",@"nickName",strUrl,@"headUrl" ,nil];
    NSString *customStr = [self JSONTOString:customDict];
    
    //当andyrtcId为空，假数据，RTC连麦失败
    [self.guestKit JoinRTCLine:self.livingItem.andyrtcId andCustomID:@"游客A" andUserData:customStr];
}

- (NSString*)JSONTOString:(id)obj {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

#pragma RTMPCGuestRtcDelegate

/**
 游客加入RTC回调
 
 @param code 0成功
 @param strReason 原因
 */
- (void)OnRTCJoinLineResult:(int) code withReason:(NSString*)strReason{
    if (code != 0) {
        if (code == 101) {
            [ASHUD showHUDWithCompleteStyleInView:self.view content:@"主播还未开启直播" icon:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }
}


/**
 游客申请与主播连麦回调
 
 @param code 0成功
 */
- (void)OnRTCApplyLineResult:(int) code{
    if(code == 0) {
        if(!use_cap_) {
            use_cap_ = true;
            // 找一个view
            UIView *videoView = [self getVideoViewWithStrID:@"MEVIDEOVIEW"];
            UIButton *cButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cButton.frame = CGRectMake(CGRectGetWidth(videoView.frame)-30,10, 20, 20);
            [cButton addTarget:self action:@selector(cButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
            [videoView addSubview:cButton];
            
            [self.view addSubview:videoView];
            // 加一个tap
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCamera)];
            [videoView addGestureRecognizer:tap];
            // 参照点~
            [self.view insertSubview:videoView belowSubview:self.closeButton];
            [self.guestKit SetVideoCapturer:videoView andUseFront:YES];
        }
    }else{
        [ASHUD showHUDWithCompleteStyleInView:self.view content:@"主播拒绝了你的连麦请求" icon:nil];
    }
}




/**
 其他游客连麦主播的回调
 
 @param strLivePeerID 其他游客在RTMPC服务的ID
 @param strCustomID 其他游客在自己平台的用户ID
 @param strUserData 其他游客在自己平台的一些相关信息
 */
- (void)OnRTCOtherLineOpen:(NSString*)strLivePeerID withCustomID:(NSString*)strCustomID withUserData:(NSString*)strUserData{
    
}


/**
 得到其他游客关闭连麦的回调
 
 @param strLivePeerID 其他游客在RTMPC服务的ID
 */
- (void)OnRTCOtherLineClose:(NSString*)strLivePeerID{
    for (int i=0; i<self.remoteArray.count; i++) {
        NSDictionary *dict = [self.remoteArray objectAtIndex:i];
        if ([[dict.allKeys firstObject] isEqualToString:strLivePeerID]) {
            UIView *videoView = [dict objectForKey:strLivePeerID];
            [videoView removeFromSuperview];
            [self.remoteArray removeObjectAtIndex:i];
            [self layout:i];
            break;
        }
    }
}


/**
 游客挂断连麦的回调
 */
- (void)OnRTCHangupLine{
    // 主播挂断你的连线
    use_cap_ = NO;
    for (int i=0;i<self.remoteArray.count;i++) {
        NSDictionary *dict = [self.remoteArray objectAtIndex:i];
        if ([[dict.allKeys firstObject] isEqualToString:@"MEVIDEOVIEW"]) {
            UIView *videoView = [dict objectForKey:@"MEVIDEOVIEW"];
            [videoView removeFromSuperview];
            [self.remoteArray removeObjectAtIndex:i];
            [self layout:i];
            break;
        }
    }
    // 清空自己摄像头~
    [self.guestKit HangupRTCLine];
}


/**
 游客关闭RTC服务的回调
 
 @param code 0成功
 @param strReason 原因
 */
- (void)OnRTCLineLeave:(int) code withReason:(NSString*)strReason{
    // 主播离开了
    [ASHUD showHUDWithCompleteStyleInView:self.view content:@"主播关闭了直播" icon:nil];
    if (self.guestKit) {
        [self.guestKit clear];
        self.guestKit = nil;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });
}


/**
 游客得到主播同意其他游客连麦请求后的回调，用于显示其他游客视频窗口
 
 @param strLivePeerID 其他游客在RTMPC服务的ID
 */
- (void)OnRTCOpenVideoRender:(NSString*)strLivePeerID{
    NSLog(@"OnRTCOpenVideoRender:%@",strLivePeerID);
    UIView *video = [self getVideoViewWithStrID:strLivePeerID];
    [self.view addSubview:video];
    // 参照点~
    [self.view insertSubview:video belowSubview:self.closeButton];
    [self.guestKit SetRTCVideoRender:strLivePeerID andRender:video];
}


/**
 主播关闭连麦或其他
 */
- (void)OnRTCCloseVideoRender:(NSString*)strLivePeerID{
    for (int i=0; i<self.remoteArray.count; i++) {
        NSDictionary *dict = [self.remoteArray objectAtIndex:i];
        if ([[dict.allKeys firstObject] isEqualToString:strLivePeerID]) {
            UIView *videoView = [dict objectForKey:strLivePeerID];
            [videoView removeFromSuperview];
            [self.remoteArray removeObjectAtIndex:i];
            [self layout:i];
            break;
        }
    }
}



#pragma optional
//游客收到别人的消息的回调
- (void)OnRTCUserMessage:(NSString*)nsCustomId withCustomName:(NSString*)nsCustomName withCustomHeader:(NSString*)nsCustomHeader withContent:(NSString*)nsContent{
    // 发送普通消息
    MessageModel *model = [[MessageModel alloc] init];
    [model setModel:@"guestID" withName:self.nickName withIcon:@"游客头像" withType:CellNewChatMessageType withMessage:nsContent];
    [self.messageTableView sendMessage:model];
}

//游客收到别人的弹幕消息的回调
- (void)OnRTCUserBarrage:(NSString*)nsCustomId withCustomName:(NSString*)nsCustomName withCustomHeader:(NSString*)nsCustomHeader withContent:(NSString*)nsContent{
    if (self.danmuView) {
        DanmuItem *item = [[DanmuItem alloc] init];
        item.u_userID = nsCustomId;
        item.u_nickName = nsCustomName;
        item.thumUrl = nsCustomHeader;
        item.content = nsContent;
        [self.danmuView setModel:item];
    }
}

//在线人数变化的回调
- (void)OnRTCMemberListWillUpdate:(int)nTotalMember{
    @autoreleasepool {
        self.anchorView.lineLabel.text = [NSString stringWithFormat:@"在线观看人数:%d",nTotalMember];
    }
}

//游客收到人员进入或者离开直播间的回调
- (void)OnRTCMember:(NSString*)nsCustomId withUserData:(NSString*)nsUserData{
}

//游客收到人员变化结束的回调
- (void)OnRTCMemberListUpdateDone{
}

#pragma 创建连麦视屏窗口
- (UIView*)getVideoViewWithStrID:(NSString*)publishID {
    NSInteger num = self.remoteArray.count;
    CGFloat videoHeight = CGRectGetHeight(self.view.frame)/4;
    CGFloat videoWidth = videoHeight*3/4;
    
    UIView *pullView = [[UIView alloc] init];
    pullView.frame = CGRectMake(CGRectGetWidth(self.view.frame)-videoWidth, (3-num)*videoHeight, videoWidth, videoHeight);
    pullView.layer.borderColor = [UIColor grayColor].CGColor;
    pullView.layer.borderWidth = .5;
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:pullView,publishID, nil];
    [self.remoteArray addObject:dict];
    return pullView;
}


#pragma 创建UI
- (void)creatUI{
    [self.view addSubview:self.showView];
    [self.showView addSubview:self.backdropView];
    [self.view insertSubview:self.topSideView aboveSubview:self.showView];
    [self.view addSubview:self.closeButton];
    
    [self.view addSubview:self.anchorView];
    [self.topSideView addSubview:self.bottomTool];
    
    [self.topSideView addSubview:self.keyBoardView];
    [self.topSideView addSubview:self.messageTableView];
    [self.topSideView addSubview:self.presentView];
    
    [self.view addSubview:self.danmuView];
    
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-14);
        make.right.equalTo(self.view).offset(-10);
        make.width.height.equalTo(@40);
    }];
    
    [self registerForKeyboardNotifications];
    
    //送礼物
    WEAKSELF;
    [self.giftView setGiftClick:^(NSInteger tag) {
        [weakSelf chooseGift:tag + 100];
    }];
    //显示底部工具栏
    [self.giftView setGrayClick:^{
        [weakSelf bottomToolShow];
    }];
}

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self.view addGestureRecognizer:tapGesture];
}

// 键盘弹起
- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (self.keyBoardView) {
        self.keyBoardView.frame = CGRectMake(self.keyBoardView.frame.origin.x, CGRectGetMaxY(self.view.frame)-CGRectGetHeight(self.keyBoardView.frame)-keyboardRect.size.height, CGRectGetWidth(self.keyBoardView.frame), CGRectGetHeight(self.keyBoardView.frame));
    }
    
    if (self.messageTableView) {
        self.messageTableView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame)-CGRectGetHeight(self.keyBoardView.frame)-keyboardRect.size.height - CGRectGetHeight(self.messageTableView.frame) -10, CGRectGetWidth(self.messageTableView.frame), 120);
    }
    if (self.danmuView) {
        self.danmuView.frame = CGRectMake(self.danmuView.frame.origin.x, CGRectGetMinY(self.messageTableView.frame)-CGRectGetHeight(self.danmuView.frame), CGRectGetWidth(self.danmuView.frame), CGRectGetHeight(self.danmuView.frame));
    }
}
// 键盘隐藏
- (void)keyboardWasHidden:(NSNotification*)notification {
    if (self.keyBoardView) {
        self.keyBoardView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), self.view.bounds.size.width, 44);
    }
    if (self.messageTableView) {
        self.messageTableView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame)-180, CGRectGetWidth(self.view.frame)/3*2, 120);
    }
    if (self.danmuView) {
        self.danmuView.frame = CGRectMake(self.danmuView.frame.origin.x, CGRectGetMinY(self.messageTableView.frame)-CGRectGetHeight(self.danmuView.frame), CGRectGetWidth(self.danmuView.frame), CGRectGetHeight(self.danmuView.frame));
    }
}
- (void)tapEvent:(UITapGestureRecognizer*)recognizer {
    DMHeartFlyView* heart = [[DMHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, 46, 46)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(SCREEN_WIDTH - 40, self.view.bounds.size.height - 90);
    heart.center = fountainSource;
    [heart animateInView:self.view];
    
    
    CGPoint point = [recognizer locationInView:self.view];
    CGRect rect = [self.view convertRect:self.keyBoardView.frame toView:self.view];
    if (CGRectContainsPoint(rect, point)) {
        
    }else{
        if (self.keyBoardView.isEdit) {
            [self.keyBoardView editEndTextField];
        }
    }
    
}

- (void)repareStartPlay{
    //初始化
    self.guestKit = [[RTMPCGuestKit alloc]initWithDelegate:self withCaptureDevicePosition:RTMPC_SCRN_Portrait withLivingAudioOnly:NO withAudioDetect:NO];
    
    //只支持rtmp流
    if (!self.livingItem) {
        //假数据  香港卫视rtmp://live.hkstv.hk.lxdns.com/live/hks  耀才财经台：rtmp://202.69.69.180:443/webcast/bshdlive-pc
        [self.guestKit StartRtmpPlay:@"rtmp://202.69.69.180:443/webcast/bshdlive-pc" andRender:self.showView];
    } else{
        //如果有两部手机运行，且创建项目，可实现实时推流、拉流
        [self.guestKit StartRtmpPlay:self.livingItem.rtmp_url andRender:self.showView];
    }
    
    //    [self.guestKit StartRtmpPlay:self.adressStr andRender:self.showView];
    //    [self.guestKit setVideoContentMode:VideoShowModeScaleAspectFill];
    
}

#pragma RTMPCGuestRtmpDelegate
// rtmp 连接成功
- (void)OnRtmplayerOK
{
    NSLog(@"OnRtmplayerOK");
}

// rtmp 播放状态  cacheTime:当前延迟时间 curBitrate:当期码率大小
- (void)OnRtmplayerStatus:(int) cacheTime withBitrate:(int) curBitrate
{
    
}

//rtmp开始播放
- (void)OnRtmplayerStart
{
    //self.backdropView.hidden = YES;
    NSLog(@"OnRtmplayerStart");
}

// rtmp 播放器缓存时间
- (void)OnRtmplayerCache:(int) time
{
    NSLog(@"OnRtmplayerCache:%d",time);
}

// rtmp 播放器关闭
- (void)OnRtmplayerClosed:(int) errcode
{
    
}

- (BottomView *)bottomTool{
    
    if (_bottomTool == nil) {
        _bottomTool = [[BottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 64)];
        WEAKSELF;
        [_bottomTool setButtonClick:^(NSInteger tag) {
            switch (tag) {
                case 100:
                    //发送消息/弹幕
                {
                    if (weakSelf.keyBoardView) {
                        [weakSelf.keyBoardView editBeginTextField];
                    }
                }
                    break;
                case 101:
                    //礼物
                {
                    [weakSelf bottomToolPosition];
                }
                    
                    break;
                case 102:
                    //显示分享面板
                {
                    [UMSocialUIManager setPreDefinePlatforms:weakSelf.platformArr];
                    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
                    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;
                    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                        // 根据platformType调用相关平台进行分享
                        [weakSelf shareTextToPlatformType:platformType];
                    }];
                }
                    
                    break;
                default:
                    break;
            }
        }];
    }
    return _bottomTool;
}

- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = @"https://www.anyrtc.io/";
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

#pragma KeyBoardInputViewDelegate
- (void)keyBoardSendMessage:(NSString*)message withDanmu:(BOOL)danmu{
    if (message.length == 0) {
        return;
    }
    if (danmu) {
        // 发送弹幕消息
        if (self.danmuView) {
            DanmuItem *item = [[DanmuItem alloc] init];
            item.u_userID = @"three id";
            item.u_nickName = self.nickName;
            item.thumUrl = self.userIcon;
            item.content = message;
            [self.danmuView setModel:item];
            if (self.guestKit) {
                [self.guestKit SendBarrage:self.nickName andCustomHeader:self.userIcon andContent:message];
            }
        }
    }else{
        // 发送普通消息
        MessageModel *model = [[MessageModel alloc] init];
        [model setModel:@"guestID" withName:self.nickName withIcon:self.userIcon withType:CellNewChatMessageType withMessage:message];
        [self.messageTableView sendMessage:model];
        
        if (self.guestKit) {
            [self.guestKit SendUserMsg:self.nickName andCustomHeader:self.userIcon andContent:message];
        }
        
    }
}
#pragma <#arguments#>
/**
 *  返回自定义cell样式
 */
- (PresentViewCell *)presentView:(PresentView *)presentView cellOfRow:(NSInteger)row{
    return [[GIftCell alloc] initWithRow:row];
}
/**
 *  礼物动画即将展示的时调用，根据礼物消息类型为自定义的cell设置对应的模型数据用于展示
 *
 *  @param cell        用来展示动画的cell
 *  @param model       礼物模型
 */
- (void)presentView:(PresentView *)presentView
         configCell:(PresentViewCell *)cell
              model:(id<PresentModelAble>)model{
    GIftCell *giftcell = (GIftCell *)cell;
    giftcell.presentmodel = model;
}

/**
 *  cell点击事件
 */
- (void)presentView:(PresentView *)presentView didSelectedCellOfRowAtIndex:(NSUInteger)index{
    //GIftCell *cell = [presentView cellForRowAtIndex:index];
}

/**
 一组连乘动画执行完成回调
 */
- (void)presentView:(PresentView *)presentView animationCompleted:(NSInteger)shakeNumber model:(id<PresentModelAble>)model{
    
}

#pragma 点击事件
//隐藏工具栏
- (void)bottomToolPosition{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.duration = 0.3f;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT + 32)];
    [self.bottomTool.layer addAnimation:anim forKey:@"positionHide"];
    [self performSelector:@selector(popShowGiftView) withObject:nil afterDelay:0.5];
}

//显示工具栏
- (void)bottomToolShow{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.duration = 0.5f;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 32)];
    [self.bottomTool.layer addAnimation:anim forKey:@"positionShow"];
}

//显示送礼物界面
- (void)popShowGiftView{
    [self.giftView popShow];
}

//关闭直播
- (void)closeRoom{
    //有连麦窗口则不能直接关闭
    if (self.remoteArray.count > 0) {
        return;
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)changeCamera {
    if (self.guestKit) {
        [self.guestKit SwitchCamera];
    }
}

- (void)cButtonEvent:(UIButton*)sender {
    
    if (self.guestKit) {
        [self.guestKit HangupRTCLine];
        use_cap_ = NO;
        for (int i=0;i<self.remoteArray.count;i++) {
            NSDictionary *dict = [self.remoteArray objectAtIndex:i];
            if ([[dict.allKeys firstObject] isEqualToString:@"MEVIDEOVIEW"]) {
                UIView *videoView = [dict objectForKey:@"MEVIDEOVIEW"];
                [videoView removeFromSuperview];
                [self.remoteArray removeObjectAtIndex:i];
                [self layout:i];
                break;
            }
        }
    }
}

- (void)layout:(int)index {
    switch (index) {
        case 0:
            for (int i=0; i<self.remoteArray.count; i++) {
                NSDictionary *dict = [self.remoteArray objectAtIndex:i];
                UIView *videoView = [dict.allValues firstObject];
                videoView.frame = CGRectMake(videoView.frame.origin.x, CGRectGetHeight(self.view.frame)-(i+1)*videoView.frame.size.height, videoView.frame.size.width, videoView.frame.size.height);
            }
            break;
        case 1:
            if (self.remoteArray.count==2) {
                NSDictionary *dict = [self.remoteArray objectAtIndex:1];
                UIView *videoView = [dict.allValues firstObject];
                videoView.frame = CGRectMake(videoView.frame.origin.x, CGRectGetHeight(self.view.frame)-(2)*videoView.frame.size.height, videoView.frame.size.width, videoView.frame.size.height);
            }
            break;
        case 2:
            
            break;
            
        default:
            break;
    }
}

#pragma 加载
- (PresentView *)presentView{
    if (!_presentView) {
        _presentView  = [[PresentView alloc]init];
        _presentView.frame = CGRectMake(0,150, CGRectGetWidth(self.view.frame)/2, 120);
        _presentView.delegate = self;
        _presentView.backgroundColor = [UIColor clearColor];
    }
    return _presentView;
}

- (NSMutableArray *)giftArr{
    if (!_giftArr) {
        _giftArr = [NSMutableArray array];
        PresentModel *model0 = [PresentModel modelWithSender:@"游客A" giftName:@"鲜花" icon:@"" giftImageName:@"live_emoji_meigui"];
        [_giftArr addObject:model0];
        
        PresentModel *model1 = [PresentModel modelWithSender:@"游客B" giftName:@"泰迪熊" icon:@"" giftImageName:@"bear0@2x"];
        [_giftArr addObject:model1];
        
        PresentModel *model2 = [PresentModel modelWithSender:@"游客C" giftName:@"游轮" icon:@"" giftImageName:@"ship_body"];
        [_giftArr addObject:model2];
        
    }
    return _giftArr;
}

- (UIView *)showView{
    if (_showView == nil) {
        _showView = [[UIView alloc]init];
        _showView.frame = self.view.bounds;
        _showView.backgroundColor = [UIColor whiteColor];
    }
    return _showView;
}

//背景图
- (UIImageView *)backdropView{
    if (_backdropView == nil) {
        _backdropView = [[UIImageView alloc]init];
        _backdropView.frame = self.view.bounds;
        NSString *urlStr = [NSString stringWithFormat:@"http://img2.inke.cn/MTQ4MTcwOTgyNTIyNCM3OTcjanBn.jpg"];
        [_backdropView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"swipe_bg"]];
        UIVisualEffect *effcet = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effcet];
        visualEffectView.frame = _backdropView.bounds;
        [_backdropView addSubview:visualEffectView];
    }
    return _backdropView;
}

//最上层视图
- (UIView *)topSideView{
    if (_topSideView == nil) {
        _topSideView = [[UIView alloc]initWithFrame:self.view.bounds];
        _topSideView.backgroundColor = [UIColor clearColor];
    }
    return _topSideView;
}

//关闭按钮
- (UIButton *)closeButton{
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"mg_room_btn_guan_h"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeRoom) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

//弹出来礼物视图
- (SendGiftView *)giftView{
    if (!_giftView) {
        _giftView = [[SendGiftView alloc]initWithFrame:self.view.bounds];
    }
    return _giftView;
}

//连麦窗口数
- (NSMutableArray *)remoteArray{
    if (!_remoteArray) {
        _remoteArray = [[NSMutableArray alloc]initWithCapacity:3];
    }
    return _remoteArray;
}

//分享平台
- (NSMutableArray *)platformArr{
    if(!_platformArr){
        _platformArr = [[NSMutableArray alloc]init];
        if([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
            [_platformArr addObject:@(UMSocialPlatformType_WechatSession)];
            [_platformArr addObject:@(UMSocialPlatformType_WechatTimeLine)];
            [_platformArr addObject:@(UMSocialPlatformType_WechatFavorite)];
        }
    }
    return _platformArr;
}

- (KeyBoardInputView*)keyBoardView {
    if (!_keyBoardView) {
        _keyBoardView = [[KeyBoardInputView alloc] initWityStyle:KeyBoardInputViewTypeNomal];
        _keyBoardView.backgroundColor = [UIColor clearColor];
        _keyBoardView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), self.view.bounds.size.width, 44);
        _keyBoardView.delegate = self;
    }
    return _keyBoardView;
}

- (MessageTableView*)messageTableView {
    if (!_messageTableView) {
        _messageTableView = [[MessageTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-180, CGRectGetWidth(self.view.frame)/3*2, 120)];
    }
    return _messageTableView;
}

- (DanmuLaunchView*)danmuView {
    if (!_danmuView) {
        _danmuView = [[DanmuLaunchView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.messageTableView.frame)-(ItemHeight*3+ItemSpace*2), self.view.frame.size.width, ItemHeight*3+ItemSpace*2)];
    }
    return _danmuView;
}

- (AnchorView *)anchorView{
    if (!_anchorView) {
        _anchorView = [[AnchorView alloc]initWithFrame:CGRectMake(10, 30, 150, 36)];
        WEAKSELF;
        [_anchorView setAnchorClick:^{
            [weakSelf.guestKit ApplyRTCLine:nil];
        }];
    }
    return _anchorView;
}

- (NSString *)nickName{
    if (!_nickName) {
        _nickName = @"游客A";
    }
    return _nickName;
}

- (NSString *)userIcon{
    if (!_userIcon) {
        _userIcon = [NSString stringWithFormat:@"http://img2.inke.cn/MTQ4MTg4ODIzMjcxMCM4MDIjanBn.jpg"];
    }
    return _userIcon;
}


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)dealloc{
    self.guestKit.rtc_delegate = nil;
    self.keyBoardView.delegate = nil;
    self.presentView.delegate = nil;
}

@end
