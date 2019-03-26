//
//  WYJChartCellTool.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/23.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartCellTool.h"
#import "WYJChartTextCell.h"
#import "WYJChartAddress.h"
#import "WYJChartConversation.h"
#import "UIImage+WYJChartImageStore.h"
#import "WYJChartManager.h"

@implementation WYJChartCellTool

static WYJChartAddress *currentUser = nil;
+ (WYJChartAddress *)getCurrentUser {
    
    if (currentUser == nil) {
        currentUser = [[WYJChartAddress alloc] init];
        currentUser.userId  = @"20180001";
        currentUser.name    = @"小旺";
        currentUser.portraitURL = @"http://lc-snkarza7.cn-n1.lcfile.com/4909a37f32dff9d050ad.JPG";
    }
    return currentUser;
    
}

#pragma mark - 创建消息对象
+ (WYJChartMessage *)creatMessageText: (NSString *)text {
    WYJChartTextCell *cell = [[WYJChartTextCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@""];
    
    WYJChartMessage *msg = [[WYJChartMessage alloc] init];
    msg.content             = text;
    msg.sendStatus          = SendStatusSuccess;
    msg.type                = MessageTypeText;
    
    cell.messageLabel.text  = msg.content;
    [WYJChartCellTool setCellheight:msg];
    
    return msg;
}
+ (WYJChartMessage *)creatMessageImage:(UIImage *)image {
    
    NSString *imageName = [WYJFileTool creatFileName];
    [image storeFileName:imageName];
    
    WYJChartContentModel *contentModel = [[WYJChartContentModel alloc] init];
    contentModel.imageSize  = image.size;
    contentModel.fileName   = imageName;
    
    WYJChartMessage *msg = [[WYJChartMessage alloc] init];
    msg.content             = @"[图片]";
    msg.sendStatus          = SendStatusSuccess;
    msg.type                = MessageTypeImage;
    
    msg.contentInfoModel    = contentModel;
    
    [WYJChartCellTool setCellheight:msg];
    
    return msg;
}
+ (WYJChartMessage *)creatMessageWithURL:(NSString *)url{
    
    WYJChartContentModel *contentModel = [[WYJChartContentModel alloc] init];
    contentModel.imageSize  = CGSizeMake(80, 120);
    contentModel.fileName   = [WYJFileTool fileNameWithURL:url];
    contentModel.fileURLServer = url;
    
    WYJChartMessage *msg = [[WYJChartMessage alloc] init];
    msg.content             = @"[图片]";
    msg.sendStatus          = SendStatusSuccess;
    msg.type                = MessageTypeImage;
    
    msg.contentInfoModel    = contentModel;
    
    [WYJChartCellTool setCellheight:msg];
    
    return msg;
}

#pragma mark - cell高度
+ (void)setCellheight: (WYJChartMessage *)message {
    if (message.type == MessageTypeText) {
        [self setTextCellheight:message];
    }
    else if (message.type == MessageTypeImage) {
        [self setImageCellheight:message];
    }
}

+ (void)setTextCellheight: (WYJChartMessage *)message {
    // 文本消息的高度计算
    UILabel *_messageLabel = [[UILabel alloc] init];
    _messageLabel.textColor = [UIColor blueColor];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = [UIFont systemFontOfSize:12];
    _messageLabel.numberOfLines = 0;
    _messageLabel.text = message.content;
    
    /*
     36*2   左右两边各流出头像距离
     8      contentBack 与头像间距
     25     文字与contentback左右间距
     22+8   发送失败按钮的间距
     
     总：135
     */
    CGSize size = [_messageLabel sizeThatFits:CGSizeMake(WYJChartCellWidth - 135, MAXFLOAT)];
    size.height += 14;
    size.width += 25;
    
    
    if (size.height < 36) {
        size.height = 36;
    }
    
    message.contentBackSize = size;
    message.cellHeight = [WYJChartBaseCell extraHeight] + size.height;
}

+ (void)setImageCellheight:(WYJChartMessage *)message {
    message.contentBackSize = [self calculateImageSizeOfCell:message.contentInfoModel.imageSize];
    message.cellHeight = [WYJChartBaseCell extraHeight] + message.contentBackSize.height;
}
+ (CGSize)calculateImageSizeOfCell:(CGSize)imageSize{
    CGFloat minSideLength = 80;
    CGFloat maxSideLength = 160;
    
    CGFloat w_image = imageSize.width;
    CGFloat h_image = imageSize.height;
    
    if (w_image == 0) {
        w_image = 1.0;
    }
    CGFloat ratio = h_image / w_image;
    
    
    if (ratio < 0.5) {
        h_image = minSideLength;
        w_image = maxSideLength;
    }
    else if (ratio < 1) {
        h_image = maxSideLength * ratio;
        w_image = maxSideLength;
    }
    else if (ratio <= 2) {
        h_image = maxSideLength;
        w_image = maxSideLength / ratio;
    }else {
        h_image = maxSideLength;
        w_image = minSideLength;
    }
    
    return CGSizeMake(w_image, h_image);
}

// 只有在展示的时候 才用到相关计算 不需要全部计算 但是每次滑动都需要计算 不影响
+ (void)reSetSendTimeMessage:(NSArray *)array whenCellHeightIndexpath:(NSIndexPath *)indexPath {
    
    WYJChartMessage *message = array[indexPath.row];
    message.sendTimeShow = NO;
    
    if (indexPath.row == 0) {
        message.sendTimeShow = YES;
        return;
    }
    WYJChartMessage *lastMessage = array[indexPath.row-1];
    // 超过5分钟 就显示
    if (message.sendTime.doubleValue/1000 - lastMessage.sendTime.doubleValue/1000 > 300) {
        message.sendTimeShow = YES;
    }
}


#pragma mark - 数据库相关操作

+ (void)sendMessage:(WYJChartMessage *)message toUser:(WYJChartAddress *)user {
    message.toUserId = user.userId;
    message.fromUserId = [self getCurrentUser].userId;
    message.sendTime   = [WYJDate getTimeSp:[NSDate date]];
    message.sendStatus = SendStatusSending;
    
    if (message.pk) {
        // 有本地的pk表示是重新发送
        [message update];
    }else {
        [message save];
    }
    
    dispatch_async(dispatch_queue_create("wyj.chart", DISPATCH_QUEUE_SERIAL), ^{
        sleep(3);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendMessageNetworkBack:message toUser:user];
        });
    });
}

