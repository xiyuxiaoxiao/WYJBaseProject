//
//  Validor.h
//  BicyclePasswordDatabase
//
//  Created by ZSXJ on 2017/3/20.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoValidator : NSObject
+(BOOL)numLetterValidor:(NSString *)str;
+(BOOL)passwordValidor:(NSString *)str;

+(BOOL)userNameValidor:(NSString *)str;
+(BOOL)userPasswordValidor:(NSString *)str;

//验证m-n位的数字：^\d{m,n}$
+(BOOL)numberVaildor:(NSString *)str m:(int)m int:(int)n;
@end
