//
//  WYJButton.h
//  使用UIControl自定义button控件
//
//  Created by ZSXJ on 2019/8/19.
//  Copyright © 2019年 WYJ. All rights reserved.
/*
    只是为了测试 使用control自定义 具体实现的功能并不全面 了解原理
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYJButton : UIControl
- (void)setTitle:(nullable NSString *)title forState:(UIControlState)state;
@end

NS_ASSUME_NONNULL_END
