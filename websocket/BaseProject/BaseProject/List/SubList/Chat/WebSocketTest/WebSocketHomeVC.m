//
//  WebSocketHomeVC.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/3.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WebSocketHomeVC.h"
#import "SocketRocketUtility.h"

@interface WebSocketHomeVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation WebSocketHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidClose) name:kWebSocketDidCloseNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketdidReceiveMessageNote object:nil];
    
}

- (IBAction)connectPort:(id)sender {
    
    /*
        123.56.218.1:30001   (有可能端口地址不对)
        ws://localhost:3000
        ws://192.168.1.103:3000
        ws://echo.websocket.org   websocket官网提供的
        ws://39.96.27.144:30005 新提供的
     */
    [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:@"ws://localhost:3000"];
}
// 发消息
- (IBAction)sendPort:(id)sender {
    
    [[SocketRocketUtility instance] sendData:@"hello world"];
}
// 关闭
- (IBAction)closePort:(id)sender {
    //在需要得地方 关闭socket
    [[SocketRocketUtility instance] SRWebSocketClose];
}


- (void)SRWebSocketDidOpen {
    NSLog(@"开启成功");
    //在成功后需要做的操作。。。
    [self logToTextView:@"开启成功"];
}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    //收到服务端发送过来的消息
    
    NSString * message = note.object;
    [self logToTextView:message];
}
- (void)SRWebSocketDidClose {
    [self logToTextView:@"关闭"];
}

- (void)logToTextView: (NSString *)msg {
    NSString *text =  self.textView.text;
    if (text.length < 0) {
        text = @"";
    }
    
    text = [text stringByAppendingString:@"\n"];
    text = [text stringByAppendingString:msg];
    
    self.textView.text = text;
}
@end
