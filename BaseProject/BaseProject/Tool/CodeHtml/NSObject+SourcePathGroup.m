//
//  NSObject+SorucePathGroup.m
//  BaseProject
//
//  Created by ZSXJ on 2017/9/4.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "NSObject+SourcePathGroup.h"

@implementation NSObject (SourcePathGroup)

+ (NSString *)sourcePathByClassName:(NSString *)className {
    Class class = NSClassFromString(className);
    return [class sourcePath];
}
@end
