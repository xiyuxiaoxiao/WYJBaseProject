//
//  WYJChartConversation.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/29.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartConversation.h"
#import "JKDBHelper.h"
#import "WYJChartAddress.h"
#import "WYJChartMessage.h"

@implementation WYJChartConversation

+ (NSArray *)transients {
    return @[@"lastMessage",@"lastTimeString",@"partnerUser"];
}

+ (NSArray *)uniquePropertys {
    return @[@"partnerUserId"];
}

+ (NSArray *)findAddressWithOneMessage {
    
//    NSString *sql = @"select con.*, toMsg.content from WYJChartConversation AS con LEFT JOIN WYJChartMessage AS toMsg ON con.partnerUserId = toMsg.toUserId OR con.partnerUserId = toMsg.fromUserId group by con.partnerUserId";
    NSString *sql = @"select con.*, adr.*, toMsg.content, con.pk AS conPK, adr.pk AS adrPK from WYJChartConversation AS con LEFT JOIN WYJChartAddress AS adr ON con.partnerUserId = adr.userId LEFT JOIN WYJChartMessage AS toMsg ON con.partnerUserId = toMsg.toUserId OR con.partnerUserId = toMsg.fromUserId group by adr.userId";
    
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    NSMutableArray *columeNamesArray = [NSMutableArray array];
    
    //    [jkDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    //
    ////    }];
    
    //  在之前先创建一下WYJChartAddress 主要是初始化一下 否则会在下面的队列中 创建对象 会导致执行一次表结构的 执行相关的队列
    [WYJChartAddress alloc];
    
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSLog(@"%@",db.databasePath);
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            
            // 如果实现方法 放在其他地方，
            // 只要切换对象 初始化就会崩溃
            //            MessageList *msg = [[MessageList alloc] init];
            JKDBModel *model = [self JKDBModelWithResultset:resultSet];
            [model setValue:[NSNumber numberWithLongLong:[resultSet longLongIntForColumn:@"conPK"]] forKey:@"pk"];
            
            JKDBModel *user = [NSClassFromString(@"WYJChartAddress") JKDBModelWithResultset:resultSet];
            [user setValue:[NSNumber numberWithLongLong:[resultSet longLongIntForColumn:@"adrPK"]] forKey:@"pk"];
            [model setValue:user forKey:@"partnerUser"];
            
            
            NSString *content = [resultSet stringForColumn:@"content"];
            [model setValue:content forKey:@"lastMessage"];
            
            
            [columeNamesArray addObject:model];
            FMDBRelease(model);
        }
    }];
    
    // 或者 在请求完毕后 在查询相关user信息
    return columeNamesArray;
}

+ (instancetype)findByUserId:(NSString *)userId {
    NSString *sql_conversation = [@"where partnerUserId = " stringByAppendingString:userId];
    WYJChartConversation *conversation = [WYJChartConversation findFirstByCriteria:sql_conversation];
    if (!conversation) {
        return nil;
    }
    
    NSString *sql_address = [@"where userId = " stringByAppendingString:conversation.partnerUserId];
    WYJChartAddress *address = [WYJChartAddress findFirstByCriteria:sql_address];
    
    if (address) {
        conversation.partnerUser = address;
    }
    
    NSString *sql_message = [NSString stringWithFormat:@"where fromUserId = %@ or toUserId = %@ order by pk desc",conversation.partnerUserId,conversation.partnerUserId];
    WYJChartMessage *message = [WYJChartMessage findFirstByCriteria:sql_message];
    
    if (message) {
        conversation.lastMessage = message.content;
    }
    
    return conversation;
}

@end
