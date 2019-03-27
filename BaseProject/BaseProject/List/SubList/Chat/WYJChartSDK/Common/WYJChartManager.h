//
//  WYJChartManager.h
//  BaseProject
//
//  Created by ZSXJ on 2019/3/22.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WYJChartAddress;
@class WYJChartMessage;

@interface WYJChartManager : NSObject

#pragma mark - socket

+ (void)connectWithURL:(NSString *)url;
+ (void)sendMessage:(WYJChartMessage *)message;
+ (void)closePort;


#pragma mark - WYJChartManager

+ (void)setCurrentChartUser: (WYJChartAddress *)user;
+ (BOOL)isReadMessageByUserId: (NSString *)userId;
+ (void)pushLocalNotificationWithMessage:(WYJChartMessage *)message fromUser:(WYJChartAddress *)user;

@end
