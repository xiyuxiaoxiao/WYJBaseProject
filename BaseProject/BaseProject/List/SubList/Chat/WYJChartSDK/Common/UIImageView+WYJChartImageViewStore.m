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
        [self sd_setImageWithURL:[NSURL fileURLWithPath:imageFilePtah] placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:nil completed:nil];
        return;
    }
    
    // 本地的话 url肯定存在 但是也可能扩展  删除后 与本地同步 加载历史消息  然后网络获取
    if (!url) {
        return;
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if ([imageURL.absoluteString isEqualToString:url]) {
                    [image storeWebImageWithFilePathName:imageFilePtah];
                }
    }];
}

@end
