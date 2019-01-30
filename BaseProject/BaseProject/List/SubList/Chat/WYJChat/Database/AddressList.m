//
//  AddressList.m
//  FMDBMoreTable
//
//  Created by ZSXJ on 2018/5/24.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "AddressList.h"
#import "JKDBHelper.h"

@implementation AddressList

- (NSString *)description {
    return [NSString stringWithFormat:@"id:%@,name:%@,sex:%@,lastMsg:%@",self.userId,self.name,self.sex,self.lastNewMessage];
}

#warning JKDBModel-Warning
// 此方法 不能创建在 外部 只能创建在 JKDBModel类 中，可能是因为释放的问题，
// 如果实现方法 放在其他地方 会使得 resultSet 里面 在创建对象 赋值的时候 如果创建类型 变更的话会出崩溃

// 并且 如果不是子本类中实现，第一次直接查询的话 应该会崩溃，需要初始化一下当前类的查询方法或者里面涉及的线程
+ (NSArray *)findAddressWithOneMessage {
    // 200通讯录  10万条消息 3秒
    // 200通讯录   1万条消息 0.5-0.6秒
    // 100通讯录   1万条消息 0.25秒
    NSString *sql = @"select adr.*, toMsg.content, count(userId) from AddressList AS adr LEFT JOIN MessageList AS toMsg ON adr.userId = toMsg.toUserId OR adr.userId = toMsg.fromUserId group by adr.userId";
    
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    NSMutableArray *columeNamesArray = [NSMutableArray array];
    
//    [jkDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//
////    }];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSLog(@"%@",db.databasePath);
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            
            // 如果实现方法 放在其他地方，
            // 只要切换对象 初始化就会崩溃
//            MessageList *msg = [[MessageList alloc] init];
            JKDBModel *model = [self JKDBModelWithResultset:resultSet];
            NSString *content = [resultSet stringForColumn:@"content"];
            [model setValue:content forKey:@"lastNewMessage"];
            
            
            [columeNamesArray addObject:model];
            FMDBRelease(model);
        }
    }];
    
    return columeNamesArray;
}

@end
