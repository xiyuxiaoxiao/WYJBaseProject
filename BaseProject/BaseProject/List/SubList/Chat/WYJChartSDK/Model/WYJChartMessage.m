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
- (NSString *)parnerUserId {
    if (self.byMySelf) {
        return self.toUserId;
    }
    return self.fromUserId;
}
- (CGFloat)cellHeight {
    if (_sendTimeShow) {
        return _cellHeight;
    }
    return _cellHeight - 20;
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
        [WYJChartCellTool saveConversionUnRead:self];
        return YES;
    }
    return NO;
}
- (BOOL)update {
    if([super update]) {
        [[ChartDatabaseManager share] receiveMessageNew:self];
        return YES;
    }
    return NO;
}
+ (NSArray *)transients {
    return @[@"contentInfoModel",@"byMySelf",@"contentBackSize",@"cellHeight",@"sendTimeShow"];
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

+ (NSArray *)findFilePathByFriendUserId: (NSString *)friendUserId {
    NSString *tableName = NSStringFromClass(self);
    NSString *sql =  [NSString stringWithFormat:@"select * from %@ where (toUserId = '%@' or fromUserId = '%@') and type = 2",tableName,friendUserId,friendUserId];
    
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    NSMutableArray *columeNamesArray = [NSMutableArray array];
    
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            
            JKDBModel *model = [self JKDBModelWithResultset:resultSet];
            WYJChartMessage *message = model;
            [columeNamesArray insertObject:message.contentInfoModel.fileURL atIndex:0];
            FMDBRelease(model);
        }
    }];
    
    return columeNamesArray;
}

//-----------------------------------------------------------
#pragma mark - 对image的size 等其他信息 json与model之间的转化

@synthesize contentInfoModel = _contentInfoModel;

- (WYJChartContentModel *)contentInfoModel {
    if (_contentInfoModel == nil) {
        _contentInfoModel = [self.class convertContentModelWithJson:_contentModelInfo];
    }
    return _contentInfoModel;
}

-(void)setContentInfoModel:(WYJChartContentModel *)contentInfoModel {
    _contentInfoModel = contentInfoModel;
    
    if (!_contentModelInfo) {
        _contentModelInfo = [self.class convertContentInfoWithModel:_contentInfoModel];
    }
}

+ (WYJChartContentModel *)convertContentModelWithJson:(NSString *)json {
    
    if (!json) {
        return nil;
    }
    
    NSDictionary *dict = [self.class dictionaryWithJsonString:json];
    WYJChartContentModel *model  = [[WYJChartContentModel alloc] init];
    model.imageSize     = CGSizeFromString(dict[@"imageSize"]);
    model.fileName      = dict[@"fileName"];
    model.fileURLServer = dict[@"fileURLServer"];
    return model;
}

+ (NSString *)convertContentInfoWithModel:(WYJChartContentModel *)contentModel {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"imageSize"]  = NSStringFromCGSize(contentModel.imageSize);
    dict[@"fileName"]   = contentModel.fileName;
    dict[@"fileURLServer"] = contentModel.fileURLServer;
    return [self.class convertToJSONData:dict];
}

//字典与字符串的转化
+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end


// --------------------WYJChartContentModel-----------------

#pragma mark - WYJChartContentModel
#import "UIImage+WYJChartImageStore.h"

@implementation WYJChartContentModel
- (NSString *)fileURL {
    
    if (!_fileName) {
        return nil;
    }
    
    NSString *path          = [UIImage filePathDocument];
    NSString *imageFilePtah = [path stringByAppendingString:_fileName];
    
    return imageFilePtah;
}
@end
