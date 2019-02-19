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

@implementation WYJChartCellTool

static WYJChartAddress *currentUser = nil;
+ (WYJChartAddress *)getCurrentUser {
    
    if (currentUser == nil) {
        currentUser = [[WYJChartAddress alloc] init];
        currentUser.userId  = @"20180001";
        currentUser.name    = @"小旺";
    }
    return currentUser;
    
}

#pragma mark - 创建cell对象
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
    
    NSString *imageName = [UIImage hashFileName];
    [image storeFileName:imageName];
    
    WYJChartContentModel *contentModel = [[WYJChartContentModel alloc] init];
    contentModel.imageSize  = CGSizeMake(80, 120);
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
    
    NSString *imageName = [UIImage hashFileName];

    WYJChartContentModel *contentModel = [[WYJChartContentModel alloc] init];
    contentModel.imageSize  = CGSizeMake(80, 120);
    contentModel.fileName   = imageName;
    contentModel.fileURLServer = url;
    
    WYJChartMessage *msg = [[WYJChartMessage alloc] init];
    msg.content             = @"[图片]";
    msg.sendStatus          = SendStatusSuccess;
    msg.type                = MessageTypeImage;
    
    msg.contentInfoModel    = contentModel;
    
    [WYJChartCellTool setCellheight:msg];
    
    return msg;
}

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

#pragma mark -

+ (void)sendMessage:(WYJChartMessage *)message toUser:(WYJChartAddress *)user {
    message.toUserId = user.userId;
    message.fromUserId = [self getCurrentUser].userId;
    message.sendTime = [WYJDate getTimeSp:[NSDate date]];
    [message save];
    
    // 模拟收到消息
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (message.type == MessageTypeText) {
            WYJChartMessage *msg = [WYJChartCellTool receiveTextMessageFromUser:user];
        }else if (message.type == MessageTypeImage) {
            WYJChartMessage *msg = [WYJChartCellTool receiveImageMessageFromUser:user];
        }
    });
}

+ (void)receiveMessage:(WYJChartMessage *)message {
    message.byMySelf        = NO;
    message.sendStatus      = SendStatusSuccess;
    message.toUserId        = [self getCurrentUser].userId;
    message.sendTime        = [WYJDate getTimeSp:[NSDate date]];
    message.readStatus      = ReadStatusUnRead;
    [message save];
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
//    for (NSString *str in array) {
//        WYJChartMessage *message = [self creatMessageWithURL:str];
//        message.fromUserId      = user.userId;
//        [self receiveMessage:message];
//    }
//    return nil;
    
    int index = arc4random() % 3;
    WYJChartMessage *message = [self creatMessageWithURL:array[index]];
    message.fromUserId      = user.userId;
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



// 也可以放在cell height计算高度中 对高度time的高度重新计算 是否需要显示 然后cell中在设置
+ (void)reSetSendTimeWithMessageArray: (NSArray *)array {
    for (int i = 0; i < array.count; i++) {
        WYJChartMessage *message = array[i];
        message.sendTimeShow = NO;
        if (i == 0) {
            message.sendTimeShow = YES;
            continue;
        }
        
        WYJChartMessage *lastMessage = array[i-1];
        // 超过5分钟 就显示
        if (message.sendTime.doubleValue/1000 - lastMessage.sendTime.doubleValue/1000 > 300) {
            message.sendTimeShow = YES;
        }
    }
}

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

@end
