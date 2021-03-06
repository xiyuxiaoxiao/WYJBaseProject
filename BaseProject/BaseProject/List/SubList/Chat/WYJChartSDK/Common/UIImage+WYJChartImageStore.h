//
//  UIImage+WYJChartImageStore.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/31.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (WYJChartImageStore)
- (NSString *)storeFileName: (NSString *)fileName;
- (void)storeWebImageWithFilePathName: (NSString *)filePath;
@end

NS_ASSUME_NONNULL_END
