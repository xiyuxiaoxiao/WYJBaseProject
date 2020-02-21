//
//  WYJChartConversationCell.m
//  BaseProject
//
//  Created by ZSXJ on 2020/2/20.
//  Copyright © 2020 WYJ. All rights reserved.
//

#import "WYJChartConversationCell.h"
#import "WYJChartDefine.h"
#import "WYJChartConversation.h"
#import "WYJChartAddress.h"

@interface WYJChartConversationCell ()
//头像
@property (nonatomic, weak) IBOutlet UIImageView *iconView;
//时间
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
//用户名
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
//等级
@property (nonatomic, weak) IBOutlet UILabel *gradeLabel;
//消息
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;

//countLabel
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@end


@implementation WYJChartConversationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconView.layer.cornerRadius = 6;
    self.iconView.backgroundColor = [UIColor yellowColor];
    self.countLabel.layer.cornerRadius = 9;
    self.countLabel.layer.masksToBounds = YES;
}


- (void)setConversation:(WYJChartConversation *)conversation {
    self.nameLabel.text     = conversation.partnerUser.name;
    self.messageLabel.text  = conversation.lastMessage;
    self.timeLabel.text     = [WYJDate stringDateConversationListTime:conversation.lastTimeString];
    
    self.countLabel.text    = [NSString stringWithFormat:@"%d",conversation.unreadCount];
    self.countLabel.hidden  = conversation.unreadCount > 0 ? NO : YES;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:conversation.partnerUser.portraitURL] completed:nil];
}

+ (CGFloat)cellHeight {
    return 70;
}

@end
