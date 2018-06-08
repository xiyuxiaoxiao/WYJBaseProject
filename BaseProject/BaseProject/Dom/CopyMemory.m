
@interface Persion : NSObject <NSCopying>
@property (nonatomic, copy) NSString *name;
@end

@implementation Persion
- (id)copyWithZone:(NSZone *)zone
{
    Persion *copy = [[[self class] allocWithZone:zone] init];
    return copy;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    Persion *copy = NSCopyObject(self, 0, zone);
    return copy;
}

@end

//------------------------  CopyMemory   -------------------------

// copy的内存管理
@interface CopyMemory : NSObject
@end

@implementation CopyMemory

/*
 
 https://www.jianshu.com/p/5254f1277dba
 https://www.cnblogs.com/gaoxiao228/archive/2012/04/21/2462561.html
 
 分为好几种情况
 1.copy的对象 是否实现了
 
 深拷贝与浅拷贝
 何为深拷贝, 何为浅拷贝?
 
 深拷贝 : 拷贝出来的对象与源对象地址不一致! 这意味着我修改拷贝对象的值对源对象的值没有任何影响.
 浅拷贝 : 拷贝出来的对象与源对象地址一致! 这意味着我修改拷贝对象的值会直接影响到源对象.
 这里需要纠正网上一些错误的观点(以下为错误观点)
 <pre>copy都是浅拷贝, mutableCopy都是深拷贝</pre>
 
 ----------------------****-------------------------
 我们知道, 当我们用copy从一个可变对象拷贝出一个不可变对象时, 这种情况就属于深拷贝而不是浅拷贝!!
 ----------------------****-------------------------
 
 注意 ! 深拷贝与浅拷贝也有相对之分!!!看下面
 
 对于NSString对象, 确实深拷贝就是深拷贝, 浅拷贝就是浅拷贝, 没有任何异议.
 但是对于NSArray, NSDictionary, NSSet这些容器类的对象呢? 当然浅拷贝依然是指针拷贝, 那深拷贝意味着连同容器及其容器内的对象一并拷贝吗? 还是只拷贝容器对象, 对容器内的对象则只是简单引用呢? 这里有两种情况, 我姑且把它称为不完全深拷贝与完全深拷贝
 */


#pragma mark - 对于 NSArray 测试
/*
 ------------------------------------------------------------------------
  NSArray
 copy        retainCount+1，（浅拷贝） 只是对Arrayretaincount 里面的元素对象并不影响，
 mutableCopy 之前的不变，新的retainCount = 1;  （深拷贝）
 
  NSMutableArray
 copy        之前的不变，新的retainCount = 1;  （深拷贝）
 mutableCopy 之前的不变，新的retainCount = 1;  （深拷贝）
 
 如果一个 Person类 实现了 <NSCopying>协议 那么就需要看看里面是不是 重新新建了一个对象，这样就属于深拷贝 引用计数不影响原来对象
 
 NSString是不可变对象, 所以就算copy不生成新对象, 前后2个指针都指向同一对象也不用担心(因为NSString无法修改, NSMutableString可以修改), 这样既能达到需求, 又能节省内存
 
 对于数组内部元素的影响 （此处元素 指 基本的对象 不是字符串等）
 
 NSArray            copy            元素returnCount 不变;
 NSArray            mutableCopy     元素returnCount + 1;
 NSMutableArray     copy            元素returnCount + 1；
 NSMutableArray     mutableCopy     元素returnCount 不变；
 
 
 例子：
 -------------------------------------------------------------------------
 其本质 需要了解 array 以及 mutableArray 在 copy 以及 mutableCopy下的元素之间的引用计数变化
 // 自定义对象 自定义对象下 实现 copy协议的 和 NSString 还有
 Persion *p_arr = [[Persion alloc] init];
 Persion *p_mut = [[Persion alloc] init];
 NSObject *obje_arr = [[NSArray alloc] initWithObjects: p_arr,nil];
 NSMutableArray *obje_arr_Mut = [[NSMutableArray alloc] initWithObjects: p_mut, nil];
 
 retainCount ----
 p_arr :2  p_mut :2;  obje_arr:1  obje_arr_Mut:1
 
 NSObject *s = [obje_arr mutableCopy];
 NSObject *s2 = [obje_arr_Mut mutableCopy];

 retainCount ----
 p_arr :3  p_mut :2;  obje_arr:1  obje_arr_Mut:1

 
 // 自定义对象 自定义对象下 实现 copy协议的 宝行mutableCopy协议 和
 
 NSString 还有
 
 */


#pragma mark - 属性copy 和 copy方法  当我们用copy从一个可变对象拷贝出一个不可变对象时, 这种情况就属于深拷贝而不是浅拷贝
/*
 -------------------------------------------------------------------------
 @property (nonatomic, copy) NSMutableArray *array;
 
 NSMutableArray *newArr = [[NSMutableArray alloc] initWithObjects: @"2",@"3", nil];
 self.array = newArr; //此时 实际调用 [newArr copy]
 
 由于属性 使用 copy ，实际在上面代码赋值的时候 ，也是采用的 [newArr copy]；获取到的是 一个不可变的数组 NSArray; 不是NSMutableArray   retainCount 不影响
 -------------------------------------------------------------------------
 */


