//
//  WYJChartCellTool.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/23.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartCellTool.h"
#import "WYJChartTextCell.h"

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


+ (NSMutableArray *)testArray {
    
    NSMutableArray *array = [NSMutableArray array];
    
    WYJChartTextCell *cell = [[WYJChartTextCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@""];
    
    for (int i = 0; i < 30; i++) {
        WYJChartMessage *msg = [[WYJChartMessage alloc] init];
        
        if (i % 3 == 1) {
            msg.content = @"艰苦奋斗是家乐福会计师对方考虑尽快了";
            msg.sendStatus = SendStatusFaile;
        }
        else if (i % 3 == 2){
            msg.content = @"富甲一方，生龙活虎，幸福美满，富甲一方，生龙活虎，幸福美满，富甲一方，生龙活虎，幸福美满---- 福克斯 分开来反馈";
            msg.sendStatus = SendStatusSending;
        }
        else {
            msg.content = @"富甲一方";
            msg.sendStatus = SendStatusSuccess;
        }
        cell.messageLabel.text = msg.content;
        
        if (i < 10) {
            msg.byMySelf = YES;
        }else {
            msg.byMySelf = NO;
        }
        
        [WYJChartCellTool setCellheight:msg];
        [array addObject:msg];
    }
    
    return array;
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

+ (WYJChartMessage *)receiveMessageText: (NSString *)text {
    WYJChartTextCell *cell = [[WYJChartTextCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@""];
    
    WYJChartMessage *msg = [[WYJChartMessage alloc] init];
    msg.content             = text;
    msg.sendStatus          = SendStatusSuccess;
    msg.byMySelf            = NO;
    cell.messageLabel.text  = msg.content;
    [WYJChartCellTool setCellheight:msg];
    
    return msg;
}

@end
