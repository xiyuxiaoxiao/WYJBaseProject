//
//  WYJChartConversationCell.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/30.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartConversationCell.h"
#import "WYJChartDefine.h"
#import "WYJChartConversation.h"
#import "WYJChartAddress.h"

@interface WYJChartConversationCell ()
//头像
@property (nonatomic, strong) UIImageView *iconView;
//时间
@property (nonatomic, strong) UILabel *timeLabel;
//用户名
@property (nonatomic, strong) UILabel *nameLabel;
//消息
@property (nonatomic, strong) UILabel *messageLabel;

//countLabel
@property (nonatomic, strong) UILabel *countLabel;
@end

@implementation WYJChartConversationCell

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.backgroundColor = [UIColor yellowColor];
    }
    return _iconView;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font             = [UIFont systemFontOfSize:14];
        _timeLabel.textAlignment    = NSTextAlignmentRight;
    }
    return _timeLabel;
}
- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font      = [UIFont systemFontOfSize:14];
        _messageLabel.textColor = [UIColor darkGrayColor];
    }
    return _messageLabel;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:17];
    }
    return _nameLabel;
}
- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font            = [UIFont systemFontOfSize:13];
        _countLabel.textColor       = [UIColor whiteColor];
        _countLabel.textAlignment   = NSTextAlignmentCenter;
        _countLabel.backgroundColor = [UIColor redColor];
    }
    return _countLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setFrame];
    }
    return self;
}

- (void)setFrame {
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.messageLabel];
    
    self.iconView.frame = CGRectMake(15, 0, 45, 45);
    
    CGFloat x_name = CGRectGetMaxX(self.iconView.frame) + 25;
    CGFloat h_name = CGRectGetHeight(self.iconView.frame)/2;
    CGFloat w_name = WYJScreenWidth - x_name;
    self.nameLabel.frame    = CGRectMake(x_name, 0, w_name, h_name);
    self.messageLabel.frame = CGRectMake(x_name, h_name, w_name, h_name);
    
    
    self.timeLabel.text = @"01-10 18:20";
    CGSize size_time = [self.timeLabel sizeThatFits:CGSizeMake(MAXFLOAT, 30)];
    self.timeLabel.text = nil;
    
    CGFloat w_time = size_time.width;
    CGFloat x_time = WYJScreenWidth - 20 - w_time;
    CGFloat h_time = size_time.height;
    CGFloat y_time = CGRectGetMidY(self.iconView.frame) - h_time/2;
    self.timeLabel.frame = CGRectMake(x_time, y_time, w_time, h_time);
    
    
    [self.iconView addSubview:self.countLabel];
    
    CGFloat x_count = self.iconView.frame.size.width - 15/2.0;
    self.countLabel.frame = CGRectMake(x_count , 0, 15, 15);
    self.countLabel.layer.cornerRadius = 15/2.0;
    self.countLabel.layer.masksToBounds = YES;
}


+ (CGFloat)cellHeight {
    return 70;
}

- (void)setConversation:(WYJChartConversation *)conversation {
    self.nameLabel.text = conversation.partnerUser.name;
    self.messageLabel.text = conversation.lastMessage;
    self.timeLabel.text = @"01-10 18:20";
    
    self.countLabel.text = [NSString stringWithFormat:@"%d",conversation.unreadCount];
    self.countLabel.hidden = conversation.unreadCount > 0 ? NO : YES;
}

@end
