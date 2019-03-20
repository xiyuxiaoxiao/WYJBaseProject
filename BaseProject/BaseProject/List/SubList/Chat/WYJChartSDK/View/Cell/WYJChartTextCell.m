//
//  WYJChartTextCell.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/23.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartTextCell.h"

@implementation WYJChartTextCell

- (UIImageView *)contentBackView {
    if (_contentBackView == nil) {
        _contentBackView = [[UIImageView alloc] init];
        
        _contentBackView.tintColor = [UIColor greenColor];
        
        if (self.left) {
             _contentBackView.tintColor = [UIColor whiteColor];
            _contentBackView.image = [[[UIImage imageNamed:@"Text Voice Bubble Incoming"] stretchableImageWithLeftCapWidth:20 topCapHeight:22]
                                      imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
        }else {
            _contentBackView.image = [[[UIImage imageNamed:@"Text Voice Bubble Outgoing"] stretchableImageWithLeftCapWidth:20 topCapHeight:22]
                                      imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
        }
    }
    return _contentBackView;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor         = [UIColor blackColor];
        _messageLabel.textAlignment     = NSTextAlignmentLeft;
        _messageLabel.font              = [UIFont systemFontOfSize:12];
        _messageLabel.numberOfLines     = 0;
        [self setupTap:_messageLabel];
    }
    return _messageLabel;
}

- (void)setFrame {
    [super setFrame];
    
    [self addSubview:self.contentBackView];
    [self addSubview:self.messageLabel];
}

- (void)setContentBackFrame: (CGSize)contentSize {
    CGFloat w = contentSize.width;
    CGFloat h = contentSize.height;
    CGFloat y = CGRectGetMinY(self.iconView.frame);
    CGFloat x = 0;
    
    if (self.left) {
        x = CGRectGetMaxX(self.iconView.frame) + 8;
    }else {
        x = CGRectGetMinX(self.iconView.frame) - w - 8;
    }
    self.contentBackView.frame = CGRectMake(x, y, w, h);
    
    self.messageLabel.frame = self.contentBackView.frame;
    
    CGFloat x_message = x;
    CGFloat y_message = y + 7;
    CGFloat w_message = w - 25;
    CGFloat h_message = h - 14;
    
    if (self.left) {
        x_message += 15;
    }else {
        x_message += 10;
    }
    
    self.messageLabel.frame = CGRectMake(x_message, y_message, w_message, h_message);
}

- (void)setMessage:(WYJChartMessage *)message {
    [super setMessage:message];
    
    self.messageLabel.text = message.content;
    [self setContentBackFrame:message.contentBackSize];
    
    [super setFailureFrameWithContentFrame:self.contentBackView.frame];
}

@end
