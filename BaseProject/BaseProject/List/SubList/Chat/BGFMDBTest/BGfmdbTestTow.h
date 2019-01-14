//
//  BGfmdbTestTow.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/14.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BGFMDB.h>

@interface BGfmdbTestTow : NSObject

@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *sex;

+ (void)saveTestObject;

@end
