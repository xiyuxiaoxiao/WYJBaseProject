//
//  KeyboardTool.m
//  OmniChannelClient
//
//  Created by ZSXJ on 2017/12/8.
//  Copyright © 2017年 ZSXJ. All rights reserved.
//

#import "KeyboardTool.h"

@implementation KeyboardTool

+ (void)keyboardWillShownNotification:(NSNotification *)notification controllerView:(UIView *)view textField:(UITextField *)txtField {
    
    NSLog(@"%@", notification);
    // 获取通知的userInfo属性
    NSDictionary *userInfoDict = notification.userInfo;
    // 通过键盘通知的userInfo属性获取键盘的bounds
    NSValue *value = [userInfoDict objectForKey:UIKeyboardFrameEndUserInfoKey];
    // 键盘的大小
    CGSize keyboardSize = [value CGRectValue].size;
    // 键盘高度
    CGFloat keyboardHeight = keyboardSize.height;
    
    CGRect txtFieldRect = [txtField.superview convertRect:txtField.frame toView:[UIApplication sharedApplication].keyWindow];
    CGFloat txtFieldBottom = txtFieldRect.size.height + txtFieldRect.origin.y;
    CGFloat offset = [UIScreen mainScreen].bounds.size.height - txtFieldBottom - keyboardHeight;
    if (offset < 0 ) { //这种情况下需要上移
        offset = offset - 10 ; //保存上移的高度
        [UIView animateWithDuration:0.5 animations:^{
            view.transform = CGAffineTransformTranslate(view.transform, 0, offset);
        }];
    }
}

+ (void)hideKeyboard:(NSNotification *)notification controllerView:(UIView *)view{
    [UIView animateWithDuration:2 animations:^{
        view.transform = CGAffineTransformIdentity;
    }];
}
@end