+ (void)sendMessageNetworkBack: (WYJChartMessage *)message toUser:(WYJChartAddress *)user{
    int index = arc4random() % 2;
    if (index == 0) {
        message.sendStatus = SendStatusSuccess;
    }
    else if (index == 1)  {
        message.sendStatus = SendStatusFaile;
    }
    [message update];
    
    if (message.sendStatus == SendStatusSuccess) {
        if (message.type == MessageTypeText) {
            // 延时执行 在后台无法运行 只有在此回到前台的时候才会运行 (在进入后台的时候 添加[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil] 申请时间便可以)
            [WYJChartCellTool performSelector:@selector(receiveTextMessageFromUser:) withObject:user afterDelay:2];
        }else if (message.type == MessageTypeImage) {
            [WYJChartCellTool performSelector:@selector(receiveImageMessageFromUser:) withObject:user afterDelay:2];
        }
    }
}

+ (void)receiveMessage:(WYJChartMessage *)message {
    message.byMySelf        = NO;
    message.sendStatus      = SendStatusSuccess;
    message.toUserId        = [self getCurrentUser].userId;
    message.sendTime        = [WYJDate getTimeSp:[NSDate date]];
    
    if ([WYJChartManager isReadMessageByUserId:message.fromUserId]) {
        message.readStatus      = ReadStatusRead;
    }else {
        message.readStatus      = ReadStatusUnRead;
    }
    
    [message save];
    
    if (message.readStatus == ReadStatusUnRead) {
        // 前台通知 创建本地通知
        WYJChartAddress *user = [WYJChartAddress findByUserId:message.fromUserId];
        [WYJChartManager pushLocalNotificationWithMessage:message fromUser:user];
    }
}
+ (WYJChartMessage *)receiveTextMessageFromUser:(WYJChartAddress *)user {
    WYJChartMessage *message = [self creatMessageText:@"收到你的消息了"];
    message.fromUserId      = user.userId;
    [self receiveMessage:message];
    return message;
}
+ (WYJChartMessage *)receiveImageMessageFromUser:(WYJChartAddress *)user {
    
    NSArray *array = @[@"http://lc-snkarza7.cn-n1.lcfile.com/9943047a70c8163096b3.jpg",
                       @"http://lc-snkarza7.cn-n1.lcfile.com/627383453400d53214af.JPG",
                       @"http://lc-snkarza7.cn-n1.lcfile.com/6ce9eafa8590b6a8e0e3.JPG"];
    int index = arc4random() % 3;
    WYJChartMessage *message = [self creatMessageWithURL:array[index]];
    message.fromUserId = user.userId;
    [self receiveMessage:message];
    return message;
}

