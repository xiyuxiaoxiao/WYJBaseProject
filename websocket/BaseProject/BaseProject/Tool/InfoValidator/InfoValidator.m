//
//  Validor.m
//  BicyclePasswordDatabase
//
//  Created by ZSXJ on 2017/3/20.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "InfoValidator.h"

@implementation InfoValidator

//数字字母条件
+(BOOL)numLetterValidor:(NSString *)str {
    NSString *regex = @"^[a-z0-9A-Z]{6,8}$";
    return [self predicateString:str withRegex:regex];
}

//密码判断条件
+(BOOL)passwordValidor:(NSString *)str {
    //数字 并且个数=4
    NSString *regex = @"^[0-9]{4}$";
    return [self predicateString:str withRegex:regex];
}


//数字字母条件
+(BOOL)userNameValidor:(NSString *)str {
    NSString *regex = @"^[a-z0-9A-Z]{4,16}$";
    return [self predicateString:str withRegex:regex];
}
//数字字母条件
+(BOOL)userPasswordValidor:(NSString *)str {
    NSString *regex = @"^[a-z0-9A-Z]{4,16}$";
    return [self predicateString:str withRegex:regex];
}

//验证m-n位的数字：^\d{m,n}$
+(BOOL)numberVaildor:(NSString *)str m:(int)m int:(int)n {
    NSString *regex = [NSString stringWithFormat:@"^\\d{%d,%d}$",m,n];
    return [self predicateString:str withRegex:regex];
}

+(BOOL)predicateString:(NSString *)str withRegex:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:str];
}


@end
