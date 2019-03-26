//
//  UIImage+WYJChartImageStore.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/31.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "UIImage+WYJChartImageStore.h"
#import "WYJFileTool.h"

@implementation UIImage (WYJChartImageStore)

// 此方法 只要是本地发送存储 不能通过子线程请求 如果是网络接受消息 需要子线程存储
- (NSString *)storeFileName: (NSString *)fileName {
    NSString *path = [WYJFileTool filePathDocument];
    NSString *imageFilePtah = [path stringByAppendingString:fileName];
    NSLog(@"%@",imageFilePtah);
    [self saveFilePath:imageFilePtah];
    
    return fileName;
}

- (void)storeWebImageWithFilePathName: (NSString *)filePath {
    // 因为 是网络获取的 有可能出现多次 所以每次存储前 需要先a判断本地是否已经有
    dispatch_async(dispatch_queue_create(0, 0), ^{
        if (NO == [[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [self saveFilePath:filePath];
        }
    });
}
// 保存在本地 -- 对图片尺寸和大小压缩
- (void)saveFilePath: (NSString *)filePath {
    UIImage *image = [self resizedImageWithCertainWidth:750];
    NSData *imageData = [image getCompressedImageData];
    
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:imageData attributes:nil];
}

#pragma mark - 压缩 裁剪
// 压缩
- (NSData *)getCompressedImageData {
    
    CGFloat maximumDataSizePerPixel = 0.1;
    CGFloat maxCompression          = 0.5;
    CGFloat compression             = 1.0;
    
    CGFloat maxFileSize = self.size.width*self.size.height*maximumDataSizePerPixel;
    NSData *imageData = UIImageJPEGRepresentation(self, compression);
    
    while (imageData.length > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(self, compression);
    }
    
    return imageData;
}


// 直接给定所选图片的最大宽度
- (UIImage *)resizedImageWithCertainWidth: (CGFloat)limitWidth {
    
    CGFloat width   = self.size.width;
    CGFloat height  = self.size.height;
    CGFloat scale   = limitWidth / width;
    
    if (scale >= 1) {
        return self;
    }else {
        CGFloat newWidth  = width * scale;
        CGFloat newHeight = height * scale;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), NO, 1);
        
        [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        return resizedImage;
    }
}

@end
