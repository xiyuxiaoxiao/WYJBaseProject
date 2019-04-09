
#import <objc/runtime.h>
#import <objc/message.h>

@interface RuntimePoint : NSObject
@end


//NSURL * new_url_Imp(id self, SEL _cmd, NSString *str) {
//
//}

@implementation RuntimePoint
/*
 
 */

// 添加方法
// 方法交换 在不使用分类的情况下， 在其他类中 需要添加方法 然后交换
+ (void)change {
    
    Method URLWithString = class_getClassMethod([NSURL class], @selector(URLWithString:));
    
    Method m = class_getClassMethod([RuntimePoint class], @selector(newString:));
    IMP imp = method_getImplementation(m);
    // object_getClass() 获取的是元类的类  这样 添加的才是 类方法
    class_addMethod(object_getClass(NSURL.class), @selector(hook_URLWithString:), imp, "@@:@");

    method_exchangeImplementations(URLWithString, class_getClassMethod(NSURL.class, @selector(hook_URLWithString:)));
    
    
    NSObject *s = [NSURL URLWithString:@"试试"];
    // 返回结果为空 不知为何
    NSLog(@"结果：%@",s);
    
}
void * newImpURL(id self, SEL _cmd ,NSString *str) {
    NSLog(@"动态添加方法 上钩了 -------%@",NSStringFromSelector(_cmd));
    NSURL *url = [self performSelector:@selector(hook_URLWithString:) withObject:str];
    return (__bridge void *)url;
}

+ (NSURL *)newString:(NSString *)URLString {
    NSLog(@"动态添加方法 上钩了 %@",self.class);
    // 返回结果为空 不知为何  hank老师讲的 结果也是如此
    return [[NSURL class] performSelector:@selector(hook_URLWithString:) withObject:URLString];
    return  ((id (*) (id,SEL,id))objc_msgSend)(self,@selector(hook_URLWithString:),URLString);
}

MakeSourcePath
@end
