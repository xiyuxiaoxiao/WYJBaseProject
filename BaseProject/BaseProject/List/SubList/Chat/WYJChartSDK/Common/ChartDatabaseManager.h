//
//  ChartDatabaseManager.h
//  BaseProject
//
//  Created by ZSXJ on 2018/5/31.
//  Copyright © 2018年 WYJ. All rights reserved.
//

// 参考[简书](http://www.jianshu.com/p/286102d6db28)

#import <Foundation/Foundation.h>

@protocol ChartDatabaseManagerDelegate

- (void)receiveMessageNew:(NSObject *)message; //新增消息
- (void)newAddress:(NSObject *)user; // 新增一个联系人
- (void)updateConversation: (NSObject *)conversation; // 会话更新
@end

@interface ChartDatabaseManager : NSObject

+ (instancetype)share;

- (void)addDelegate:(id<ChartDatabaseManagerDelegate>)delegate;
- (void)deleteDelegate:(id<ChartDatabaseManagerDelegate>)delegate;


#pragma mark - 数据库更新后 需要通知 代理执行的相关方法
- (void)receiveMessageNew:(NSObject *)message;
- (void)newAddress:(NSObject *)user;
- (void)updateConversation: (NSObject *)conversation; // 会话更新

@end
