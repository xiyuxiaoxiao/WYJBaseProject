//
//  JKDBVersionUpdateTest.h
//  BaseProject
//
//  Created by ZSXJ on 2018/6/1.
//  Copyright © 2018年 WYJ. All rights reserved.
//

// 数据库表 版本更新  用于迁移 MessageList表  
#import "WYJChartDBModel.h"

@interface JKDBVersionUpdateTest : WYJChartDBModel

@property (nonatomic,copy) NSString *toUserId;
@property (nonatomic,copy) NSString *fromUserId;
@property (nonatomic,copy) NSString *messageText; //内容

//// 如果没有下面属性 不能将数据更新过去 需要确保当前数据库有 对于插入的时候 需要确保 目标插入属性包含被插入的 否则不能成功
@property (nonatomic,copy) NSString *time; // 时间
@property (nonatomic,copy) NSString *serverReceiveTime; // 服务器时间
@property (nonatomic,copy) NSString *saveLocalTime; // 本地时间
@end