+ (void)saveConversionUnRead:(WYJChartMessage *)message {
    // 需要先查询 是否已经存在 或者看看 直接覆盖更新的方法
    NSString *parnerUserId = @"";
    if (message.byMySelf) {
        parnerUserId = message.toUserId;
    }else {
        parnerUserId = message.fromUserId;
    }
    
    NSString *sql = [NSString stringWithFormat:@"WHERE partnerUserId = %@",parnerUserId];
    WYJChartConversation *conversion = [WYJChartConversation findFirstByCriteria:sql];
    
    if (!conversion) {
        conversion = [[WYJChartConversation alloc] init];
        conversion.partnerUserId = parnerUserId;
        conversion.unreadCount = 0;
    }
    if (!message.byMySelf && message.readStatus == ReadStatusUnRead) {
        conversion.unreadCount += 1;
    }
    // 无论如何都需要更新 来通知 相关列表更新UI
    [conversion saveOrUpdate];
}
+ (void)clearConversionUnReadWithUserId:(NSString *)userId {
    // 需要先查询 是否已经存在 或者看看 直接覆盖更新的方法
    NSString *parnerUserId = userId;
    NSString *sql = [NSString stringWithFormat:@"WHERE partnerUserId = %@ and unreadCount > 0",parnerUserId];
    WYJChartConversation *local = [WYJChartConversation findFirstByCriteria:sql];
    if (local && local.unreadCount > 0) {
        local.unreadCount = 0;
        [local saveOrUpdate];
    }
}

#pragma mark - 删除相关文件
/*
 删除微信消息的时候 如何删除关联的文件 经测试 需要考虑分享的时候 使用的是同一个URL 接受分享消息 也同样如此
 
 需要将URl 和文件名 一一 对应 查看相同的URL （利用SDWebImage获取或者创建）
 删除好友的时候 由于同一个消息 本地的路径是一样的 这样当某个消息是转发过来的时候，本地的文件 是不能直接删除的 需要判断是否还有其他消息使用
 解决方法：
 1. 删除单个消息的时候 查询url是否还存在相同的 否则不删除
 2. 删除好友的时候 删除消息，需要查询 当前好友消息的文件路径 以及 文件路径不重复的情况，避免多个消息引用同一个URL
 3. 如果是清空所有聊天数据 则可以根据目录删除 以及删除消息数据表所有数据
 */

// 删除数据
+ (void)deleteMessage: (WYJChartMessage *)message {
    [message deleteObject];
    
    // 清除相关联文件
    if (message.type == MessageTypeImage) {
        [self delegateFileWithFilePath:message.contentInfoModel.fileURL];
    }
}
// 删除单个好友的聊天记录 // 在记录的每个用户的时候 文件存储单个目录 这样在删除聊天文件的时候 就可以通过用户的id来删除
+ (void)deleteMessageByUserId:(NSString *)userId {
    
    NSArray *fileArr = [WYJChartMessage findFilePathByFriendUserId:userId];
    
    // 需要先查好出 所有聊天包含的文件路径 然后删除相关路径
    NSString *sqlWhere = [NSString stringWithFormat:@"where (toUserId = '%@' or fromUserId = '%@')",userId,userId];
    [WYJChartMessage deleteObjectsByCriteria:sqlWhere];
    
    // 上面删除成功了 才能删除文件路径
    for (NSString *path in fileArr) {
        [self delegateFileWithFilePath:path];
    }
    
    //删除会话
    NSString *sqlConv = [NSString stringWithFormat:@"where (partnerUserId = %@)",userId];
    [WYJChartConversation deleteObjectsByCriteria:sqlConv];
}

// 删除文件  先查找本地 是否全部没有了 然后才可以删除
+ (void)delegateFileWithFilePath: (NSString *)filePath {
    BOOL res = [WYJChartMessage onlyOneMessageFileName:filePath.lastPathComponent];
    if (res) {
        // 如果正在下载某个文件 也应该暂停下载 删除相关正在下载文件 并且取消相应下载文件
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}
@end
