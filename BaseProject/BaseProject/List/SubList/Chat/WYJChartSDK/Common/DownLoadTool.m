//
//  DownLoadTool.m
//  BaseProject
//
//  Created by ZSXJ on 2017/4/24.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "DownLoadTool.h"
#import "AFNetworking.h"
@interface DownLoadTool ()
{
    // 下载句柄
    NSURLSessionDownloadTask *_downloadTask;
}
@property (nonatomic, strong)   NSMutableArray *blockArray;

// 正在下载的时候的文件类型 在路径后面添加了 .download 后缀 在下载完毕后 在修改文件名删除后缀
@property (nonatomic, copy)  NSString *downLoadingPath;
@end

@implementation DownLoadTool
- (void)dealloc {
    NSLog(@"--------------------------");
    NSLog(@"%@",self.blockArray);
    NSLog(@"%@",DownLoadManager.allKeys);
}
- (void)setDownPath:(NSString *)downPath {
    _downPath = downPath;
    _downLoadingPath = [NSString stringWithFormat:@"%@.download",downPath];
}

- (void)downLoad
{
    //AFN在下载的时候 不能让本地有数据 不然会导致崩溃
    [[NSFileManager defaultManager] removeItemAtPath:self.downLoadingPath error:nil];
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //3.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    
    //4.下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //打印下下载进度
        double pro = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        NSLog(@"打印下下载进度:%lf",pro);
        
        if (self.block) {
            self.block(pro,NO);
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //设置下载路径，并将文件写入沙盒，最后返回NSURL对象
        return [NSURL fileURLWithPath:self.downLoadingPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"完成：%@--%@",response,filePath);
        NSHTTPURLResponse *response1 = (NSHTTPURLResponse *)response;
        NSInteger statusCode = [response1 statusCode];
        if (statusCode == 200) {
            //
        }else{
            //  
        }
        
        // 重新命名文件
        [[NSFileManager defaultManager] moveItemAtPath:self.downLoadingPath toPath:self.downPath error:nil];
        
        if (self.block) {
            self.block(1,YES);
        }
        
         NSString *key = [DownLoadTool downLoadKeyUrl:self.url.absoluteString filePath:self.downPath];
        [DownLoadManager removeObjectForKey:key];
        
    }];  
    
    //5.开始启动下载任务
    [task resume];
    
}


static NSMutableDictionary *DownLoadManager;

+ (NSString *)downLoadKeyUrl:(NSString *)url filePath:(NSString *)filePath {
    return [url stringByAppendingString:filePath];
}

/*
+ (void)creatByUrl:(NSString *)url filePath:(NSString *)filePath block:(ProgressDownLoad)block{
    
    DownLoadTool *downTool  = [[DownLoadTool alloc] init];
    downTool.url            = [NSURL URLWithString:url];
    downTool.downPath       = filePath;
    downTool.block          = block;
    
    [downTool downLoad];
}
*/
+ (void)creatByUrl:(NSString *)url filePath:(NSString *)filePath block:(ProgressDownLoad)block{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DownLoadManager = [[NSMutableDictionary alloc] init];
    });
    
    // 因为是 url 和 file同时决定 是否需要重新下载 所以需要判断 (按照道理来说 聊天的URL是不可能重复的 因为每个URL都是单独存储的 即使内容一致 所以需要file也可以 只不过目前测试URL 采用一个 所以不可以重复，为了避免可能重复 所以采用拼接作为key)
    NSString *key = [self downLoadKeyUrl:url filePath:filePath];
    DownLoadTool *tool;
    if ([DownLoadManager valueForKey:key]) {
        tool = [DownLoadManager valueForKey:key];
        
    }else {
        tool = [[DownLoadTool alloc] init];
        tool.blockArray = [NSMutableArray array];
        tool.url = [NSURL URLWithString:url];
        tool.downPath = filePath;
        
        __weak typeof(DownLoadTool *) weakTool = tool;
        tool.block = ^(double pro, BOOL isFinished) {
            // 需要和下面134行 添加数组的内容 同一个线程  否则会出现 多个线程访问同一个资源
            for (ProgressDownLoad blo in weakTool.blockArray) {
                blo(pro,isFinished);
            }
            if (isFinished) {
                [DownLoadManager removeObjectForKey:key];
            }
        };
        
        [DownLoadManager setValue:tool forKey:key];
        [tool downLoad];
    }
    
    if (block) {    
        ProgressDownLoad blockCopy = [block copy];
        [tool.blockArray addObject:blockCopy];
    }
}
 
@end
