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
    [WYJChartManager manager].isBackGround = NO;
}

@end
