//
//  WYJChartMessage.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/15.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartDBModel.h"

@class WYJChartContentModel;

NS_ASSUME_NONNULL_BEGIN

@interface WYJChartMessage : WYJChartDBModel

@property (nonatomic, copy)   NSString *fromUserId; // 发送者
@property (nonatomic, copy)   NSString *toUserId;   // 接受者
@property (nonatomic, copy)   NSString *content;    // 内容
@property (nonatomic, assign)      int  type;       // 类型 1-文字 、 2-图片
@property (nonatomic, copy)   NSString *sendTime;   // 发送时间 （时间戳）

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
@property (nonatomic, assign)   BOOL    sendTimeShow;     // 是否显示时间

- (NSString *)parnerUserId;
// 重新发送
- (void)reSendServer;
- (void)sendSuccess;

+ (NSArray *)findMessageArray:(NSString *)friendUserId page:(int)page perPageCount:(int)count lastCreatId:(NSString *)lastCreatId;
// 查询单个好友的所有聊天文件路径
+ (NSArray *)findFilePathByFriendUserId: (NSString *)friendUserId;

// 查询是否 只有一个文件名在本地存储的
+ (BOOL)onlyOneMessageFileName: (NSString *)fileName;


@end

NS_ASSUME_NONNULL_END



@interface WYJChartContentModel : NSObject

@property (nonatomic, copy)     NSString *fileName; // 文件名
@property (nonatomic, assign)   CGSize imageSize;   // 图片尺寸

@property (nonatomic, copy)     NSString *fileURL;   // 文件路径

// 如果是这样 则需要考虑下载到本地的时候 是否已经下载好 否则没有下载好的话 在访问会出现问题
// 如果是在socket接受的 可以通过接受data 然后在存储文件路劲/次fileURLServer 可以用下载文件内容等
@property (nonatomic, copy)     NSString *fileURLServer; // 文件在服务器上的路径 （图片或者语音等路径）
// 相关语音时长等等
@end
