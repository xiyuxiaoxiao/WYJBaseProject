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
    
    // 模拟收到消息
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        WYJChartMessage *msg = [WYJChartCellTool receiveMessageFromUser:user];
    });
}
+ (WYJChartMessage *)receiveMessageFromUser:(WYJChartAddress *)user {
    WYJChartMessage *message = [self creatMessageText:@"收到你的消息了"];
    message.byMySelf        = NO;
    message.sendStatus      = SendStatusSuccess;
    message.fromUserId  = user.userId;
    message.toUserId    = [self getCurrentUser].userId;
    
    [message save];
    return message;
}

+ (WYJChartMessage *)creatMessageText: (NSString *)text {
    WYJChartTextCell *cell = [[WYJChartTextCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@""];
    
    WYJChartMessage *msg = [[WYJChartMessage alloc] init];
    msg.content             = text;
    msg.sendStatus          = SendStatusSuccess;
    msg.byMySelf            = YES;
    
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

@end
