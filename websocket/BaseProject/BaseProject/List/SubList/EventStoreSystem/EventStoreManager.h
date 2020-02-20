//
//  EventStoreManager.h
//  BaseProject
//
//  Created by ZSXJ on 2017/6/5.
//  Copyright © 2017年 WYJ. All rights reserved.
//

/*
 参考：
    http://www.tairan.com/archives/7729/
 
    http://supershll.blog.163.com/blog/static/3707043620127284210222/
 
 */
#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
@interface EventStoreManager : NSObject
@property (nonatomic, strong) EKEventStore *eventStore;
+ (EventStoreManager *)shareManager;
+ (BOOL)maskEventAccess;
+ (void)requestAccessToEntityType;


// 删除完成的 reminder
+ (void)delegate;

// 查找所有的reminder
+ (void)findAllReminder:(void (^)(NSArray<EKReminder *> * reminders))completion;

// 添加
+ (void)addReminder;

@end
