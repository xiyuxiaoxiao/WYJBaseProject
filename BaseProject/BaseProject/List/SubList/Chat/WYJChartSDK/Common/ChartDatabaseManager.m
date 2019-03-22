//
//  ChartDatabaseManager.m
//  BaseProject
//
//  Created by ZSXJ on 2018/5/31.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "ChartDatabaseManager.h"
#import "ChartDatabaseMultiDelegate.h"

@interface ChartDatabaseManager()
{
    ChartDatabaseMultiDelegate<ChartDatabaseManagerDelegate> *mulitDelegate;
}
@end

@implementation ChartDatabaseManager

+ (instancetype)share {
    static ChartDatabaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ChartDatabaseManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        mulitDelegate = (ChartDatabaseMultiDelegate<ChartDatabaseManagerDelegate> *)[[ChartDatabaseMultiDelegate alloc] init];
    }
    return self;
}

- (void)addDelegate:(id<ChartDatabaseManagerDelegate>)delegate {
    if (delegate && ![mulitDelegate.delegates.allObjects containsObject:delegate]) {
        [mulitDelegate addDelegate:delegate];
    }
}
- (void)deleteDelegate:(id<ChartDatabaseManagerDelegate>)delegate{
    [mulitDelegate removeDelegate:delegate];
}

#pragma mark - 数据库更新后 需要通知 代理执行的相关方法
- (void)receiveMessageNew:(NSObject *)message {
    [mulitDelegate receiveMessageNew:message];
}
- (void)updateMessage:(NSObject *)message {
    [mulitDelegate updateMessage:message];
}
- (void)newAddress:(NSObject *)user {
    [mulitDelegate newAddress:user];
}
- (void)updateConversation: (NSObject *)conversation {
    [mulitDelegate updateConversation:conversation];
}
@end
