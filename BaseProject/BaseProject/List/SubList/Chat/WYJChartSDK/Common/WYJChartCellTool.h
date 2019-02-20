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

#pragma mark - 创建消息对象
+ (WYJChartMessage *)creatMessageText: (NSString *)text;
+ (WYJChartMessage *)creatMessageImage:(UIImage *)image;
+ (WYJChartMessage *)creatMessageWithURL:(NSString *)url;

#pragma mark - cell高度
+ (void)setCellheight: (WYJChartMessage *)message;
// 只有在展示的时候 才用到相关计算 不需要全部计算 但是每次滑动都需要计算 不影响
+ (void)reSetSendTimeMessage:(NSArray *)array whenCellHeightIndexpath:(NSIndexPath *)indexPath;

#pragma mark - 数据库相关操作
+ (void)sendMessage:(WYJChartMessage *)message toUser:(WYJChartAddress *)user;

+ (WYJChartMessage *)receiveTextMessageFromUser:(WYJChartAddress *)user;
+ (WYJChartMessage *)receiveImageMessageFromUser:(WYJChartAddress *)user;


// 设置未读消息数量
+ (void)saveConversionUnRead:(WYJChartMessage *)message;
// 清除未读标记
+ (void)clearConversionUnReadWithUserId:(NSString *)userId;


// 删除单个好友的聊天记录
+ (void)delegateMessageByUserId:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
