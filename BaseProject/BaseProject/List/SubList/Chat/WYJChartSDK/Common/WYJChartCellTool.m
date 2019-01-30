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

@implementation WYJChartCellTool
+ (void)setCellheight: (WYJChartMessage *)message {
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
    message.cellHeight = 50 + size.height;
}

+ (void)sendMessage:(WYJChartMessage *)message toUser:(WYJChartAddress *)user {
    message.toUserId = user.userId;
    message.fromUserId = [self getCurrentUser].userId;
    [message save];
    
//    // 模拟收到消息
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        WYJChartMessage *msg = [WYJChartCellTool receiveMessageFromUser:user];
//    });
}
+ (WYJChartMessage *)receiveMessageFromUser:(WYJChartAddress *)user {
    WYJChartMessage *message = [self creatMessageText:@"收到你的消息了"];
    message.byMySelf        = NO;
    message.sendStatus      = SendStatusSuccess;
    message.fromUserId      = user.userId;
    message.toUserId        = [self getCurrentUser].userId;
    
    [message save];
    return message;
}

+ (WYJChartMessage *)creatMessageText: (NSString *)text {
    WYJChartTextCell *cell = [[WYJChartTextCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@""];
    
    WYJChartMessage *msg = [[WYJChartMessage alloc] init];
    msg.content             = text;
    msg.sendStatus          = SendStatusSuccess;
    msg.byMySelf            = YES;
    msg.type                = MessageTypeText;
    
    cell.messageLabel.text  = msg.content;
    [WYJChartCellTool setCellheight:msg];
    
    return msg;
}


static WYJChartAddress *currentUser = nil;
+ (WYJChartAddress *)getCurrentUser {
    
    if (currentUser == nil) {
        currentUser = [[WYJChartAddress alloc] init];
        currentUser.userId  = @"20180001";
        currentUser.name    = @"小旺";
    }
    return currentUser;
    
}


+ (void)saveConversionUnRead:(WYJChartMessage *)message {
    // 需要先查询 是否已经存在 或者看看 直接覆盖更新的方法
    
    if (message.byMySelf) {
        return;
    }
//    if (message.readStatus != ReadStatusUnRead) {
//        return;
//    }
    
    NSString *parnerUserId = @"";
    if (message.byMySelf) {
        parnerUserId = message.toUserId;
    }else {
        parnerUserId = message.fromUserId;
    }
    
    NSString *sql = [NSString stringWithFormat:@"WHERE partnerUserId = %@",parnerUserId];
    WYJChartConversation *local = [WYJChartConversation findFirstByCriteria:sql];
    if (local) {
        local.unreadCount += 1;
        [local saveOrUpdate];
    }else {
        WYJChartConversation *conversion = [[WYJChartConversation alloc] init];
        conversion.partnerUserId = parnerUserId;
        conversion.unreadCount = 1;
        if ([conversion saveOrUpdate]){
            NSLog(@"成功");
        }else {
            NSLog(@"失败");
        }
    }
}
+ (void)clearConversionUnReadWithUserId:(NSString *)userId {
    // 需要先查询 是否已经存在 或者看看 直接覆盖更新的方法
    NSString *parnerUserId = userId;
    NSString *sql = [NSString stringWithFormat:@"WHERE partnerUserId = %@",parnerUserId];
    WYJChartConversation *local = [WYJChartConversation findFirstByCriteria:sql];
    if (local) {
        local.unreadCount = 0;
        [local saveOrUpdate];
    }
}
@end
