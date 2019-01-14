//
//  BGfmdbTest.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/10.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <BGFMDB.h>

@interface BGfmdbTest : NSObject
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,copy)NSString *name;
//@property (nonatomic,copy)NSString *sex;

+ (void)saveTestObject;
@end


