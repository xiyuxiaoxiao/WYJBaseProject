//
//  WYJChartMessage.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/15.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"

NS_ASSUME_NONNULL_BEGIN

@interface WYJChartMessage : NSObject

@property (nonatomic, copy)   NSString *fromUserId; // 发送者
@property (nonatomic, copy)   NSString *toUserId;   // 接受者
@property (nonatomic, copy)   NSString *content;    // 内容
@property (nonatomic, assign)      int  type;       // 类型 1-文字 、 2-图片
@property (nonatomic, copy)   NSString *sendTime;   // 发送时间

@end

NS_ASSUME_NONNULL_END
