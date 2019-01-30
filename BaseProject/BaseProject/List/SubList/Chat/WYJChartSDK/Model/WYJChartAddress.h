//
//  WYJChartAddress.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/15.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "JKDBModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WYJChartAddress : JKDBModel
@property (nonatomic, copy)   NSString *userId;     // 用户id
@property (nonatomic, copy)   NSString *name;       // 用户名称
@property (nonatomic, copy)   NSString *nickName;   // 昵称

// 如果在此记录最后一条消息 和 未读个数 那么无法实现 唯独个数的消息 放在最上面 因为如果用户的头像变更的话 也会需要更新的

+ (void)addNewFriendWithName:(NSString *)name;

@end


NS_ASSUME_NONNULL_END
