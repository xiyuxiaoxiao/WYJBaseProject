//
//  YJRippleVC.m
//  WYJNotePad
//
//  Created by ZSXJ on 16/7/11.
//  Copyright © 2016年 ShouXinTech. All rights reserved.
//

#import "YJRippleVC.h"
#import "YJRippleView.h"

@interface YJRippleVC ()
{
    YJRippleView *rippleView;
}
@end

@implementation YJRippleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rippleView = [[YJRippleView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    [self.view addSubview:rippleView];
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"查看源码" style:(UIBarButtonItemStylePlain) target:self action:@selector(lookCode)];
//    self.navigationItem.rightBarButtonItem = item;
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 查看代码
-(void) lookCode {
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"ripple" ofType:@"html"];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"q" ofType:@"txt"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    UIWebView *myWebView = [[UIWebView alloc] initWithFrame: self.view.bounds];
//    [myWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
//    [self.view addSubview:myWebView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.text = htmlString;
    [self.view addSubview:textView];
}

- (IBAction)buttonAction:(id)sender {
    
    CFTimeInterval timeOffset = [rippleView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    rippleView.layer.speed = 0;
    rippleView.layer.timeOffset = timeOffset;
}

// 恢复动画
- (IBAction)resume:(id)sender {
    
    CFTimeInterval pausedTime = [rippleView.layer timeOffset];
    rippleView.layer.speed = 1.0;
    rippleView.layer.timeOffset = 0.0;
    rippleView.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [rippleView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    rippleView.layer.beginTime = timeSincePause;
}

@end
