//
//  GCDMySummary.m
//  BaseProject
//
//  Created by ZSXJ on 2019/3/4.
//  Copyright © 2019年 WYJ. All rights reserved.
//

@interface GCDMySummary : NSObject

@end

@implementation GCDMySummary

// 信号量
+ (void)test1 {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self test1Async];
        NSLog(@"结果执行了1");
    });
}


// 利用信号量 将异步执行的结果返回 【会阻塞当前线程】
+ (NSArray *)test1Async {
    
    __block NSArray *tasks = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        tasks = @[];
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return tasks;
}

MakeSourcePath
@end

/*
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
 });
 
 ** dispatch_async 本身就是异步操作 至于是否会开启自线程 主要取决于 加入的队列 是否是主队列 不是主队列的话 则会自动创建子线程
 ** dispatch_get_global_queue 是全局并发队列 第一个参数表示 队列的优先级 第二个暂时没用
 -- dispatch_get_global_queue 不表示 初始化线程
 
 
  GCD 延时执行方法：dispatch_after 因为只是在时间到后 将block加入到队列中 至于什么时候执行 还是要等待队列执行到的时候
 
 网上看到 preferment也是一样 看到解决的办法是：自定义线程 然后在线程中 添加runloop 因为自线程默认没有time 不会启动
 
    只有主线程会在创建的时候默认自动运行一个runloop，并且有timer，普通的子线程是没有这些的。
    这样在子线程中被调用的时候，我们的代码中的延时调用的代码就会一直等待timer的调度，
    但是实际上在子线程中又没有这样的timer，这样我们的代码就永远不会被调到。因此，perform使用时需要注意环境！
 
 或者time 也需要加入 runloop
 --------------------------
 [NSThread currentThread].name = @"自定义线程名字";
 NSRunLoop * runloop = [NSRunLoop currentRunLoop];
 [runloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
 
 [self performSelector:@selector(test1) withObject:nil afterDelay:2.0];
 
 [runloop run];
 --------------------------
 */

/*
 此处默认 dispatch_semaphore_wait 都是 DISPATCH_TIME_FOREVER
 
 信号量 初始创建 是 表示允许有几个  可以允许进入  当信号量等于0的时候 在调用wait则不允许往下走 不为0 则可以走 并且 减1
 
 当 信号量 >= 1 的时候 dispatch_semaphore_wait 将信号量减1 然后执行后面的代码
 当 信号量  = 0 的时候 dispatch_semaphore_wait 将等待信号量 >=1,然后等到的时候 在对其减1 然后执行后面的代码
 当 信号量  = 0 的时候 如果超时 也会继续走后面的方法 不会对信号量减去1
 
 dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
 执行内容
 dispatch_semaphore_signal(self.semaphore);
 
 --------------------------------------------------------------------------------------------------

 初始化信号量
 
     1. dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
     一般都是先减去 在加上 这样就必须 在开始的时候 创建 传入 1
 
     2.dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
     如果开始是0, 则肯定需要 例如上面 test1Async 那样 先执行异步的操作 等待异步结果将信号量 +1 然后外部在等待返回 减去1，否则后面不会不会执行
 */

/*
****** 栅栏
    dispatch_barrier_async
 
    可以实现将任务按照 顺序执行 栅栏前 的先执行 然后执行 栅栏内的 在执行栅栏后的
 
    官方规定了，栅栏函数 只能用在调度并发队列中（自定义的并发队列），不能使用在全局并发队列中
    （如果使用全局并发队列，会导致结果错误。猜测 可能是 栅栏在全局并发队列 不起作用了）
*/

/*
******* 分组
    dispatch_group_async
    dispatch_group_notify 等待前面全部执行完 再执行notify
*/

/*
+ (void)dispatch_group_TEST {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"----耗时任务1-----%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"----耗时任务2-----%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"----耗时任务3-----%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"----耗时任务4-----%@", [NSThread currentThread]);
    });
    //线程组全执行完毕才会调用
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"----结束-----");
    });
}
*/
