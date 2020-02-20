//
//  ChatEnterList.m
//  BaseProject
//
//  Created by ZSXJ on 2017/8/17.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "ChatEnterList.h"

@interface ChatEnterList ()

@end

@implementation ChatEnterList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initData {
    [self.dataArray addObject:@{TitleKey:@"聊天发送图片自泡自定义layer 有待完善",
                                CN_Key:@"MessageController"}];
    [self.dataArray addObject:@{TitleKey:@"即时通讯-本地数据库（通讯录、聊天记录）",
                                CN_Key:@"ChartHomeController"}];
    [self.dataArray addObject:@{TitleKey:@"websocket",
                                CN_Key:@"WebSocketHomeVC"}];
}

@end
