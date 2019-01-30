//
//  WYJChartConversation.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/29.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "JKDBModel.h"

@class WYJChartMessage;
@class WYJChartAddress;

NS_ASSUME_NONNULL_BEGIN

@interface WYJChartConversation : JKDBModel

// 暂时不用 因为message列表 没有使用 这个id去关联
//@property (nonatomic, copy)   NSString *conversationId;    // 主键
@property (nonatomic, copy)   NSString *partnerUserId;     // 合作伙伴id (唯一键)
@property (nonatomic, assign) int unreadCount;             // 未读个数

// 不存储
@property (nonatomic, strong)   WYJChartAddress *partnerUser;    // 最后一条消息
@property (nonatomic, copy)   NSString *lastMessage;       // lastMessage;
@property (nonatomic, copy)   NSString *lastTimeString;    // 最后一条消息

+ (NSArray *)findAddressWithOneMessage;

// 在绘画列表中 对不存在的userId进行 添加 存在的获取未空的删除 存在获取不为空的更新  相关控制起通过代理查询
/*
 通过 UserId进行查询更新 不用判断设置各种条件 所有的更新都是因为消息的变更 删除以及保存
 每次有未读消息，删除 和 新的会话 都可以通过userid查询出需要的内容
 
 在UI操作 会话列表中 搜索是否存在相应的 用户会话 没有则添加 有则更新
 
 */
+ (instancetype)findByUserId:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
