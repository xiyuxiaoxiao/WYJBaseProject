//
//  UIImage+Category.m
//  BaseProject
//
//  Created by ZSXJ on 2019/9/19.
//  Copyright © 2019年 WYJ. All rights reserved.
//


#pragma mark - 压缩 裁剪
/*
     imageWithContentsOfFile  加载会自动释放内存
     imageNamed   加载不会释放内存
     质量压缩 只是在上传文件的时候 文件大小会变小 所占内存大小不变
     尺寸压缩 可以改变图片内存大小 通过绘制可以发现 基本不消耗内存
 */


#import "UIImage+Category.h"

@implementation UIImage (Category)

// 压缩图片质量
- (NSData *)getCompressedImageData {
    
    CGFloat maximumDataSizePerPixel = 0.1;
    CGFloat maxCompression = 0.5;
    CGFloat compression = 1.0;
    
    // 下面并不是真正的大小 需要在乘以scale等才能判断出大小
//    CGFloat maxFileSize = self.size.width*self.size.height*maximumDataSizePerPixel;
    NSData *imageData = UIImageJPEGRepresentation(self, compression);

    while (imageData.length > 100*1024.0f && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(self, compression);

        NSLog(@"图片大小%f",imageData.length / 1024.0);
    }
    NSLog(@"图片大小%f",imageData.length / 1024.0);
    return imageData;
}

// 直接给定所选图片的最大宽度 直接绘制 会使得图片不会占用内存
- (UIImage *)resizedImageWithCertainWidth: (CGFloat)newWidth {
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    CGFloat scale = newWidth/width;
    
    if (scale >= 1) {
        return self;
    } else {
        CGFloat newWidth = width * scale;
        CGFloat newHeight = height * scale;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), false, 1);
        [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return resizedImage;
    }
}

@end
