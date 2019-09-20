//
//  UIImage+Category.h
//  BaseProject
//
//  Created by ZSXJ on 2019/9/19.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Category)
- (NSData *)getCompressedImageData;
- (UIImage *)resizedImageWithCertainWidth: (CGFloat)newWidth;
@end

NS_ASSUME_NONNULL_END
