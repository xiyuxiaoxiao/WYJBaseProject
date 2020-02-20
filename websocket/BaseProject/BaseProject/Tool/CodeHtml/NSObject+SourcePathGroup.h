//
//  NSObject+SorucePathGroup.h
//  BaseProject
//
//  Created by ZSXJ on 2017/9/4.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SorucePathGroup)
// 使用的时候 相关类中一定要实现 相应的方法  只需添加 MakeSourcePath即可
SourcePathInterface

+ (NSString *)sourcePathByClassName:(NSString *)className;

@end
