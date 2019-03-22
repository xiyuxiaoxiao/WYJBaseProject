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
    [self.dataArray addObject:@{TitleKey:@"即时通讯-本地数据库（通讯录、聊天记录）",
                                CN_Key:@"ChartHomeController"}];
}

@end
