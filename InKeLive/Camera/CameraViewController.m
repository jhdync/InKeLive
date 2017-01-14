//
//  CameraViewController.m
//  InKeLive
//
//  Created by 1 on 2016/12/12.
//  Copyright © 2016年 jh. All rights reserved.
//主播端

#import "CameraViewController.h"
#import "ASHUD.h"
#import "WXApi.h"
#import "UMSocialShareUIConfig.h"
#import "UMSocialUIManager.h"
#import "KeyBoardInputView.h"
#import "MessageTableView.h"
#import "DanmuLaunchView.h"
#import "DanmuItemView.h"


@interface CameraViewController ()<RTMPCHosterRtmpDelegate,RTMPCHosterRtcDelegate,UIAlertViewDelegate,KeyBoardInputViewDelegate>{
    UITapGestureRecognizer *tapGesture;
    UIAlertView *alertView;
    //跳过时间
    NSInteger _timeOut;
}

@property (nonatomic,strong)RTMPCHosterKit *hosterKit;
//随机12字符
@property (nonatomic, strong) NSString *randomStr;
//推流地址
@property (nonatomic, strong) NSString *rtmpUrl;

@property (nonatomic, strong) NSString *hlsUrl;

//显示rtmp状态
@property (nonatomic, strong) UILabel *stateRTMPLabel;

//显示rtc状态
@property (nonatomic, strong) UILabel *stateRTCLabel;
//前置/后置
@property (nonatomic, strong) UIButton *cameraButton;
//美颜
@property (nonatomic, strong) UIButton *beautyButton;
//关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
//开始直播
@property (nonatomic, strong)UIButton *startButton;

@property (nonatomic, strong)NSString *requestId;

//连麦窗口数
@property (nonatomic, strong) NSMutableArray *remoteArray;

//倒计时
@property (nonatomic, strong)UIButton *skipButton;

// 聊天输入框
@property (nonatomic, strong) KeyBoardInputView *keyBoardView;

// 聊天面板
@property (nonatomic, strong) MessageTableView *messageTableView;

@property (nonatomic, strong) DanmuLaunchView *danmuView;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *userIcon;

//定时器
@property (nonatomic , strong)NSTimer *timer;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _timeOut = 3;
    [self creatUI];
    
    [self prepareStream];
}

- (void)creatUI{
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.stateRTCLabel];
    [self.view addSubview:self.stateRTMPLabel];
    [self.view addSubview:self.cameraButton];
    [self.view addSubview:self.beautyButton];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.inforButton];
    [self.view addSubview:self.keyBoardView];
    [self.view addSubview:self.messageTableView];
    [self.view addSubview:self.danmuView];
    [self.view addSubview:self.anchorView];
    [self registerForKeyboardNotifications];
}

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self.view addGestureRecognizer:tapGesture];
}

//rtc连麦
- (void)prepareRtc{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"hostID",@"hosterId",self.rtmpUrl,@"rtmp_url",self.hlsUrl,@"hls_url",self.livingName?self.livingName:[self getTopName],@"topic",self.randomStr,@"anyrtcId",[NSNumber numberWithBool:_isAudioLiving],@"isAudioOnly", nil];
    NSString *jsonString = [self JSONTOString:dict];
    //rtc的代理
    self.hosterKit.rtc_delegate = self;
    //打开RTC连麦功能
    [self.hosterKit OpenRTCLine:self.randomStr andCustomID:@"主播端" andUserData:jsonString andRtcArea:@"CN"];
}

#pragma RTMPCHosterRtcDelegate

/**
 RTC连接结果的回调
 
 @param code 0成功
 @param strReason 原因
 */
- (void)OnRTCOpenLineResult:(int) code withReason:(NSString*)strReason{
    ATLog(@"RTC连接结果:%d--%@",code,strReason);
    self.stateRTCLabel.text = [self getErrorInfoForRtc:code];
}


/**
 主播收到游客连麦申请
 
 @param strLivePeerID 游客在RTMPC服务的ID
 @param strCustomID 游客在自己平台的用户ID
 @param strUserData 游客在自己平台的一些相关信息
 */
