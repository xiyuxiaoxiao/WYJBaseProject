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

+ (instancetype)manager {
    static WYJChartManager *chartManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chartManager = [[WYJChartManager alloc] init];
        chartManager.isBackGround = NO;
        
        [AppDelegate loadExchange];
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
