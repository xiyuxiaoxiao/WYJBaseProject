//
//  WYJChartCellTool.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/23.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYJChartMessage.h"
@class WYJChartAddress;

NS_ASSUME_NONNULL_BEGIN

@interface WYJChartCellTool : NSObject

+ (WYJChartAddress *)getCurrentUser;

+ (WYJChartMessage *)creatMessageText: (NSString *)text;
+ (WYJChartMessage *)creatMessageImage:(UIImage *)image;

+ (void)setCellheight: (WYJChartMessage *)message;

+ (void)sendMessage:(WYJChartMessage *)message toUser:(WYJChartAddress *)user;
+ (WYJChartMessage *)receiveMessageFromUser:(WYJChartAddress *)user;


// 设置未读消息数量
+ (void)saveConversionUnRead:(WYJChartMessage *)message;
// 清除未读标记
+ (void)clearConversionUnReadWithUserId:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
