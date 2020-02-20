//
//  MessageList.h
//  FMDBMoreTable
//
//  Created by ZSXJ on 2018/5/24.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "JKDBModel.h"

@interface MessageList : JKDBModel

@property (nonatomic,copy) NSString *toUserId;
@property (nonatomic,copy) NSString *fromUserId;
@property (nonatomic,copy) NSString *content; //内容
@property (nonatomic,copy) NSString *time; // 时间

// sqlit 支持的数据类型 https://www.jianshu.com/p/9b4d241a1796
// timestamp 造成的时区问题修复： https://www.cnblogs.com/GDLMO/archive/2010/07/19/1780920.html
// 数据类型 不允许使用 NSDate  但是可以使用  timestamp 不过由于本地时区原因，可能造成时间不准确

@property (nonatomic,copy) NSString *serverReceiveTime; // 服务器时间
@property (nonatomic,copy) NSString *saveLocalTime; // 本地时间

+ (NSArray *)findMessageArray:(NSString *)friendUserId page:(int)page perPageCount:(int)count;
+ (NSArray *)findMessageArray:(NSString *)friendUserId page:(int)page perPageCount:(int)count lastCreatId:(NSString *)lastCreatId;
@end
