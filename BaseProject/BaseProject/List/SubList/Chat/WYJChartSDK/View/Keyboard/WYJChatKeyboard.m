//
//  WYJChatKeyboard.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/24.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChatKeyboard.h"
#import "WYJChartDefine.h"
#import "WYJPhoto.h"
#import "UIImage+WYJChartImageStore.h"
#import "ChatMorePanel.h"

@interface WYJChatKeyboard ()<UITextViewDelegate>
{
    CGFloat keyboardHeight;             // 记录键盘高度
    CGFloat messageBarHeight;           // 消息上边背景实际高度
    CGFloat messageBarDefaultHeight;    // 消息上边背景默认高度
    CGFloat msgTextTop;                 // 文本上下间距
    CGRect  originFrame;                // view开始位置
}
@property (nonatomic, strong) UIView *      messageBar;
@property (nonatomic, strong) UITextView *  msgTextView;
@property (nonatomic, strong) UIButton *    swtHandleButton;
@property (nonatomic, strong) ChatMorePanel* morePanel;
@end

@implementation WYJChatKeyboard

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//输入栏
- (UIView *)messageBar
{
    if (!_messageBar) {
        _messageBar = [[UIView alloc]init];
        _messageBar.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        [_messageBar addSubview:self.msgTextView];
        [_messageBar addSubview:self.swtHandleButton];
    }
    return _messageBar;
}

//输入框
- (UITextView *)msgTextView
{
    if (!_msgTextView) {
        _msgTextView = [[UITextView alloc]init];
        _msgTextView.font = [UIFont systemFontOfSize:14];
        _msgTextView.showsVerticalScrollIndicator = NO;
        _msgTextView.showsHorizontalScrollIndicator = NO;
        _msgTextView.returnKeyType = UIReturnKeySend;
        _msgTextView.enablesReturnKeyAutomatically = YES;
        _msgTextView.delegate = self;
        _msgTextView.layer.cornerRadius = 5;
        //观察者监听高度变化
        [_msgTextView addObserver:self
                       forKeyPath:@"contentSize"
                          options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                          context:nil];
    }
    return _msgTextView;
}

//切换操作键盘
- (UIButton *)swtHandleButton
{
    if (!_swtHandleButton) {
        _swtHandleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_swtHandleButton setImage:[UIImage imageNamed:@"Add Chat"] forState:UIControlStateNormal];
        [_swtHandleButton addTarget:self action:@selector(switchHandleKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _swtHandleButton;
}

- (ChatMorePanel *)morePanel {
    if (!_morePanel) {
        _morePanel = [[ChatMorePanel alloc] initWithFrame:CGRectMake(0, 49, WYJScreenWidth, 187)];
        [self addSubview:_morePanel];
        
        __weak typeof(self) weakSelf = self;
        _morePanel.itemTap = ^(ChatMoreItem * _Nonnull moreItem) {
            [weakSelf moreItemTap:moreItem];
        };
    }
    return _morePanel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        keyboardHeight              = 0;
        messageBarDefaultHeight     = 49;
        msgTextTop                  = 8;
        messageBarHeight            = messageBarDefaultHeight;
        
        originFrame = frame;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.messageBar];
        [self configUIFrame];
    }
    return self;
}
// 主要是 为了记录初次设置的frame
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self delegateRespondsSelector:@selector(keyBoardFrameChange)];
    
    if (originFrame.size.height == 0) {
        originFrame = frame;
    }
}

#pragma mark - 初始化布局
- (void)configUIFrame {
    
    //系统键盘弹起通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(systemKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
    CGFloat h_messageBar = messageBarHeight;
    
    self.messageBar.frame = CGRectMake(0, 0, WYJScreenWidth, h_messageBar);
    
    CGFloat h_swHandle = 30;
    CGFloat y_swHandle = (h_messageBar - h_swHandle)/2;
    CGFloat x_swHandle = WYJScreenWidth - h_swHandle - 15;
    self.swtHandleButton.frame = CGRectMake(x_swHandle, y_swHandle, h_swHandle, h_swHandle);
    
    CGFloat x_msgText = 15;
    CGFloat w_msgText = x_swHandle - 15 - x_msgText;
    self.msgTextView.frame = CGRectMake(x_msgText, msgTextTop, w_msgText, h_messageBar - msgTextTop*2);
}

