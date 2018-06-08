
@interface BlockPoint : NSObject
@property (nonatomic, copy)     NSString *text;
@end

@implementation BlockPoint

/*
 
 **** block在创建的时候 已经拷贝了相应的代码，所以无论什么时候执行，里面的代码相关变量的内容或者地址 已经copy了。
 
 I：
 1、静态变量和全局变量在加和不加__block都会直接引用变量地址。也就意味着可以修改变量的值。在没有加__block关键字的情况下。
 
 2、常量变量(NSString *a=@"hello"; a为变量,@“hello”为常量。)
 　　不加__block类型，block会直接取常量值(浅拷贝)。
 　　加__block类型，block会去引用变量的地址。(如:a变量,a = @"abc".可以任意修改a 指向的内容。)
 如果不加__block 直接在block内部修改变量 ,会编译报错。block内部改变量是只读的。
 */

/*
 
 1.一般情况下你不需要自行调用copy或者retain一个block. 只有当你需要在block定义域以外的地方使用时才需要copy. Copy将block从内存栈区移到堆区.
 
 2.其实block使用copy是MRC留下来的也算是一个传统吧, 在MRC下, 如上述, 在方法中的block创建在栈区, 使用copy就能把他放到堆区, 这样在作用域外调用该block程序就不会崩溃.
 
 3.但在ARC下, 使用copy与strong其实都一样, 因为block的retain就是用copy来实现的, 所以block使用copy还能装装逼, 说明自己是从MRC下走过来的
 */


//  因为在block生成的时候，是会把number当做是常量变量编码到block当中。可以看到，以下的代码，block中的number值是不会发生变化的：
- (void)test0 {
    
    int number =1;
    
    void (^blk)(void) = ^{
        NSLog(@"%d",number);
    };
    
    number = 2;
    
    blk();
//    结果： 1
}

// 加__block 在block内部，会对number的地址进行copy，所以最后指向的number的地址，也可以对其进行修改。
- (void)test1 {
    __block int number =1;
    
    void (^blk)(void)  = ^{
        NSLog(@"%d",number);
    };
    
    number = 2;
    blk();
    
    //结果 2
}

/*
    将block 放到集合中的例子， 如果直接把生成的block放入到集合类中，是无法在其他地方使用block
    [严禁的话 ，可以在创建的 先 copy一下]
 
    经过测试 如果是数组对象中 只有一个未copy block的在使用的时候 不太容易出现崩溃，而在创建多个的时候，会直接崩溃，但是通过testBlockArray2创建的方式 则不会崩溃
 
    testBlockArray1：崩溃
    testBlockArray2：正常
*/

// 崩溃
- (void)testBlockArray1 {
    __block int val = 1;
    __block int val2 = 2;
    NSArray *arr = [NSArray arrayWithObjects:
                    [^{
                        NSLog(@"blk1:%d",val);
                    } copy],
                    [^{
                        NSLog(@"blk2:%d",val2);
                    } copy],
                    nil];
    // 为了防止崩溃，可以在创建后 先copy
/*  正确的
    NSArray *arr = [NSArray arrayWithObjects:
                    [^{
                        NSLog(@"blk1:%d",val);
                    } copy],
                    [^{
                        NSLog(@"blk2:%d",val2);
                    } copy],
                    nil];
*/
    
    typedef void (^blk_t)(void);
    blk_t blk = (blk_t)arr[0];
    blk();
}

// 正常
- (void)testBlockArray2 {
    typedef void (^blk_t)(void);
    
    __block int val = 1;
    __block int val2 = 2;
    
    blk_t blk0 = ^{
        NSLog(@"val:%d",val);
    };
    blk_t blk1 = ^{
        NSLog(@"val2:%d",val2);
    };
    
    NSArray *arr = [NSArray arrayWithObjects:blk0,blk1,nil];
    blk_t blk = (blk_t)arr[0];
    blk();
}


// ====================== Block 线程安全 ================================

/*
 
     在声明Block属性时需要确认“在调用Block时，另一个线程有没有可能去修改Block？”这个问题，
     如果确定不会有这种情况发生的话，那么Block属性声明可以用nonatomic。
     如果不肯定的话（通常情况是这样的），那么你首先需要声明Block属性为atomic，也就是先保证变量的原子性（Objective-C并没有强制规定指针读写的原子性，C#有）。
 
     比如这样一个Block类型：
 
     typedef void (^MyBlockType)(int);
     属性声明：
 
     @property (copy) MyBlockType myBlock;
     这里ARC和非ARC声明都是一样的，当然注意在非ARC下要release Block。
 
     但是，有了atomic来保证基本的原子性还是没有达到线程安全的，接着在调用时需要把Block先赋值给本地变量，以防止Block突然改变。因为如果不这样的话，即便是先判断了Block属性不为空，在调用之前，一旦另一个线程把Block属性设空了，程序就会crash，如下代码：
 
     if (self.myBlock)
     {
         //此时，走到这里，self.myBlock可能被另一个线程改为空，造成crash
         //注意：atomic只会确保myBlock的原子性，这种操作本身还是非线程安全的
         self.myBlock(123);
     }
 
     所以正确的代码是（ARC）：
 
     MyBlockType block = self.myBlock;
     //block现在是本地不可变的
     if (block)
     {
         block(123);
     }
 
     在非ARC下则需要手动retain一下，否则如果属性被置空，本地变量就成了野指针了，如下代码：
 
     //非ARC
     MyBlockType block = [self.myBlock retain];
     if (block)
     {
         block(123);
     }
     [block release];
 
 */

MakeSourcePath
@end
