//
//  WYJChartBaseCell.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/23.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartBaseCell.h"

@implementation WYJChartBaseCell

//菊花
- (UIActivityIndicatorView *)activiView
{
    if (!_activiView) {
        _activiView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activiView.color = [UIColor darkGrayColor];
    }
    return _activiView;
}

- (UIButton *)failureButton
{
    if (!_failureButton) {
        _failureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_failureButton setImage:[UIImage imageNamed:@"Failed To Send"] forState:UIControlStateNormal];
        [_failureButton addTarget:self action:@selector(sendAgain) forControlEvents:UIControlEventTouchUpInside];
        _failureButton.hidden = YES; //默认隐藏
    }
    return _failureButton;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor        = [UIColor blueColor];
        _timeLabel.textAlignment    = NSTextAlignmentCenter;
        _timeLabel.font             = [UIFont systemFontOfSize:12];
        _timeLabel.text             = @"12:18";
    }
    return _timeLabel;
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.userInteractionEnabled = YES;
        _iconView.backgroundColor = [UIColor redColor];
        _iconView.layer.cornerRadius = 18;
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            _iconView.layer.cornerRadius = 25;
//        });
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toUserInfo)];
//        [_iconView addGestureRecognizer:tap];
//        //头像长按
//        UILongPressGestureRecognizer *iconLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(iconLongPress:)];
//        [_iconView addGestureRecognizer:iconLongPress];
    }
    return _iconView;
}

// 对 reuseIdentifier 的使用 添加要求 例如注册的时候 后面拼接 _left  _right
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor yellowColor];
        
        self.left = NO;
        if ([reuseIdentifier hasSuffix:@"_left"]) {
            self.left = YES;
        }
        [self setFrame];
    }
    return self;
}

- (void)setFrame {
    [self addSubview:self.timeLabel];
    [self addSubview:self.iconView];
    [self addSubview:self.failureButton];
    [self addSubview:self.activiView];
    
    self.timeLabel.frame = CGRectMake(0, 0, WYJChartCellWidth,20);
    
    [self setIconFrame];
}

- (void)setIconFrame {
    CGFloat w_icon = 36;
    CGFloat h_icon = 36;
    CGFloat y_icon = CGRectGetMaxY(self.timeLabel.frame);
    CGFloat x_icon = 0;
    if (self.left == NO) {
        x_icon = WYJChartCellWidth - w_icon;
    }
    self.iconView.frame = CGRectMake(x_icon, y_icon, w_icon, h_icon);
}

// 设置setFailureFrame 的frame
- (void)setFailureFrameWithContentFrame:(CGRect)contentFrame {
    
    CGFloat w = 22;
    CGFloat h = 22;
    CGFloat x = 0;
    CGFloat y = CGRectGetMidY(contentFrame) - h/2;
    
    if (self.left) {
        x = CGRectGetMaxX(contentFrame) + 8;
    }else {
        x = CGRectGetMinX(contentFrame) - w - 8;
    }
    
    self.failureButton.frame = CGRectMake(x, y, w, h);
    self.activiView.frame = self.failureButton.frame;
}

- (void)setMessage:(WYJChartMessage *)message {
    _message = message;
    
    // 如果按照 cell的left来判断 对与设计上 不符合 对象的处理 所以需要通过对象来设置是否展示相关控件
    if (!message.byMySelf) {
        self.failureButton.hidden = YES;
        self.activiView.hidden = YES;
        return;
    }
    
    if (message.sendStatus == SendStatusSending) {
        self.failureButton.hidden = YES;
        self.activiView.hidden = NO;
        [self.activiView startAnimating];
    }
    else if (message.sendStatus == SendStatusFaile) {
        self.activiView.hidden = YES;
        self.failureButton.hidden = NO;
    }else {
        self.activiView.hidden = YES;
        self.failureButton.hidden = YES;
    }
}

- (void)setFrame:(CGRect)frame {
    frame.size.height   -= 20;
    frame.size.width    -= 40;
    frame.origin.x      += 20;
    [super setFrame:frame];
}

#pragma mark - Action
- (void)sendAgain {
    
    [self delegateRespondsSelector:@selector(resendMessage:) object:self];
    
    // 重新发送
    WYJChartMessage *message = self.message;
    message.sendStatus = SendStatusSending;
    [self setMessage:message];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        message.sendStatus = SendStatusSuccess;
        message.content = @"哈哈哈！！！";
        // cell重用
        if ([message isEqual: self.message]) {        
            [self setMessage:message];
        }
    });
}

- (void)delegateRespondsSelector:(SEL)selector object:(NSObject *)object{
    if ([self.delegate respondsToSelector:selector]) {
        [self.delegate performSelector:selector withObject:object withObject:nil];
    }
}
@end