//
//  ChartDatabaseManager.h
//  BaseProject
//
//  Created by ZSXJ on 2018/5/31.
//  Copyright © 2018年 WYJ. All rights reserved.
//

// 参考[简书](http://www.jianshu.com/p/286102d6db28)

#import <Foundation/Foundation.h>
@class MessageList;
@protocol ChartDatabaseManagerDelegate
// 数据库 消息变更 对于通讯列表最后一条消息 需要更新 可以自定义一些参数
- (void)addressListUpdate;
- (void)messageNew:(MessageList *)message; // 消息新增

- (void)receiveMessageNew:(NSObject *)message; //新增消息
- (void)newAddress:(NSObject *)user; // 新增一个联系人
@end

@interface ChartDatabaseManager : NSObject

+ (instancetype)share;

- (void)addDelegate:(id<ChartDatabaseManagerDelegate>)delegate;
- (void)deleteDelegate:(id<ChartDatabaseManagerDelegate>)delegate;

- (void)addressListUpdata;
- (void)messageNew:(MessageList *)message; // 消息新增;

// 新版的消息 WYJChartMessage
- (void)receiveMessageNew:(NSObject *)message;
- (void)newAddress:(NSObject *)user;

@end
