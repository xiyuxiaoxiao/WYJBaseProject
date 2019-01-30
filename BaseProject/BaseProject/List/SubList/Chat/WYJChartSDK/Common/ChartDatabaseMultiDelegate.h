//
//  ChartDatabaseMultiDelegate.h
//  BaseProject
//
//  Created by ZSXJ on 2018/5/31.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartDatabaseMultiDelegate : NSObject

@property (readonly, nonatomic) NSPointerArray* delegates;
@property (nonatomic, assign) BOOL silentWhenEmpty;

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;
- (void)removeAllDelegates;



@end
