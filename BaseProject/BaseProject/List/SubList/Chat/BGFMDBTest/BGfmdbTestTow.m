//
//  BGfmdbTestTow.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/14.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "BGfmdbTestTow.h"

@implementation BGfmdbTestTow
+ (void)saveTestObject {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 100000; i++) {
        BGfmdbTestTow *list = [[BGfmdbTestTow alloc] init];
        list.userId = [@"userID_" stringByAppendingFormat:@"%d",i];
        list.name = [@"name" stringByAppendingFormat:@"%d",i];
        //        list.sex = i%2 == 0? @"男":@"女";
        [array addObject:list];
    }
    
    NSLog(@"开始时间");
    
    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    
    [BGfmdbTestTow bg_saveOrUpdateArrayAsync:array complete:^(BOOL isSuccess) {
        if (isSuccess) {
            NSLog(@"成功");
        }else {
            NSLog(@"失败");
        }
        
        CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSLog(@"Linked in %f ms", linkTime *1000.0);
    }];
}
@end
