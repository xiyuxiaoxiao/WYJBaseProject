//
//  WYJChartManager.m
//  BaseProject
//
//  Created by ZSXJ on 2019/3/22.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartManager.h"
#import "WYJChartDefine.h"
#import "WYJChartAddress.h"
#import "WYJChartCellTool.h"
#import "AppDelegate.h"
#import <objc/runtime.h>
#import "SocketRocketUtility.h"
#import "NSDictionary+Category.h"

// 主要是 需要添加相关的方法交换
@interface AppDelegate (WYJChartAppdelegate)
+ (void)loadExchange;
@end


#pragma mark - WYJChartManager

@interface WYJChartManager ()

@property (nonatomic, assign) BOOL isBackGround;
@property (nonatomic, strong) WYJChartAddress* currentChartUser; // 正在聊天的用户

@end


@implementation WYJChartManager

#pragma mark - socket
/*
 ws://localhost:3000
 ws://wyjsocket.herokuapp.com/:3000 自己创建的服务器
 
 ws://echo.websocket.org   websocket官网提供的
 ws://39.96.27.144:30005 新提供的
 */
+ (void)connectWithURL:(NSString *)url {
    NSString *userId = [WYJChartCellTool getCurrentUser].userId;
    NSString *urlString = [NSString stringWithFormat:@"ws://wyjsocket.herokuapp.com/:3000?userId=%@",userId];
    [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:urlString];
}

/*
 pk:用表标记message的id
 */
+ (void)sendMessage:(WYJChartMessage *)message {
    
    if ([SocketRocketUtility instance].socketReadyState != SR_OPEN) {
        [self socketCloseNote];
        return;
    }
    
    NSString *messageId = [NSString stringWithFormat:@"%d",message.pk];
    
    NSString *content = @"";
    if (message.type == 1) {
        content = message.content;
    }
    if (message.type == 2) {
        content = message.contentInfoModel.fileURL;
    }
    
    NSDictionary *dict = @{@"resMsg":       @"1", // 表示对发送的消息的回调的格式
                           @"messageId":    messageId,
                           @"fromUserId":   message.fromUserId,
                           @"toUserId":     message.toUserId,
                           @"contentType":  @(message.type), // 1:文本，2:图片
                           @"content":      content
                           };
    NSString *str = [NSDictionary dictionaryToJson:dict];
    // 先判断 能否发送 否则 不发送
    [[SocketRocketUtility instance] sendData: str];
}
+ (void)closePort {
    [[SocketRocketUtility instance] SRWebSocketClose];
    
    [WYJChartMessage updateSendStatusing];
}


+ (void)socketCloseNote {
    NSString *str = [NSString stringWithFormat:@"where sendStatus = %d",SendStatusSending];
    NSArray *array = [WYJChartMessage findByCriteria:str];
    for (WYJChartMessage *msg in array) {
        msg.sendStatus = SendStatusFaile;
        [msg update];
    }
    // 不使用这个 主要是因为 没有在 监听一组数据更新的时候 对UI的更新处理
//    [WYJChartMessage updateObjects:array];
}

