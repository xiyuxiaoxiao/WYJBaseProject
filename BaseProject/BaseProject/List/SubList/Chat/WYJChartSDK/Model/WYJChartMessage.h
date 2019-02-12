//
//  WYJChartMessage.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/15.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "JKDBModel.h"

@class WYJChartContentModel;

NS_ASSUME_NONNULL_BEGIN

@interface WYJChartMessage : JKDBModel

@property (nonatomic, copy)   NSString *fromUserId; // 发送者
@property (nonatomic, copy)   NSString *toUserId;   // 接受者
@property (nonatomic, copy)   NSString *content;    // 内容
@property (nonatomic, assign)      int  type;       // 类型 1-文字 、 2-图片
@property (nonatomic, copy)   NSString *sendTime;   // 发送时间

@property (nonatomic, copy)   NSString *contentModelInfo;   // 其他信息转为字符串


/*
    每次第一次进入时将所有未发送的信息状态改成发送失败
 
    如果正在发送中 -- 然后终止掉程序 --下次进入的时候 状态未更新 还是发送中
 因此需要每次打开程序 将所有未发送的消息重新发送 或者 改为发送失败 因为需要同步
 
 1.要么全部改成发送失败
 2.要么将发送中的重新发送一次
 发送失败的则不再发送 （因为不确定 也可能是不允许发送相应的消息）
 */
// 0：发送成功 、1：正在发送 、 2：发送失败
@property (nonatomic, assign)   int sendStatus;
// 0：未读  1:已读
@property (nonatomic, assign)   int readStatus;



//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// 额外的
@property (nonatomic, strong)   WYJChartContentModel *contentInfoModel;   // 其他信息 对象
@property (nonatomic, assign)   BOOL    byMySelf;
@property (nonatomic, assign)   CGSize  contentBackSize;  // 内容背景size
@property (nonatomic, assign)   CGFloat cellHeight;       // cell高度

- (NSString *)parnerUserId;

+ (NSArray *)findMessageArray:(NSString *)friendUserId page:(int)page perPageCount:(int)count lastCreatId:(NSString *)lastCreatId;
// 重新发送
- (void)reSendServer;
- (void)sendSuccess;

@end

NS_ASSUME_NONNULL_END



@interface WYJChartContentModel : NSObject
// 图片尺寸
@property (nonatomic, assign)   CGSize imageSize;

// 相关语音时长等等
@end
