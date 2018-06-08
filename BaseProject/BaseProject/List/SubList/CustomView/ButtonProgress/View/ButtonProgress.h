//
//  ButtonProgress.h
//  BaseProject
//
//  Created by ZSXJ on 2017/7/12.
//  Copyright © 2017年 WYJ. All rights reserved.
//

// transform 会使得圆角度变化
// view.transform=CGAffineTransformMakeScale(0.2667, 1);

/*
 UIViewAnimationCurveEaseInOut: 动画先缓慢，然后逐渐加速。
 UIViewAnimationOptionCurveEaseIn ：动画逐渐变慢。
 UIViewAnimationOptionCurveEaseOut：动画逐渐加速。
 */

#import <UIKit/UIKit.h>

@interface ButtonProgress : UIView

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)setText:(NSString *)text;

- (void)startAction;
- (void)endActionSuccess:(BOOL)success message:(NSString *)message;
@end
