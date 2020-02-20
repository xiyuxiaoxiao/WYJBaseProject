//
//  JSOC_Object.h
//  TestUI
//
//  Created by ZSXJ on 2017/9/15.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
//定义一个协议继承JSExport协议
@protocol JSOC_ObjectJSExport <JSExport>
//- (void)nslog:(NSString *)str; //协议里面要声明调用的方法

// 绑定JS 与 OC的方法  由于参数有变化 所以在html中 传参数要传正确
JSExportAs(nslog,
           - (void)printWithString:(NSString *)string callback:(NSString *)callback
           );
@end

@protocol JSOCDelegate <NSObject>
- (void)printLog:(NSString *)str;
@end

@interface JSOC_Object : NSObject <JSOC_ObjectJSExport>


@property (nonatomic, copy)     NSString *name;
@property (nonatomic, strong)   NSString *sex;
@property(strong, nonatomic)    UIWebView *webView;

@property (nonatomic, weak)   id <JSOCDelegate> delegate;

- (instancetype)initWithWebView: (UIWebView *)webView;
@end
