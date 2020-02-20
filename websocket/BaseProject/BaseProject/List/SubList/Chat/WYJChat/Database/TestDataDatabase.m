//
//  TestDataDatabase.m
//  FMDBMoreTable
//
//  Created by ZSXJ on 2018/5/28.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "TestDataDatabase.h"
#import "AddressList.h"
#import "MessageList.h"
#import "CurrentUserManager.h"

@implementation TestDataDatabase

+ (void)saveTestObjectAddressList {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 1000000; i++) {
        AddressList *list = [[AddressList alloc] init];
        list.userId = [@"userID_" stringByAppendingFormat:@"%d",i];
        list.name = [@"name" stringByAppendingFormat:@"%d",i];
        list.sex = i%2 == 0? @"男":@"女";
        [array addObject:list];
    }
    
    [AddressList saveObjects:array];
}

+ (void)saveTestObjectMessageList {
    NSMutableArray *array = [NSMutableArray array];
    
    // 对于大量数据边存储，边读取 会出现卡顿 应该放在子线程，FMDB 在读／写的时候 ，只能开启一个
    NSString *currentUserId = [CurrentUserManager currentUser].userId;
    
    for (int i = 0; i < 30; i++) {
        MessageList *list = [[MessageList alloc] init];
        list.toUserId = currentUserId;
        list.fromUserId = @"userID_0";
        list.content = [@"消息" stringByAppendingFormat:@"%d",i];
        [array addObject:list];
        
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *inputDate = [inputFormatter dateFromString:@"2018-01-01 00:00:00"];
        NSDate *newDate =  [inputDate dateByAddingTimeInterval:i*60];
        list.serverReceiveTime = [inputFormatter stringFromDate:newDate];
    }
    
    for (int i = 1; i < 40; i++) {
        
        MessageList *list = [[MessageList alloc] init];
        
        int toUserId = arc4random()%199;
        toUserId += 1;
        int isTo = arc4random()%2;
        
        
        NSString *friendUserId = [@"userID_" stringByAppendingFormat:@"%d",toUserId];
        // 表示 发送的是 好友
        if (isTo == 0) {
            list.toUserId = currentUserId;
            list.fromUserId = friendUserId;
            list.content = [@"在吗" stringByAppendingFormat:@"%d",i];
        }else {
            // 表示 发送的是 自己
            list.toUserId = friendUserId;
            list.fromUserId = currentUserId;
            list.content = [@"在呢" stringByAppendingFormat:@"%d",i];
        }
        
        [array addObject:list];
        
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *inputDate = [inputFormatter dateFromString:@"2018-01-01 00:00:00"];
        NSDate *newDate =  [inputDate dateByAddingTimeInterval:i*60];
        
        list.serverReceiveTime = [inputFormatter stringFromDate:newDate];
    }
    
    [MessageList saveObjects:array];
}



@end
