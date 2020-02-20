//
//  JSOC_Object.m
//  TestUI
//
//  Created by ZSXJ on 2017/9/15.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "JSOC_Object.h"

@implementation JSOC_Object

- (instancetype)initWithWebView: (UIWebView *)webView {
    if (self = [super init]) {
        _webView = webView;
    }
    return self;
}

//协议里面要声明调用的方法
//- (void)nslog:(NSString *)str {
//    NSLog(@" JS 调用到 OC 了 %@",str);
//}

// callback 由 js中 传过来 OC 调用js  将要返回的方法名 callback为 html中 js的方法名
- (void)printWithString:(NSString *)string callback:(NSString *)callback {
    if (self.delegate && [self.delegate respondsToSelector:@selector(printLog:)]) {
        [self.delegate printLog:[NSString stringWithFormat:@"%@,%@",string,callback]];
    }
}

// oc调用js 可以不在此类中写 直接在控制器中使用也可以
- (void)ocToJs {
    NSString *callbackJS = @"callBack('我是callback')";
    [self.webView performSelector:@selector(stringByEvaluatingJavaScriptFromString:) withObject:callbackJS afterDelay:1];
}


@end