- (void)OnRTCApplyToLine:(NSString*)strLivePeerID withCustomID:(NSString*)strCustomID withUserData:(NSString*)strUserData{
    if (self.requestId != nil) {
        [self.hosterKit HangupRTCLine:self.requestId];
    }
    self.requestId = strLivePeerID;
    alertView = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@请求连麦",strCustomID] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"接受", nil];
    [alertView show];
}


/**
 主播收到游客挂断连麦
 
 @param strLivePeerID 游客在RTMP服务ID
 */
- (void)OnRTCCancelLine:(NSString*)strLivePeerID{
    if ([self.requestId isEqualToString:strLivePeerID]) {
        if (alertView) {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            self.requestId = nil;
        }
        [ASHUD showHUDWithCompleteStyleInView:self.view content:@"对方取消了连线" icon:nil ];
        return;
    }
    // 游客自己挂断
    BOOL find = NO;
    for (int i=0; i<self.remoteArray.count; i++) {
        NSDictionary *dict = [self.remoteArray objectAtIndex:i];
        NSArray *keyArray = dict.allKeys;
        for (NSString *peerID in keyArray) {
            if ([peerID isEqualToString:strLivePeerID]) {
                UIView *videoView = [dict objectForKey:strLivePeerID];
                [videoView removeFromSuperview];
                [self.remoteArray removeObjectAtIndex:i];
                [self layout:i];
                find = YES;
                break;
            }
        }
        if (find) {
            break;
        }
    }
}

// 主播主动挂断游客的回调
- (void)OnRTCHangupLine:(NSString*)strLivePeerID {
    NSLog(@"OnRTCHangupLine:%@",strLivePeerID);
    // 游客自己挂断
    for (int i=0; i<self.remoteArray.count; i++) {
        NSDictionary *dict = [self.remoteArray objectAtIndex:i];
        if ([[dict objectForKey:@"PeerID"] isEqualToString:strLivePeerID]) {
            UIView *videoView = [dict objectForKey:@"View"];
            [videoView removeFromSuperview];
            [self.remoteArray removeObjectAtIndex:i];
            [self layout:i];
            break;
        }
    }
}


/**
 RTC关闭回调
 
 @param code 0成功
 @param strReason 原因
 */
- (void)OnRTCLineClosed:(int) code withReason:(NSString*)strReason{
    if (code == 207) {
        [ASHUD showHUDWithCompleteStyleInView:self.view content:@"测试账号限制三分钟" icon:nil];
    }
    
    if (self.hosterKit) {
        [self.hosterKit clear];
        self.hosterKit = nil;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });
}

/**
 主播同意连麦，显示对方窗口
 
 @param strLivePeerID RTMP服务ID
 */
- (void)OnRTCOpenVideoRender:(NSString*)strLivePeerID{
    UIView *videoView = [self getVideoViewWithStrID:strLivePeerID];
    [self.view addSubview:videoView];
    // 参照点~
    [self.view insertSubview:videoView belowSubview:self.closeButton];
    
    [self.hosterKit SetRTCVideoRender:strLivePeerID andRender:videoView];
}


/**
 主播关闭连麦或其它
 @param strLivePeerID RTMP服务ID
 */
- (void)OnRTCCloseVideoRender:(NSString*)strLivePeerID{
    for (int i=0; i<self.remoteArray.count; i++) {
        NSDictionary *dict = [self.remoteArray objectAtIndex:i];
        if ([[dict objectForKey:@"PeerID"] isEqualToString:strLivePeerID]) {
            UIView *videoView = [dict objectForKey:@"View"];
            [videoView removeFromSuperview];
            [self.remoteArray removeObjectAtIndex:i];
            [self layout:i];
            break;
        }
    }
}

