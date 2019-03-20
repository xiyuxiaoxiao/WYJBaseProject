//
//  WYJFileTool.m
//  BaseProject
//
//  Created by ZSXJ on 2019/3/19.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJFileTool.h"

@implementation WYJFileTool

+ (NSString *)filePathDocument {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingString:@"/WyjSource/image/"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

// 创建本地路径
+ (NSString *)creatFileName {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss-SSS-"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    int num = arc4random() % 10000;
    NSString *str =[NSString stringWithFormat:@"%@%d.png",dateStr,num];
    return str;
}

+ (NSString *)fileNameWithURL: (NSString *)url {
    return [[SDImageCache sharedImageCache] cachePathForKey:url inPath:@""];
}


@end
