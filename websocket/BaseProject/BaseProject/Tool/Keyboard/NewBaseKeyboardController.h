//
//  NewBaseKeyboardController.h
//  OmniChannelClient
//
//  Created by ZSXJ on 2017/12/11.
//  Copyright © 2017年 ZSXJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewBaseKeyboardController : UIViewController

- (void)resignCurrentResponder;

// 键盘弹出后 需要做的事情 （如 列表中含有文本框的 在scrollview 滑动是 需要隐藏键盘的 文本框在最下面时会有冲突 可以重写下面方法 定义一个 属性 延时判断  参考一下库存管理）

+ (BOOL)scrollViewDidScrollResignFirstResponse;
- (BOOL)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textViewShouldEndEditing:(UITextView *)textView;

@end