// 普通消息
- (void)OnRTCUserMessage:(NSString *)nsCustomId withCustomName:(NSString *)nsCustomName withCustomHeader:(NSString *)nsCustomHeader withContent:(NSString *)nsContent {
    // 发送普通消息
    MessageModel *model = [[MessageModel alloc] init];
    [model setModel:nsCustomId withName:nsCustomName withIcon:@"游客头像" withType:CellNewChatMessageType withMessage:nsContent];
    [self.messageTableView sendMessage:model];
}
// 弹幕
- (void)OnRTCUserBarrage:(NSString *)nsCustomId withCustomName:(NSString *)nsCustomName withCustomHeader:(NSString *)nsCustomHeader withContent:(NSString *)nsContent {
    if (self.danmuView) {
        DanmuItem *item = [[DanmuItem alloc] init];
        item.u_userID = nsCustomId;
        item.u_nickName = nsCustomName;
        item.thumUrl = nsCustomHeader;
        item.content = nsContent;
        [self.danmuView setModel:item];
    }
}

// 在线人数
- (void)OnRTCMemberListWillUpdate:(int)nTotalMember {
    
    @autoreleasepool {
        self.anchorView.lineLabel.text = [NSString stringWithFormat:@"在线观看人数:%d",nTotalMember];
    }
}

// 人员信息
- (void)OnRTCMember:(NSString*)nsCustomId withUserData:(NSString*)nsUserData {
}

//获取信息完成
- (void)OnRTCMemberListUpdateDone {
}

#pragma UIAlertViewDelegate 连麦请求
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (self.hosterKit && self.requestId) {
            BOOL isScuess = [self.hosterKit AcceptRTCLine:self.requestId];
            if (!isScuess) {
                [ASHUD showHUDWithCompleteStyleInView:self.view content:@"连麦人数已满" icon:nil];
                [self.hosterKit RejectRTCLine:self.requestId andBanToApply:YES];
            }
        }
    }else{
        if (self.hosterKit && self.requestId) {
            [self.hosterKit RejectRTCLine:self.requestId andBanToApply:YES];
        }
    }
    self.requestId = nil;
}


#pragma 推流
- (void)prepareStream{
    //初始化主播端  推流代理
    self.hosterKit = [[RTMPCHosterKit alloc]initWithDelegate:self withCaptureDevicePosition:RTMPC_SCRN_Portrait withLivingAudioOnly:NO];
    //推流模式
    [self.hosterKit SetNetAdjustMode:RTMP_NA_Fast];
    [self.hosterKit SetVideoCapturer:self.view andUseFront:YES];
    [self.hosterKit SetBeautyEnable:YES];
    //推流质量
    [self.hosterKit SetVideoMode:RTMPC_Video_SD];
}

#pragma mark -  RTMPCHosterRtmpDelegate  推流代理
// rtmp 连接成功
- (void)OnRtmpStreamOK {
    NSLog(@"OnRtmpStreamOK");
    self.stateRTMPLabel.text = @"连接RTMP服务成功";
}
// rtmp 重连次数
- (void)OnRtmpStreamReconnecting:(int) times {
    NSLog(@"OnRtmpStreamReconnecting:%d",times);
    self.stateRTMPLabel.text = [NSString stringWithFormat:@"第%d次重连中...",times];
}
// rtmp 重连次数
- (void)OnRtmpStreamStatus:(int) delayMs withNetBand:(int) netBand {
    NSLog(@"OnRtmpStreamStatus:%d withNetBand:%d",delayMs,netBand);
    self.stateRTMPLabel.text = [NSString stringWithFormat:@"RTMP延迟:%d 网络:%d",delayMs,netBand];
}
// rtmp 连接失败
- (void)OnRtmpStreamFailed:(int) code {
    NSLog(@"OnRtmpStreamFailed:%d",code);
    self.stateRTMPLabel.text = @"连接RTMP服务失败";
}
// rtmp 关闭
- (void)OnRtmpStreamClosed {
    NSLog(@"OnRtmpStreamClosed");
}


