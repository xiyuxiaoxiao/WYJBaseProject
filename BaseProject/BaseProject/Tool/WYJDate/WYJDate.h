//
//  WYJDate.h
//  BaseProject
//
//  Created by ZSXJ on 2017/4/14.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYJDate : NSObject

+(NSDate *)dateWithString:(NSString *)string;
+(NSString *)stringWithDate:( NSDate *)date;
+(NSString *)getTimeSp:(NSDate *)date;
+(BOOL)isToday:(NSDate *)date;

// 个性化显示时间
+ (NSString *)stringDateUniqueWithTimestamp:(NSString *)timeSp;
+ (NSString *)stringDateConversationListTime: (NSString *)timeSp;
@end
