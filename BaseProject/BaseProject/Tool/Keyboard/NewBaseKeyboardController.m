//
//  NewBaseKeyboardController.m
//  OmniChannelClient
//
//  Created by ZSXJ on 2017/12/11.
//  Copyright © 2017年 ZSXJ. All rights reserved.
//

#import "NewBaseKeyboardController.h"
#import "KeyboardTool.h"

@interface NewBaseKeyboardController ()<UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UITextField *currentTextField;
@end

@implementation NewBaseKeyboardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserverKeyBoard];
}

#pragma mark Textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.currentTextField = textField;
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.currentTextField = (UITextField *)textView;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.currentTextField == textView) {
        self.currentTextField = nil;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.currentTextField == textField) {
        self.currentTextField = nil;
    }
}

- (void)resignCurrentResponder {
    [self.currentTextField resignFirstResponder];
}

#pragma mark 监听键盘
- (void)addObserverKeyBoard {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideKeyboard:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShown:(NSNotification *)notification{
    
    [KeyboardTool keyboardWillShownNotification:notification controllerView:self.view textField:self.currentTextField];
}

-(void)hideKeyboard:(NSNotification *)notification{
    [UIView animateWithDuration:2 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}
//- (void)keyboardWillShown {
//    if ([self.class scrollViewDidScrollResignFirstResponse]) {
//        self.willShowKeyboard = YES;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.willShowKeyboard = NO;
//        });
//    }
//}
#pragma mark - scrollView Delegate
// 在当前代理中会崩溃的 当text过长 隐藏键盘 也不用使用self.willShowKeyboard 存储键盘状态 否则会出现
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if ([self.class scrollViewDidScrollResignFirstResponse]) {
//        if (self.willShowKeyboard == NO) {
//            [self resignCurrentResponder];
//        }
//    }
//}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.class scrollViewDidScrollResignFirstResponse]) {
        [self resignCurrentResponder];
    }
}
#pragma mark keyboard scrollResign
+ (BOOL)scrollViewDidScrollResignFirstResponse {
    return NO;
}

#pragma mark - super
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self resignCurrentResponder];
    // 有可能 当前键盘不是 self.currentTextField
    if (self.currentTextField) {
        self.view.transform = CGAffineTransformIdentity;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resignCurrentResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
