//
//  JSAndOC.m
//  BaseProject
//
//  Created by ZSXJ on 2017/9/19.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "JSAndOC.h"
#import "JSOC_Object.h"

@interface JSAndOC ()<JSOCDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel*logLabel;
@end

@implementation JSAndOC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadHtml];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"查看源码" style:(UIBarButtonItemStylePlain) target:self action:@selector(codeShow)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)codeShow {
    SourceViewController *vc = [[SourceViewController alloc] init];
    vc.filePath = SourcePathByClassName(@"JSAndOC");
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadHtml {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"JSAndOC"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [self.webView loadHTMLString:htmlCont baseURL:baseURL];
}

// oc 对象 注入js 环境
- (IBAction)jsToOC {
    JSOC_Object *js_oc_Object = [[JSOC_Object alloc] initWithWebView:self.webView];
    js_oc_Object.delegate = self;
    //创建JS运行环境。
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //将对象注入JS运行环境
    context[@"ttf"] = js_oc_Object;
}

// OC 调用 JS
- (IBAction)ocToJsAction:(id)sender {
    NSString *callbackJS = @"callBack('我是callback')";
    [self.webView performSelector:@selector(stringByEvaluatingJavaScriptFromString:) withObject:callbackJS afterDelay:0];
}

#pragma mark - JSOCDelegate
- (void)printLog:(NSString *)str {
    self.logLabel.text = str;
}

/*
 
 JSOCDelegate.h
 
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
 
 */

MakeSourcePath
@end