#pragma mark - 键盘弹起
- (void)systemKeyboardWillShow: (NSNotification *)notification{
    //获取系统键盘高度
    CGFloat systemKbHeight  = [notification.userInfo[@"UIKeyboardBoundsUserInfoKey"]CGRectValue].size.height;
    //记录系统键盘高度
    keyboardHeight = systemKbHeight;
    
    [self resetFrameWithAnimation:YES];
}

#pragma mark - 设置frame

- (void)resetFrameWithAnimation: (BOOL)animation{
    // 初始的时候距离底部的间距
    CGFloat bottom = WYJScreenHeight - NavaBar_StatusHeight - originFrame.origin.y - messageBarDefaultHeight;
    
    // 键盘弹出后 需要上移动的间距
    CGFloat h_over_bottom = keyboardHeight - bottom;
    if (h_over_bottom < 0) {
        h_over_bottom = 0;
    }
    
    CGFloat h_over_message = messageBarHeight - messageBarDefaultHeight;
    if (h_over_message < 0) {
        h_over_message = 0;
    }
    
    // 文本高出的间距
    CGFloat h_over       = h_over_message + h_over_bottom;
    CGRect frame         = originFrame;
    frame.origin.y      -= h_over;
    frame.size.height   += h_over;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = frame;
    }];
}

#pragma mark - 输入框高度调整
- (void)msgTextViewHeightFit:(CGFloat)msgViewHeight
{
    CGRect selfFrame = self.frame;
    
    CGFloat offset = (msgViewHeight - self.msgTextView.frame.size.height);
    NSLog(@"frame:%@",@(self.msgTextView.frame));
    NSLog(@"%f",offset);
    if (offset == 0) {
        return;
    }
    selfFrame.origin.y -= offset;
    selfFrame.size.height += offset;
    self.frame = selfFrame;
    
    CGRect messagebarFrame = self.messageBar.frame;
    messagebarFrame.size.height += offset;
    self.messageBar.frame = messagebarFrame;
    
    CGRect msgFrame = self.msgTextView.frame;
    msgFrame.size.height += offset;
    self.msgTextView.frame = msgFrame;
    
    messageBarHeight = messagebarFrame.size.height;
    
    
    CGRect morePanelFrame = self.morePanel.frame;
    morePanelFrame.origin.y = messageBarHeight;
    self.morePanel.frame =morePanelFrame;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat oldHeight  = [change[@"old"]CGSizeValue].height;
        CGFloat newHeight = [change[@"new"]CGSizeValue].height;
        if (oldHeight <=0 || newHeight <=0) return;
        if (oldHeight != newHeight) {
            CGFloat msgTextDefaultheight = messageBarDefaultHeight - msgTextTop *2;
            CGFloat inputHeight = newHeight > msgTextDefaultheight ? newHeight : msgTextDefaultheight;
            
            UITextView *textView = object;
            CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)];
            if (size.height > newHeight) {
                return;
            }
            [self msgTextViewHeightFit:inputHeight];
        }
    }
}

#pragma mark - textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self delegateRespondsSelector:@selector(sendMessageText:) object:textView.text];
        textView.text = nil;
        return NO;
    }
    return YES;
}

#pragma mark - 按钮

- (void)endEdit {
    
    if (keyboardHeight > 0) {
        [self.msgTextView resignFirstResponder];
        keyboardHeight = 0;
        [self resetFrameWithAnimation:YES];
        self.morePanel.hidden = YES;
    }
}

// 键盘
- (void)switchHandleKeyboard: (UIButton *)sender{
    self.morePanel.hidden = NO;
    [self.msgTextView resignFirstResponder];
    keyboardHeight = self.morePanel.frame.size.height;
    [self resetFrameWithAnimation:YES];
}

- (void)moreItemTap: (ChatMoreItem *)item {
    if (item.type == 0) {
        return;
    }
    if (item.type == 1) {
        [WYJPhoto getPhoto:^(UIImage * _Nonnull img) {
            [self delegateRespondsSelector:@selector(sendMessageImage:) object:img];
        }];
        return;
    }
    if (item.type == 3) {
        NSLog(@"发送优惠券");
        return;
    }
    if (item.type == 4) {
        NSLog(@"点击了快捷回复");
        return;
    }
}

- (void)delegateRespondsSelector:(SEL)selector {
    if ([self.delegate respondsToSelector:selector]) {
        [self.delegate performSelector:selector];
    }
}

- (void)delegateRespondsSelector:(SEL)selector object:(NSObject *)object{
    if ([self.delegate respondsToSelector:selector]) {
        [self.delegate performSelector:selector withObject:object withObject:object];
    }
}

@end
