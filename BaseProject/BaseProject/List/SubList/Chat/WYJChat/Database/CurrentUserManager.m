//
//  CurrentUserManager.m
//  FMDBMoreTable
//
//  Created by ZSXJ on 2018/5/25.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "CurrentUserManager.h"
#import "AddressList.h"

@implementation CurrentUserManager
+ (AddressList *)currentUser {
    
    static AddressList *list = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        list = [[AddressList alloc] init];
        list.userId = @"userId";
        list.name = @"小王";
    });
    return list;
}

@end
