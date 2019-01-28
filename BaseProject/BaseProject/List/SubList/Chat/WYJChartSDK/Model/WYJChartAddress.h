//
//  WYJChartAddress.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/15.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"
NS_ASSUME_NONNULL_BEGIN

@interface WYJChartAddress : NSObject
@property (nonatomic, copy)   NSString *userId;     // 用户id
@property (nonatomic, copy)   NSString *name;       // 用户名称
@property (nonatomic, copy)   NSString *nickName;   // 昵称
@end

NS_ASSUME_NONNULL_END
