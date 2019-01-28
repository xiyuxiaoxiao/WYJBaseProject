//
//  WYJChartMessage.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/15.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartMessage.h"
#import "JKDBHelper.h"
#import "WYJChartDefine.h"
#import "WYJChartCellTool.h"
#import "WYJChartAddress.h"
@implementation WYJChartMessage

- (BOOL)byMySelf {
    
    return [[WYJChartCellTool getCurrentUser].userId isEqualToString:self.fromUserId];
}

#pragma mark - 本地数据操作
/**
 lastCreatId 最后一个创建的Id查询 这样可以保证在 加载历史数据的时候 不会因为新增数据 分页查询本地的时候 造成数据重复
 lastCreatId：主要指用于区分 消息id在新建的时候 可以确定其顺序，也可以用时间来表示，但是如果统一时刻两个时间相同 就需要其他字段加一区分
 */
+ (NSArray *)findMessageArray:(NSString *)friendUserId page:(int)page perPageCount:(int)count lastCreatId:(NSString *)lastCreatId{
    
    NSString *tableName = NSStringFromClass(self);
    // 需要添加（）因为与后 面的and 会出优先级的问题 导致分页加载会多于加载最新的
    NSString *sql =  [NSString stringWithFormat:@"select msg.* from %@ AS msg where (msg.toUserId = '%@' or msg.fromUserId = '%@')",tableName,friendUserId,friendUserId];
    
    if (lastCreatId != nil) {
        sql = [sql stringByAppendingFormat:@" and msg.pk < '%@'",lastCreatId];
    }
    
    sql = [sql stringByAppendingString:@" order by pk desc"];
    
    
    NSString *limitStr = [NSString stringWithFormat:@" limit %d,%d",(page-1)*count,count];
    if (lastCreatId != nil) {
        limitStr = [NSString stringWithFormat:@" limit %d",count];
    }
    sql = [sql stringByAppendingString:limitStr];
    
    //    NSString *sql =  [NSString stringWithFormat:@"select msg.* from MessageList AS msg where msg.toUserId = '%@' or msg.fromUserId = '%@' order by pk desc",friendUserId,friendUserId];
    
    return [self findMessageArrayBySql:sql];
}

+ (NSArray *)findMessageArrayBySql:(NSString *)sql {
    
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    NSMutableArray *columeNamesArray = [NSMutableArray array];
    
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            
            JKDBModel *model = [self JKDBModelWithResultset:resultSet];
            // 此处 由于最新时间的 放在最后 当前结果是按照时间倒序的分页请求的 所以应该让后面的插入在前面
            //            [columeNamesArray addObject:model];
            [columeNamesArray insertObject:model atIndex:0];
            FMDBRelease(model);
        }
    }];
    
    return columeNamesArray;
}

- (void)reSendServer {
    self.sendStatus = SendStatusSending;
}
- (void)sendSuccess {
    self.sendStatus = SendStatusSuccess;
}




- (BOOL)save {
    if ([super save]) {
        [[ChartDatabaseManager share] receiveMessageNew:self];
    }
    return NO;
}
- (BOOL)saveOrUpdate {
    if([super saveOrUpdate]) {
        [[ChartDatabaseManager share] receiveMessageNew:self];
    }
    return NO;
}
+ (NSArray *)transients {
    return @[@"byMySelf",@"contentBackSize",@"cellHeight"];
}
@end
