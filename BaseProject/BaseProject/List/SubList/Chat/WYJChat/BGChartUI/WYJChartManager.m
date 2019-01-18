//
//  WYJChartManager.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/16.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartManager.h"
#import "WYJChartAddress.h"

@implementation WYJChartManager

+ (void)initDataAddressList {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        WYJChartAddress *list = [[WYJChartAddress alloc] init];
        list.userId = [@"userID_" stringByAppendingFormat:@"%d",i];
        list.name = [@"name" stringByAppendingFormat:@"%d",i];
        [array addObject:list];
    }
    
    [WYJChartAddress bg_saveOrUpdateArray:array];
}

+ (void)addAddressList {
    
    int i = 1;
    
    WYJChartAddress *list = [[WYJChartAddress alloc] init];
    list.userId = [@"userID_00" stringByAppendingFormat:@"%d",i];
    list.name = [@"name00" stringByAppendingFormat:@"%d",i];
    
    [list bg_saveOrUpdate];
}

@end
