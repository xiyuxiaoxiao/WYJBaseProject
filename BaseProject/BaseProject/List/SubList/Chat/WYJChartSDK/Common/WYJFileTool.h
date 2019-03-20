//
//  WYJFileTool.h
//  BaseProject
//
//  Created by ZSXJ on 2019/3/19.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYJFileTool : NSObject

+ (NSString *)filePathDocument;

+ (NSString *)creatFileName;
+ (NSString *)fileNameWithURL: (NSString *)url;

@end

NS_ASSUME_NONNULL_END
