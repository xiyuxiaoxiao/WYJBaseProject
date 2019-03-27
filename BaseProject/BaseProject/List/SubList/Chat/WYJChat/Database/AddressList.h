//
//  AddressList.h
//  FMDBMoreTable
//
//  Created by ZSXJ on 2018/5/24.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "WYJChartDBModel.h"

@interface AddressList : WYJChartDBModel

@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *sex;

@property (nonatomic,copy)NSString *conversionId; // 会话id

@property (nonatomic,copy) NSString *lastNewMessage;

+ (NSArray *)findAddressWithOneMessage;
@end
