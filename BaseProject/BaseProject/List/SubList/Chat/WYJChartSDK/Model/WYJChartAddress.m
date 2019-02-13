//
//  WYJChartAddress.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/15.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartAddress.h"

@implementation WYJChartAddress

+ (NSArray *)bg_uniqueKeys {
    return @[@"userId"];
}

+ (void)addNewFriendWithName:(NSString *)name {
    WYJChartAddress *list = [[WYJChartAddress alloc] init];
    list.userId = [WYJDate getTimeSp:[NSDate date]];
    list.name   = name;
    [list saveOrUpdate];
}

- (BOOL)save {
    if ([super save]) {
        [[ChartDatabaseManager share] newAddress:self];
        return YES;
    }
    return NO;
}
- (BOOL)saveOrUpdate {
    if([super saveOrUpdate]) {
        [[ChartDatabaseManager share] newAddress:self];
        return YES;
    }
    return NO;
}
@end