// 需要对 比如发送消息的时候 如果当前刚好在发送消息 突然socketc中断  在重连后 则需要重新发送 无法得知之前发送的内容是什么 因此需要对数据库的发送中的状态 修改为-未成功，链接成功后 不需要重新发送  不然里面之前发送失败的 都会被需要去发送 所以就按照失败处理
+ (void)receiveSocketData: (NSNotification *)noti {
    NSString *msg = noti.object;
    if ([msg isKindOfClass:[NSString class]]) {
        if([msg isEqualToString:@"heart"]) {
            // 不打印
        }
        else {
            NSDictionary *dict = [NSDictionary dictionaryWithJsonString:msg];
            if (dict) {
                [self receiveMessage:dict];
            }
        }
    }
}
+ (void)receiveMessage: (NSDictionary *)dict {
    if (dict[@"resMsg"]) {
        // 发送给服务器消息 后的响应 来确定消息发送成功 
        NSString *messageId = dict[@"messageId"];
        WYJChartMessage *message = [WYJChartMessage findByPK:messageId.intValue];
        if (message) {
            message.sendStatus = SendStatusSuccess;
            [message update];
        }
    }else {
        // 接受新消息 需要判断本地是否有此联系人 没有则不能添加
        
        int type = [dict[@"contentType"] intValue];
        
        WYJChartMessage *message;
        if (type == MessageTypeText) {
            message = [WYJChartCellTool creatMessageText:dict[@"content"]];
        }
        else if (type == MessageTypeImage) {
            message = [WYJChartCellTool creatMessageWithImageDict:dict];
        }
        message.fromUserId = dict[@"fromUserId"];
        [WYJChartCellTool receiveMessage:message];
    }
}

#pragma mark - WYJChartManager

- (instancetype)init {
    if (self = [super init]) {
        self.isBackGround = NO;
    }
    
    return self;
}
// 通过类来加载 如果放在 init中 则会导致 子类继承的时候 多次添加
+ (void)initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveSocketData:) name:kWebSocketdidReceiveMessageNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketCloseNote) name:kWebSocketDidCloseNote object:nil];
}
+ (instancetype)manager {
    static WYJChartManager *chartManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chartManager = [[WYJChartManager alloc] init];
        
        [AppDelegate loadExchange];
        [self connectWithURL:nil];
    });
    
    return chartManager;
}

+ (void)setCurrentChartUser: (WYJChartAddress *)user {
    [WYJChartManager manager].currentChartUser = user;
    
    if (user != nil) {
        [WYJChartCellTool clearConversionUnReadWithUserId:user.userId];
    }
}

+ (BOOL)isReadMessageByUserId: (NSString *)userId {
    
    // 如果在后台 则应该设置未读
    if ([WYJChartManager manager].isBackGround) {
        return NO;
    }
    
    WYJChartAddress *user = [WYJChartManager manager].currentChartUser;
    if ([user.userId isEqualToString:userId]) {
        return YES;
    }
    return NO;
}


// 需要将 用户名传过来
+ (void)pushLocalNotificationWithMessage:(WYJChartMessage *)message fromUser:(WYJChartAddress *)user{
    
    // 实例化一个本地通知对象.
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    
//    notification.fireDate=[[NSDate new] dateByAddingTimeInterval:30]; // 触发时间 立即出发 无需设置
//    notification.repeatInterval = kCFCalendarUnitMinute;  //重复间隔设置 只能是 每分钟 每天 每月等设置
    notification.timeZone       = [NSTimeZone defaultTimeZone];
    notification.alertBody      = message.content;
    notification.alertTitle     = user.name;
    [notification setApplicationIconBadgeNumber:1];
    notification.soundName = UILocalNotificationDefaultSoundName;
    NSDictionary * userDict = [NSDictionary dictionaryWithObject:message.content forKey:@"message"];
    notification.userInfo = userDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
@end


// -------------------------------------------------------------------------------------------------
#pragma mark - WYJChartAppdelegate

@implementation AppDelegate (WYJChartAppdelegate)
+ (void)loadExchange {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(applicationDidEnterBackground:)),
                                   class_getInstanceMethod(self, @selector(wyjChartApplicationDidEnterBackground:)));
    
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(applicationWillEnterForeground:)), class_getInstanceMethod(self, @selector(wyjChartApplicationWillEnterForeground:)));
}

- (void)wyjChartApplicationDidEnterBackground: (UIApplication *)application {
    [self wyjChartApplicationDidEnterBackground:application];
    NSLog(@"进入后台了");
    [WYJChartManager manager].isBackGround = YES;
}

- (void)wyjChartApplicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"进入前台了");
    [WYJChartManager manager].isBackGround = NO;
}

@end
