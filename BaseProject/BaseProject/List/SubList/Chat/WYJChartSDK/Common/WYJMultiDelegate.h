//
//  WYJMultiDelegate.h
//  BaseProject
//
//  Created by ZSXJ on 2018/5/31.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYJMultiDelegate : NSObject

@property (readonly, nonatomic) NSPointerArray* delegates;

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;
- (void)removeAllDelegates;



@end
