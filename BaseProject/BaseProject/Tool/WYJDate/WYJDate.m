//
//  WYJDate.m
//  BaseProject
//
//  Created by ZSXJ on 2017/4/14.
//  Copyright © 2017年 WYJ. All rights reserved.
//


/**
    不要用NSLog输出来查看NSDate，NSDate本身存的就是UTC时间(无论你怎么换timeZone都不会有变化)，可以将NSDate转换为string来查看，
 (格林尼治时间已经不再被作为标准时间使用。现在的标准时间——协调世界时（UTC）
 
 
 测试：
 -------------------------------------------------------------
 当手机修改为世界标准时间时   当前时间 [NSDate date]
 
    UTC               2017-04-14 06:47:59 +0000
    北京时间(东八区)     2017-04-14 14:47:59 +0000
 
 转换为字符串 都是 相对应的时区的字符串
 
    UTC 时间戳 ：1492152479297（毫秒） --> 转为北京时间：2017/4/14 14:47:59
    （http://tool.chinaz.com/tools/unixtime.aspx  在线转换网址）
 
 虽然 NSDate 是针对当前在打印的时候 使用的是 UTC  但是通过string转化后打印才是正确的

 -------------------------------------------------------------
 */

#import "WYJDate.h"

@implementation WYJDate

#pragma mark - 字符串转时间

/**
 
    // 转化时间  string表示的是 如2017-04-14 13:53:00 就是东八区 北京时间
 
    // 转换为东八区时间的 通过设置时区
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
 
    // 通过添加时间 转换
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    date = [date  dateByAddingTimeInterval: interval];
 
 */

// 这样 对于相互转换不会产生影响 只是生成的date是系统时区  对于需要转换时区的地方 在设置
// NSString --> Date
+(NSDate *)dateWithString:(NSString *)string {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    return [dateFormatter dateFromString:string];
}

// Date --> NSString
+(NSString *)stringWithDate:( NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    return [dateFormatter stringFromDate:date];
}

#pragma mark - 时间戳 
//按照世界标准计算的  不是北京时间  可以通过在线将时间戳转换为北京时间 来对比
+(NSString *)getTimeSp:(NSDate *)date {
    
    UInt64 time = [date timeIntervalSince1970] *1000;
    NSString *timeSp = [NSString stringWithFormat:@"%llu", time];
    NSLog(@"%@",timeSp);
    return timeSp;
}

+(BOOL)isToday:(NSDate *)date {
    NSDate *today = [NSDate date];
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *dateString = [[date description] substringToIndex:10];
    
    if ([todayString isEqualToString:dateString]) {
        return YES;
    }
    return NO;
}

/*
 打印 单个获取 年 月 日 小时 分钟 秒
 必须转化为字符串 在通过indegerValue 判断
 
 
 分开：comps 获取的年月日
    2017-4-14 18:24:30
 */
+(void)dateComponents {
    
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    NSDate *date =[NSDate date];
    // 年月日获得
    comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond)
                       fromDate:date];
//    NSInteger nowYear = [comps year];
    NSLog(@"%@",[self stringWithDate:date]);
    NSLog(@"\n%ld-%ld-%ld %ld:%ld:%ld",
          [comps year],[comps month],[comps day],[comps hour],[comps minute],[comps second]);
}


// 个性化显示时间
+ (NSString *)stringDateUniqueWithTimestamp:(NSString *)timeSp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSp.doubleValue/1000.0];
    
    NSString *dateFormat = @"";
    if ([[NSCalendar currentCalendar] isDateInToday:date]) {
        dateFormat = [NSDateFormatter dateFormatFromTemplate:@"tt hh:mm" options:0 locale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    }else {
        dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd tt hh:mm" options:0 locale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringDateConversationListTime: (NSString *)timeSp {
    
    UInt64 nowTime = [[NSDate date] timeIntervalSince1970];
    CGFloat time = timeSp.doubleValue/1000;
    
    CGFloat offset = nowTime - time;
    if (offset < 60) {
        return @"刚刚";
    }
    if (offset < 60*60) {
        int n = (int) (offset/60);
        return [NSString stringWithFormat:@"%d分钟前",n];
    }

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    if ([[NSCalendar currentCalendar] isDateInYesterday:date]) {
        return @"昨天";
    }

    if (offset < 24*60*60) {
        int n = (int) (offset/60*60);
        return [NSString stringWithFormat:@"%d小时前",n];
    }

    if (offset < 30*24*60*60) {
        int n = (int) (offset/24*60*60);
        return [NSString stringWithFormat:@"%d天前",n];
    }
    
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:date];
}
@end
