//
//  AddressListManager.m
//  BaseProject
//
//  Created by ZSXJ on 2018/5/31.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "AddressListManager.h"
#import "AddressList.h"

@implementation AddressListManager

+ (void)addNewFriend:(NSString *)name {
    
    AddressList *list = [[AddressList alloc] init];
    list.userId = [WYJDate getTimeSp:[NSDate date]];
    list.name = name;
    
    list.sex = arc4random()%2 == 0 ? @"男":@"女";
    
    [list saveOrUpdate];
}
@end
