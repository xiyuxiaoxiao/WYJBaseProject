//
//  ChartDatabaseMultiDelegate.m
//  BaseProject
//
//  Created by ZSXJ on 2018/5/31.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "ChartDatabaseMultiDelegate.h"

@implementation ChartDatabaseMultiDelegate
{
    
    NSPointerArray* _delegates;
}

- (instancetype)init {
    return [self initWithDelegates:nil];
}
- (id)initWithDelegates:(NSArray *)delegates {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _delegates = [NSPointerArray weakObjectsPointerArray];
    for (id delegate in delegates) {
        [_delegates addPointer:(__bridge void *)(delegate)];
    }
    return self;
}

- (void)addDelegate:(id)delegate {
    [_delegates addPointer:(__bridge void *)(delegate)];
}

- (NSUInteger)indexOfDelegate:(id)delegate {
    for (NSUInteger i = 0; i < _delegates.count; i++) {
        if ([_delegates pointerAtIndex:i] == (__bridge void*)delegate) {
            return i;
        }
    }
    return NSNotFound;
}
/* 暂时不用
- (void)addDelegate:(id)delegate beforeDelegate:(id)otherDelegate {
    NSUInteger index = [self indexOfDelegate:otherDelegate];
    if (index == NSNotFound)
        index = _delegates.count;
    [_delegates insertPointer:(__bridge void*)delegate atIndex:index];
}

- (void)addDelegate:(id)delegate afterDelegate:(id)otherDelegate {
    NSUInteger index = [self indexOfDelegate:otherDelegate];
    if (index == NSNotFound)
        index = 0;
    else
        index += 1;
    [_delegates insertPointer:(__bridge void*)delegate atIndex:index];
}
*/

- (void)removeDelegate:(id)delegate {
    NSUInteger index = [self indexOfDelegate:delegate];
    if (index != NSNotFound) {
        [_delegates removePointerAtIndex:index];
    }
    //清空数组中的所有NULL,注意:经过测试如果直接compact是无法清空NULL,需要在compact之前,调用一次[_weakPointerArray addPointer:NULL],才可以清空
    // 因为此时 delegate是在dealloc调用，已经销毁，所以在数组中为NULL 无法找到index，需要用 compact 清空NULL
    // 对于 removePointerAtIndex 就不需要
    [_delegates addPointer:NULL];
    [_delegates compact];
}
- (void)removeAllDelegates {
    for (NSUInteger i = _delegates.count; i > 0; i -= 1){
        [_delegates removePointerAtIndex:i - 1];
    }
}

//=========================================================

// 不用消息转发 也可以实现
//- (void)addressListUpdate {
//    for (id delegate in _delegates) {
//        if (delegate && [delegate respondsToSelector:@selector(addressListUpdate)]) {
//            [delegate performSelector:@selector(addressListUpdate)];
//        }
//    }
//}

//消息转发
//好处 不用每次添加一个代理 都去实现 然后遍历里面每个

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (signature) {
        return signature;
    }
    [_delegates addPointer:NULL];
    [_delegates compact];
    if (self.silentWhenEmpty && _delegates.count == 0) {
        return [self methodSignatureForSelector:@selector(description)];
    }
    
    for (id delegate in _delegates) {
        if (!delegate) {
            continue;
        }
        signature = [delegate methodSignatureForSelector:selector];
        if (signature) {
            break;
        }
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL selector = invocation.selector;
    BOOL responseed = NO;
    
    for (id delegate in _delegates) {
        if (delegate && [delegate respondsToSelector:selector]) {
            [invocation invokeWithTarget:delegate];
            responseed = YES;
        }
    }
//    if (!responseed && !self.silentWhenEmpty) {
//        //如果执行doesNotRecognizeSelector  在没有实现相关方法的时候 就会造成崩溃
//        [self doesNotRecognizeSelector:selector];
//    }
}




@end