#pragma 点击事件
- (void)buttonClick:(UIButton *)sender{
    switch (sender.tag) {
        case 200:
            //美颜
            sender.selected = !sender.selected;
            if (sender.selected) {
                [self.hosterKit SetBeautyEnable:NO];
            }else{
                [self.hosterKit SetBeautyEnable:YES];
            }
            break;
        case 201:
            //相机切换
            if (self.hosterKit) {
                [self.hosterKit SwitchCamera];
            }
            break;
        case 202:
            //关闭
        {
            if (self.hosterKit) {
                [self.hosterKit StopRtmpStream];
                [self.hosterKit clear];
                self.hosterKit = nil;
            }
            [AutoCommon hideKeyBoard];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
            break;
        case 203:
            //开始直播
            if (self.hosterKit) {
                
                self.inforButton.hidden = NO;
                
                [self.startButton removeFromSuperview];
                
                
                [self.view addSubview:self.skipButton];
                
                //倒计时
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
                
                
                
                self.randomStr = [self randomString:12];
                //推流地址
                if (self.adressStr.length == 0) {
                    self.rtmpUrl = [NSString stringWithFormat:@"rtmp://live.hkstv.hk.lxdns.com/live/hks%@",self.randomStr];
                    
                    self.hlsUrl = [NSString stringWithFormat:@"rtmp://live.hkstv.hk.lxdns.com/live/hks%@.m3u8",self.randomStr];
                } else {
                    self.rtmpUrl = [NSString stringWithFormat:@"%@",self.adressStr];
                    
                    self.hlsUrl = [NSString stringWithFormat:@"%@.m3u8",self.adressStr];
                }
                
                //开始推流
                [self.hosterKit StartPushRtmpStream:self.rtmpUrl];
                //只有推流开始才能进行RTC连麦
                [self prepareRtc];
            }
            
        default:
            break;
    }
}

- (void)timeAction{
    NSString *imageStr = [NSString stringWithFormat:@"room_start_%zd",_timeOut];
    [self.skipButton setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    if (_timeOut == 0) {
        [self.skipButton removeFromSuperview];
    }
    --_timeOut;
}

// 获取错误信息
- (NSString*)getErrorInfoForRtc:(int)code {
    switch (code) {
        case AnyRTC_OK:
            return @"RTC:连接成功";
            break;
        case AnyRTC_UNKNOW:
            return @"RTC:未知错误";
            break;
        case AnyRTC_EXCEPTION:
            return @"RTC:SDK调用异常";
            break;
        case AnyRTC_NET_ERR:
            return @"RTC:网络错误";
            break;
        case AnyRTC_LIVE_ERR:
            return @"RTC:直播出错";
            break;
        case AnyRTC_BAD_REQ:
            return @"RTC:服务不支持的错误请求";
            break;
        case AnyRTC_AUTH_FAIL:
            return @"RTC:认证失败";
            break;
        case AnyRTC_NO_USER:
            return @"RTC:此开发者信息不存在";
            break;
        case AnyRTC_SQL_ERR:
            return @"RTC: 服务器内部数据库错误";
            break;
        case AnyRTC_ARREARS:
            return @"RTC:账号欠费";
            break;
        case AnyRTC_LOCKED:
            return @"RTC:账号被锁定";
            break;
        case AnyRTC_FORCE_EXIT:
            return @"RTC:强制离开";
            break;
        default:
            break;
    }
    return @"未知错误";
}

#pragma mark - KeyBoardInputViewDelegate
// 发送消息
- (void)keyBoardSendMessage:(NSString*)message withDanmu:(BOOL)danmu {
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
        }
        if (self.hosterKit) {
            [self.hosterKit SendBarrage:self.nickName andCustomHeader:self.userIcon andContent:message];
        }
    }else{
        
        // 发送普通消息
        MessageModel *model = [[MessageModel alloc] init];
        
        [model setModel:@"hostID" withName:self.nickName withIcon:self.userIcon withType:CellNewChatMessageType withMessage:message];
        [self.messageTableView sendMessage:model];
        
        if (self.hosterKit) {
            [self.hosterKit SendUserMsg:self.nickName andCustomHeader:self.userIcon andContent:message];
        }
        
    }
}


