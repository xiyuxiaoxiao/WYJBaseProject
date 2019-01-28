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
@property (nonatomic,copy)    NSString *lastNewMessage; // 最后一条消息

+ (void)addNewFriendWithName:(NSString *)name;

@end


NS_ASSUME_NONNULL_END
