//
//  DownLoadTool.h
//  BaseProject
//
//  Created by ZSXJ on 2017/4/24.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// double:进度   Bool：下载完成
typedef void(^ProgressDownLoad)(double,BOOL);


@interface DownLoadTool : NSObject
@property (nonatomic, copy)     NSString *          downPath;
@property (nonatomic, strong)   NSURL *             url;
@property (nonatomic, copy)     ProgressDownLoad    block;

-(void)downLoad;
+ (void)creatByUrl:(NSString *)url filePath:(NSString *)filePath block:(ProgressDownLoad)block;

@end
