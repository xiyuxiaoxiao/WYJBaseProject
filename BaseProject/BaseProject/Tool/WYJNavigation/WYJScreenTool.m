//
//  WYJScreenTool.m
//  BaseProject
//
//  Created by 潇雨 on 2021/7/1.
//  Copyright © 2021 WYJ. All rights reserved.
//

#import "WYJScreenTool.h"

@implementation WYJScreenTool

+ (instancetype)sharedInstance {
    static WYJScreenTool *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[super allocWithZone: NULL] init];
    });
    return sharedManager;
}
// 防止外部调用alloc 或者 new
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [WYJScreenTool sharedInstance];
}

- (instancetype)init {
    if (self = [super init]) {
        [self initIphoneXSeries];
    }
    return self;
}


- (double)navaBarStatusHeight {
    return self.iphoneX ? 88 : 64;
}


#pragma mark init
- (void)initIphoneXSeries {
    self.iphoneX = NO;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            self.iphoneX = YES;
            return;
        }
    }
}

@end
