
// ------ static 访问的域问题 ------
/**
    static int WyjCount = 100;  在MyRecord 文件中
 
    static 只针对源文件有效 不同的文件引用的话 都会保存一份副本,
    即使分类和类中的访问 也是不一样的
 

    以前代码在ViewController中
     NSLog(@"外部 %p , %d",&WyjCount, WyjCount); // 100
     WyjCount = 10000;
     NSLog(@"外部 %p , %d",&WyjCount, WyjCount); //10000
     
     [MyRecord print]; //(WyjCount++)  // 101
     NSLog(@"外部 %p , %d",&WyjCount, WyjCount); 10000
    
     [MyRecord print]; // 102
     NSLog(@"外部 %p , %d",&WyjCount, WyjCount); // 10000
 
 --------------extern --------------
 extern可置于变量或者函数前，以表示变量或者函数的定义在别的文件中，提示编译器遇到此变量或者函数时时，在其他模块中寻找其定义。另外，extern也可用来进行链接指定
 */


// ------ 多线程 崩溃测试 -----
/*
    代码1 的时候 不会crash
        因为字符串少的时候 ,内部会创建为 Tagged Pointer 类型
        Tagged Pointer 就和assing一样 不会对引用计数加减法
    代码2 因为超过地址内容的时候 就会使用对象存储, 在线程中 对name多次release就会导致崩溃
    因为name使用的strong, release的时候获取上一次对象 而赋值set的时候 是对新的[NSString stringWithFormat:] 进行return 而非_name,当多个线程同时对name release的时候 就会导致崩溃
 
    1.Tagged Pointer专门用来存储小的对象，例如NSNumber和NSDate
    2.Tagged Pointer指针的值不再是地址了，而是真正的值。
     实际上它不再是一个对象了，它只是一个披着对象皮的普通变量而已。
     它的内存并不存储在堆中，也不需要malloc和free。
    3.在内存读取上有着3倍的效率，创建时比以前快106倍。
 
    
 */

/*
 @property (nonatomic, strong) NSString *name;
- (void)threadTest {
    dispatch_queue_t queue = dispatch_queue_create("abc", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < 10000; i++) {
        dispatch_async(queue, ^{
            //代码1
            self.name = [NSString stringWithFormat:@"abc"];
            // 代码2
            self.name = [NSString stringWithFormat:@"abcdefghkjsdklfjsdkl"];
        });
    }
}
 */


/**
    Cache:
            自己实现1M的一个缓存
        需要对 key做一个队列维护, 当数量超过的时候 删除最早的key 直到size < 设置的限制
        每次使用的时候,将对应的key移动到头部
 
    并且记录使用的时间,因为有定时器开启,当每次清除的时候 判断是否过期 过期的话删除缓存
 
 */

