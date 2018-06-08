//
//  MBProgressHUD+DIY.m
//  OmniChannelClient
//
//  Created by ZXH on 16/6/7.
//  Copyright © 2016年 ZSXJ. All rights reserved.
//

#import "MBProgressHUD+DIY.h"

@implementation MBProgressHUD (DIY)

+ (void)showMessageOnly:(NSString *)text toView:(UIView*)view hideAfterDelay:(NSTimeInterval)delay {

    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    hud.margin = 20.0F;

    
    hud.removeFromSuperViewOnHide = YES;// 隐藏时候从父控件中移除
    
    [hud hide:YES afterDelay:delay];
}


/**
 *  网络加载状态，并显示一些信息，需要手动关闭
 *  @param message 信息内容
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showLodingProgressHUD:(NSString *)message {
    
    return [self showLodingProgressHUD:message toView:nil];
}

/**
 *  网络加载状态，并显示一些信息，需要手动关闭
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showLodingProgressHUD:(NSString *)message toView:(UIView *)view {
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;    // 隐藏时从父控件中移除
    hud.dimBackground = NO;     // YES代表需要蒙版效果
    return hud;
}

// 提示加载成功 并hide
- (void)hideHUDWithSuccessMessage:(NSString *)message afterDelay:(NSTimeInterval)delay {
    self.labelText = message;
    self.mode = MBProgressHUDModeCustomView;
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
    [self hide:YES afterDelay:delay];
}
// 提示加载失败 并hide
- (void)hideHUDWithErrorMessage:(NSString *)message afterDelay:(NSTimeInterval)delay {
    self.labelText = message;
    self.mode = MBProgressHUDModeCustomView;
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
    [self hide:YES afterDelay:delay];
}

@end
