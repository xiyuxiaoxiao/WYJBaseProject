
@interface BlockPointCpp : NSObject
@end

@implementation BlockPointCpp

/*
    参考链接地址 ：https://blog.csdn.net/youshaoduo/article/details/87708513
 
    使用clang命令将OC编译成C++：
        到 main.m 目录下面 执行 clang -rewrite-objc main.m
 
    需要在main函数 才能运行编译 所以需要将测试的代码放在main函数中
 
 
    __block_impl 实际就是 生成的C++文件中 看到最终 block的类型
 
*/

struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};


void hookBlock (struct __block_impl * impl, ...) {
    NSLog(@"Block Hello Word");
}

#pragma mark - 将block实现 修改为 打印hello Word
void HookBlockToPrintHelloWorld (id block) {
    struct __block_impl * blockStruct = (__bridge struct __block_impl *)block;
    blockStruct -> FuncPtr = &hookBlock;
}



static void(*orig_func)(void *v, int a, NSString *b);

void hookBlockWithArgs (void *v, int a, NSString *b) {
    NSLog(@"%d %@",a,b);
    
    orig_func(v, a, b);
}

#pragma mark - 将block实现 修改为 打印传递的参数 并且调用原来的实现
void HookBlockToPrintArguments (id block) {
    struct __block_impl *blockStruct = (__bridge struct __block_impl *)block;
    
    orig_func = blockStruct->FuncPtr;
    
    blockStruct->FuncPtr = &hookBlockWithArgs;
}



- (void)funcTest {
    
    __block int b = 0;
    void (^block)(void) = ^{
        b = 1;
        NSLog(@"我们的block");
    };
    
    HookBlockToPrintHelloWorld(block);
    block();
    
    
    void (^blockArg)(int a, NSString *b) = ^(int a, NSString *b){
        NSLog(@"我们的blockArg");
    };
    HookBlockToPrintArguments(blockArg);
    blockArg(222, @"哈哈");
}


MakeSourcePath
@end
