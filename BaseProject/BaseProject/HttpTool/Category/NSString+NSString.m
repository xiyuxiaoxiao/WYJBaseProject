//
//  NSString+NSString.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/1.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "NSString+NSString.h"

@implementation NSString (NSString)

+ (BOOL)judgeIsEmptyWithString:(NSString *)string
{
    if ([string isEqual:[NSNull null]]) return YES;
    if (string == NULL) return YES;
    if (string == nil) return YES;
    
    //需要先判断是否为空 然后才能使用length 不然会直接崩溃
    if ([string isKindOfClass:[NSString class]]) {
        if (string.length < 1) return YES;
    }
    
    return NO;
}

@end