- (NSString*)randomString:(int)len {
    char* charSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    char* temp = malloc(len + 1);
    for (int i = 0; i < len; i++) {
        int randomPoz = (int) floor(arc4random() % strlen(charSet));
        temp[i] = charSet[randomPoz];
    }
    temp[len] = '\0';
    NSMutableString* randomString = [[NSMutableString alloc] initWithUTF8String:temp];
    free(temp);
    return randomString;
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


- (NSString*)getTopName {
    NSArray *array = @[@"测试Anyrtc",@"Anyrtc真心效果好",@"欢迎用Anyrtc",@"视频云提供商DYNC"];
    return [array objectAtIndex:(int)arc4random()%(array.count-1)];
}


- (UIView*)getVideoViewWithStrID:(NSString*)publishID {
    NSInteger num = self.remoteArray.count;
    CGFloat videoHeight = CGRectGetHeight(self.view.frame)/4;
    CGFloat videoWidth = videoHeight*3/4;
    
    UIView *pullView = [[UIView alloc] init];
    pullView.frame = CGRectMake(CGRectGetWidth(self.view.frame)-videoWidth, (3 - num)*videoHeight, videoWidth, videoHeight);
    pullView.layer.borderColor = [UIColor grayColor].CGColor;
    pullView.layer.borderWidth = .5;
    
    UIButton *cButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cButton.tag = 300+self.remoteArray.count;
    cButton.frame = CGRectMake(CGRectGetWidth(pullView.frame)-30,10, 20, 20);
    [cButton addTarget:self action:@selector(cButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
    [pullView addSubview:cButton];
    
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:pullView,@"View",publishID,@"PeerID", [NSString stringWithFormat:@"%lu",(300+self.remoteArray.count)],@"buttonTag",nil];
    [self.remoteArray addObject:dict];
    return pullView;
}

- (void)cButtonEvent:(UIButton*)button {
    
    for (NSDictionary *dict in self.remoteArray) {
        if ([[dict objectForKey:@"buttonTag"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)button.tag]]) {
            if (self.hosterKit) {
                NSLog(@"%@",[dict objectForKey:@"PeerID"]);
                [self.hosterKit HangupRTCLine:[dict objectForKey:@"PeerID"]];
                //[self OnRTCHangupLine:[dict objectForKey:@"PeerID"]];
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
                UIView *videoView = [dict valueForKey:@"View"];
                videoView.frame = CGRectMake(videoView.frame.origin.x, CGRectGetHeight(self.view.frame)-(i+1)*videoView.frame.size.height, videoView.frame.size.width, videoView.frame.size.height);
            }
            break;
        case 1:
            if (self.remoteArray.count==2) {
                NSDictionary *dict = [self.remoteArray objectAtIndex:1];
                UIView *videoView = [dict valueForKey:@"View"];
                videoView.frame = CGRectMake(videoView.frame.origin.x, CGRectGetHeight(self.view.frame)-(2)*videoView.frame.size.height, videoView.frame.size.width, videoView.frame.size.height);
            }
            break;
            
        default:
            break;
    }
}

- (void)inforButtonClick{
    if (self.keyBoardView) {
        [self.keyBoardView editBeginTextField];
    }
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
    CGPoint point = [recognizer locationInView:self.view];
    CGRect rect = [self.view convertRect:self.keyBoardView.frame toView:self.view];
    if (CGRectContainsPoint(rect, point)) {
        
    }else{
        if (self.keyBoardView.isEdit) {
            [self.keyBoardView editEndTextField];
        }
    }
    
}

#pragma 加载
- (UIButton *)inforButton{
    if (!_inforButton) {
        _inforButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _inforButton.frame = CGRectMake(20, SCREEN_HEIGHT - 50, 40, 40);
        [_inforButton setImage:[UIImage imageNamed:@"mg_room_btn_liao_h"] forState:UIControlStateNormal];
        [_inforButton addTarget:self action:@selector(inforButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _inforButton.hidden = YES;
    }
    return _inforButton;
}


- (UIButton*)closeButton {
    if(!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame)-50, 30,40,40);
        _closeButton.tag = 202;
    }
    return _closeButton;
}

- (UILabel*)stateRTCLabel {
    if (!_stateRTCLabel) {
        _stateRTCLabel = [UILabel new];
        _stateRTCLabel.textColor = [UIColor redColor];
        _stateRTCLabel.font = [UIFont systemFontOfSize:12];
        _stateRTCLabel.textAlignment = NSTextAlignmentRight;
        _stateRTCLabel.frame = CGRectMake(CGRectGetMaxX(self.view.frame)/2-10, CGRectGetMaxY(self.closeButton.frame), CGRectGetMaxX(self.view.frame)/2, 25);
        _stateRTCLabel.text = @"未连接";
    }
    return _stateRTCLabel;
}
- (UILabel*)stateRTMPLabel {
    if (!_stateRTMPLabel) {
        _stateRTMPLabel = [UILabel new];
        _stateRTMPLabel.textColor = [UIColor redColor];
        _stateRTMPLabel.font = [UIFont systemFontOfSize:12];
        _stateRTMPLabel.textAlignment = NSTextAlignmentRight;
        _stateRTMPLabel.frame = CGRectMake(CGRectGetMaxX(self.view.frame)/2-10, CGRectGetMaxY(self.stateRTCLabel.frame), CGRectGetMaxX(self.view.frame)/2, 25);
        _stateRTMPLabel.text = @"未连接";
    }
    return _stateRTMPLabel;
}

- (UIButton*)cameraButton {
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setImage:[UIImage imageNamed:@"camra_preview"] forState:UIControlStateNormal];
        [_cameraButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _cameraButton.frame = CGRectMake(CGRectGetMinX(self.closeButton.frame)-50, 30,40,40);
        _cameraButton.tag = 201;
    }
    return _cameraButton;
}
- (UIButton*)beautyButton {
    if (!_beautyButton) {
        _beautyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty"] forState:UIControlStateNormal];
        [_beautyButton setImage:[UIImage imageNamed:@"camra_beauty_close"] forState:UIControlStateSelected];
        [_beautyButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _beautyButton.tag = 200;
        [_beautyButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _beautyButton.frame = CGRectMake(CGRectGetMinX(self.cameraButton.frame)-50, 30,40,40);
    }
    return _beautyButton;
}

- (UIButton *)startButton{
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.backgroundColor = RGB(36, 216, 200);
        _startButton.layer.cornerRadius = 25;
        _startButton.clipsToBounds = YES;
        [_startButton setTitle:@"开始直播" forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _startButton.tag = 203;
        [_startButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _startButton.frame = CGRectMake(20, self.view.centerY, SCREEN_WIDTH - 40, 50);
    }
    return _startButton;
}

- (UIButton *)skipButton{
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.frame = CGRectMake(self.view.centerX - 50, self.view.centerY - 50, 100, 100);
        //[_skipButton setImage:[UIImage imageNamed:@"room_start_3"] forState:UIControlStateNormal];
        _skipButton.layer.cornerRadius = 50;
        _skipButton.layer.masksToBounds = YES;
        
        CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];//同上
        anima.toValue = [NSNumber numberWithFloat:0.0f];
        anima.duration = 1.0f;
        anima.autoreverses = NO;
        anima.repeatCount = 3;
        [_skipButton.layer addAnimation:anima forKey:@"scaleAnimation"];
    }
    return _skipButton;
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

- (NSString *)nickName{
    if (!_nickName) {
        _nickName = @"主播";
    }
    return _nickName;
}

- (NSString *)userIcon{
    if (!_userIcon) {
        _userIcon = [NSString stringWithFormat:@"http://img2.inke.cn/MTQ4MTQ5MzI5MzQxNCM2NTUjanBn.jpg"];
    }
    return _userIcon;
}

- (AnchorView *)anchorView{
    if (!_anchorView) {
        _anchorView = [[AnchorView alloc]initWithFrame:CGRectMake(10, 30, 150, 36)];
    }
    return _anchorView;
}

- (NSMutableArray *)remoteArray{
    if (!_remoteArray) {
        _remoteArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _remoteArray;
}


- (void)viewWillAppear:(BOOL)animated{
    //由小变大的圆形动画
    CGFloat radius = [UIScreen mainScreen].bounds.size.height;
    UIBezierPath *startMask =  [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.view.centerX, self.view.centerY, 0, 0)];
    UIBezierPath *endMask = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(self.view.centerX, self.view.centerY, 0, 0), -radius, -radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endMask.CGPath;
    maskLayer.backgroundColor = (__bridge CGColorRef)([UIColor whiteColor]);
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(startMask.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endMask.CGPath));
    maskLayerAnimation.duration = 0.8f;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    self.view.layer.mask = maskLayer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