#pragma mark - block为什么要用copy?
/*
 -------------------------------------------------------------------------
 
 ***    block为什么要用copy?     ***
 
 首先, block是一个对象, 所以block理论上是可以retain/release的. 但是block在创建的时候它的内存是默认是分配在栈(stack)上, 而不是堆(heap)上的. 所以它的作用域仅限创建时候的当前上下文(函数, 方法...), 当你在该作用域外调用该block时, 程序就会崩溃.
 
 意思就是 : 一般情况下你不需要自行调用copy或者retain一个block. 只有当你需要在block定义域以外的地方使用时才需要copy. Copy将block从内存栈区移到堆区.
 
 其实block使用copy是MRC留下来的也算是一个传统吧, 在MRC下, 如上述, 在方法中的block创建在栈区, 使用copy就能把他放到堆区, 这样在作用域外调用该block程序就不会崩溃. 但在ARC下, 使用copy与strong其实都一样, 因为block的retain就是用copy来实现的, 所以block使用copy还能装装逼, 说明自己是从MRC下走过来的..嘿嘿
 -------------------------------------------------------------------------
 */

// 可变容器 mutableCopy
- (void)mutableArrayMutableCopyTest {
    
    Persion *p_mut = [[Persion alloc] init];
    p_mut.name = @"WYJ";
    NSMutableArray *arr_Mut = [[NSMutableArray alloc] initWithObjects: p_mut, nil];
    NSMutableArray *arr_mut_mutCopy = [arr_Mut mutableCopy];
    
    // [p_mut retainCount]           = 2
    // [arr_Mut retainCount]         = 1
    // [arr_mut_mutCopy retainCount] = 1
    
    // 数组中 包含的对象 是同一个 对象 地址都相同
}
// 可变容器 Copy
- (void)mutableArrayCopyTest {
    Persion *p_mut = [[Persion alloc] init];
    p_mut.name = @"WYJ";
    NSMutableArray *arr_Mut = [[NSMutableArray alloc] initWithObjects: p_mut, nil];
    NSArray *arr_mut_copy = [arr_Mut copy];
    
    // [p_mut retainCount]          = 3
    // [arr_Mut retainCount]        = 1
    // [arr_mut_copy retainCount]   = 1
    
    // 数组中 包含的对象 是同一个 对象 地址都相同
}

// 不可变容器 Copy
- (void)arrayCopyTest {
    
    Persion *p_mut = [[Persion alloc] init];
    p_mut.name = @"WYJ";
    NSArray *arr = [[NSArray alloc] initWithObjects: p_mut, nil];
    NSArray *arr_mutCopy = [arr copy];
    
    // 数组 地址相同
    
    // [p_mut retainCount]          = 2
    // [arr retainCount]            = 2
    // [arr_mutCopy retainCount]    = 2
    
    // 数组中 包含的对象 是同一个 对象 地址都相同
}

// 不变容器 mutableCopy
- (void)arrayMutableCopyTest {
    
    Persion *p_mut = [[Persion alloc] init];
    p_mut.name = @"WYJ";
    NSArray *arr = [[NSArray alloc] initWithObjects: p_mut, nil];
    NSArray *arr_mutCopy = [arr mutableCopy];
    // [NSArray arrayWithArray:arr]; == 相当于 mutableCopy
    
    // [p_mut retainCount]          = 3
    // [arr retainCount]            = 1
    // [arr_mutCopy retainCount]    = 1
    
    // 数组中 包含的对象 是同一个 对象 地址都相同
}

// 自定义对象 copy & mutableCopy

/*
 - (id)copyWithZone:(NSZone *)zone {
 Persion *copy = [[[self class] allocWithZone:zone] init];
 return copy;
 }
 - (id)mutableCopyWithZone:(NSZone *)zone{
 Persion *copy = NSCopyObject(self, 0, zone);
 return copy;
 }
 */
- (void)customObjectCopy {
    //     由于实现了copy协议，因此创建了新的内存 与之前的应用技术不影响
    NSObject *obj = [[Persion alloc] init];
    NSObject *obj_copy = [obj mutableCopy];
    NSObject *obj_mutCopy = [obj copy];
    
    // 因为自定义实现了copy协议 里面的
    // [obj retainCount]       = 1
    // [obje1 retainCount]     = 1
    // [obje2 retainCount]     = 1
}

- (void)stringCopy {
    NSString *str = [[NSString alloc] initWithString:@"www"];
    NSString *strCopy = [str copy];
    NSString *strRetain = [str retain];
    
    // 此时 地址都一样
    NSLog(@"%p %p, %p",str,strCopy,strRetain);
    // 0x10b9db2c8 0x10b9db2c8, 0x10b9db2c8
    NSLog(@"%ld,%ld,%ld",[str retainCount],[strCopy retainCount],[strRetain retainCount]);
    // -1,-1,-1
    
    strRetain = @"newWWW";
    NSLog(@"str:%@\nstrCopy:%@\nstrRetain:%@",str,strCopy,strRetain);
    
    //str:www , strCopy:www , strRetain:newWWW
    //strRetain 地址也变了 因为@"newWWW" 或者 alloc init等方式创建出来的是常量区，所以strRetain被指向常量区了，
    
    NSString *strMutCopy = [str mutableCopy]; //拷贝在堆区了
    NSLog(@"%p,%ld",strMutCopy,[strMutCopy retainCount]);
    //  retainCount: 1 新的地址
}

MakeSourcePath
@end

