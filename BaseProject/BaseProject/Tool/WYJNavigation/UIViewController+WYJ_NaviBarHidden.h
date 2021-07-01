//
//  UIViewController+WYJ_NaviBarHidden.h
//  OmniChannelClient
//
//  Created by ZSXJ on 2018/7/19.
//  Copyright © 2018年 ZSXJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WYJ_NaviBarHidden)

- (BOOL)wyj_naviBarIsHidden;
- (BOOL)wyj_naviPopGRDisable;// 全屏手势禁止 
- (NavigationImitateView *)wyj_naviView;

@end
