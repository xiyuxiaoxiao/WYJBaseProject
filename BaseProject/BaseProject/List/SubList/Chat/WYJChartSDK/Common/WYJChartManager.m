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
 ws://192.168.1.103:3000
 ws://echo.websocket.org   websocket官网提供的
 ws://39.96.27.144:30005 新提供的
 */
+ (void)connectWithURL:(NSString *)url {
    [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:@"ws://localhost:3000"];
}

/*
 pk:用表标记message的id
 */
+ (void)sendMessage:(WYJChartMessage *)message {
    NSString *messageId = [NSString stringWithFormat:@"%d",message.pk];
    NSDictionary *dict = @{@"resMsg": @"1", // 表示对发送的消息的回调的格式
                           @"messageId":messageId};
    NSString *str = [NSDictionary dictionaryToJson:dict];
    [[SocketRocketUtility instance] sendData: str];
}
+ (void)closePort {
    [[SocketRocketUtility instance] SRWebSocketClose];
}

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
        WYJChartMessage *message = [WYJChartCellTool creatMessageText:dict[@"message"]];
        message.fromUserId = dict[@"userId"];
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
