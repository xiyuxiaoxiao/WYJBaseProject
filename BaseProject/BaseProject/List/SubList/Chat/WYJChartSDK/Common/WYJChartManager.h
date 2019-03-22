//
//  WYJChartManager.h
//  BaseProject
//
//  Created by ZSXJ on 2019/3/22.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WYJChartAddress;

@interface WYJChartManager : NSObject

+ (void)setCurrentChartUser: (WYJChartAddress *)user;
+ (BOOL)isReadMessageByUserId: (NSString *)userId;

@end
