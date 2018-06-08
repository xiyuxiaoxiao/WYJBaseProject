//
//  EventStoreManager.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/5.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "EventStoreManager.h"

typedef enum : NSUInteger {
    TTT1,
    TTT2,
    TTT3
} TTT;

@interface EventStoreManager ()
@property (nonatomic ,assign) BOOL maskEventAccess;
@end

@implementation EventStoreManager

-(instancetype)init {
    self = [super init];
    if (self) {
        self.eventStore = [[EKEventStore alloc] init];
    }
    return self;
}

+ (EventStoreManager *)shareManager {
    static EventStoreManager *eventStoreManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eventStoreManager = [[EventStoreManager alloc] init];
    });
    
    return eventStoreManager;
}

+ (BOOL)maskEventAccess {
    EventStoreManager *eventStoreManager = [EventStoreManager shareManager];
    return eventStoreManager.maskEventAccess;
}

+ (void)requestAccessToEntityType {
    
//    NSLog(@"%ld,%ld,%ld,%ld",EKEntityTypeEvent,EKEntityTypeReminder,EKEntityMaskEvent,EKEntityMaskReminder);
    NSLog(@"%ld,%ld",TTT1,3<<2);
    
    EventStoreManager *eventStoreManager = [EventStoreManager shareManager];
    
    if ([eventStoreManager.eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        //等待用户是否同意授权日历

        /*
             该参数真机模拟器一样
             EKEntityTypeEvent    : 相访问 日历
             EKEntityTypeReminder : 想访问 提醒事项
         
             EKEntityMaskEvent    : 想访问 提醒事项
             EKEntityMaskReminder : 经测试 请求权限出错
         */
        [eventStoreManager.eventStore requestAccessToEntityType:EKEntityMaskEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    NSLog(@"请求权限出错");
                }else if (!granted)
                {
                    NSLog(@"没有访问提醒事项的权限");
                    //被⽤户拒绝,不允许访问日历
                }else{
                    NSLog(@"有访问提醒事项的权限");
                    eventStoreManager.maskEventAccess = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:EKEventStoreChangedNotification object:eventStoreManager.eventStore];
                }
            });
        }];
    }
}

// 删除
+ (void)delegate {
    
    dispatch_async(dispatch_queue_create(0, 0), ^{
        [self findCompletedReminder];
    });
}

// 查找所有完成的
+(void)findCompletedReminder {
    EventStoreManager *eventStoreManager = [EventStoreManager shareManager];
    EKEventStore *eventStore = eventStoreManager.eventStore;
    
    NSPredicate *predicate = [eventStore predicateForCompletedRemindersWithCompletionDateStarting:nil ending:nil calendars:nil];
    [eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders) {
        NSLog(@"总个数：%ld",reminders.count);
        for (EKReminder *reminder in reminders) {
            NSLog(@"%@",reminder.title);
            
            NSError *error = nil;
            
            BOOL result = [eventStore removeReminder:reminder commit:NO error:&error];
            if (result) {
                NSLog(@"删除成功");
            }else {
                NSLog(@"删除不成功");
            }
            
            NSError *commit = nil;
            BOOL commitResult = [eventStore commit:&commit];
            if (commitResult) {
                NSLog(@"提交删除成功");
            }else {
                NSLog(@"提交删除不成功");
            }
            
        }
    }];
}


+ (void)findAllReminder:(void (^)(NSArray<EKReminder *> * reminders))completion {
    EventStoreManager *eventStoreManager = [EventStoreManager shareManager];
    EKEventStore *eventStore = eventStoreManager.eventStore;
    
    if (NO == [eventStoreManager maskEventAccess]) {
        completion(@[]);
        return;
    }
    
    NSPredicate *predicate = [eventStore predicateForRemindersInCalendars:nil];
    [eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray<EKReminder *> * _Nullable reminders) {
        NSLog(@"%@",reminders);
        completion(reminders);
    }];
}


+ (void)addReminder {

    EKEventStore *eventStore = [EventStoreManager shareManager].eventStore;
    EKReminder *reminder = [self getEventReminder:eventStore date:[NSDate date]];
    NSError *error=nil;
    BOOL result = [eventStore saveReminder:reminder commit:YES error:&error];
    if (error) {
        NSLog(@"error=%@",error);
    }
    if (result) {
        NSLog(@"保存成功");
    }else {
        NSLog(@"失败");
    }
}

//获取写入 提醒事件对象
+ (EKReminder *)getEventReminder:(EKEventStore *)eventStore date:(NSDate *)date {
    
    EKCalendar * iDefaultCalendar = [eventStore defaultCalendarForNewReminders];
    EKReminder *reminder=[EKReminder reminderWithEventStore:eventStore];
    reminder.calendar=iDefaultCalendar;
    reminder.title = @"新增的";
    reminder.notes = @"notes注释";
    
    EKAlarm *alarm=[EKAlarm alarmWithAbsoluteDate:date];
    [reminder addAlarm:alarm];
    NSLog(@"%@",reminder.calendarItemIdentifier);
    return reminder;
}


// --------test

@end
