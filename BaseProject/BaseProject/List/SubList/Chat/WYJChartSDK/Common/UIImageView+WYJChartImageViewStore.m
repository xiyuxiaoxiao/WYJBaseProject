//
//  UIImageView+WYJChartImageViewStore.m
//  BaseProject
//
//  Created by ZSXJ on 2019/2/14.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "UIImageView+WYJChartImageViewStore.h"
#import "UIImage+WYJChartImageStore.h"
#import "DownLoadTool.h"

@implementation UIImageView (WYJChartImageViewStore)

- (void)wyjImageUrl: (NSString *)url localImagePath: (NSString *)imageFilePtah {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageFilePtah]) {
        [self sd_setImageWithURL:[NSURL fileURLWithPath:imageFilePtah] placeholderImage:nil];
        return;
    }
    
    // 本地的话 url肯定存在 但是也可能扩展  删除后 与本地同步 加载历史消息  然后网络获取
    if (!url) {
        return;
    }
    
    // 如果不想用这样的 可以使用SDwebimage的存储功能 不过需要自己单独处理存储以及清空缓存
//    [DownLoadTool creatByUrl:url filePath:imageFilePtah block:^(double pro, BOOL isFinished) {
//        if (isFinished) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self sd_setImageWithURL:[NSURL fileURLWithPath:imageFilePtah] placeholderImage:nil];
//            });
//        }
//    }];
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if ([imageURL.absoluteString isEqualToString:url]) {
            [image storeWebImageWithFilePathName:imageFilePtah];
        }
        
    }];
}
@end
