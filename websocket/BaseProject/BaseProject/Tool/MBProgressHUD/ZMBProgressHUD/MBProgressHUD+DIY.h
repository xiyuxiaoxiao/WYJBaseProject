//
//  MBProgressHUD+DIY.h
//  OmniChannelClient
//
//  Created by ZXH on 16/6/7.
//  Copyright © 2016年 ZSXJ. All rights reserved.
//

#import "MBProgressHUD.h"
@interface MBProgressHUD (DIY)
// 仅显示文字提示
+ (void)showMessageOnly:(NSString *)text toView:(UIView*)view hideAfterDelay:(NSTimeInterval)delay;

// 网络请求加载时，需要手动关闭
+ (MBProgressHUD *)showLodingProgressHUD:(NSString *)message toView:(UIView *)view;
// 1、手动关闭: 加载成功时，提示，并hide
- (void)hideHUDWithSuccessMessage:(NSString *)message afterDelay:(NSTimeInterval)delay;
// 2、手动关闭: 加载失败时，提示，并hide
- (void)hideHUDWithErrorMessage:(NSString *)message afterDelay:(NSTimeInterval)delay;

@end
