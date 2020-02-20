//
//  CommonBugEnter.m
//  BaseProject
//
//  Created by ZSXJ on 2017/7/19.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "CommonBugEnter.h"

@interface CommonBugEnter ()

@end

@implementation CommonBugEnter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initData {
    [self.dataArray addObject:@{TitleKey:@"添加自己作为子view造成的闪退",
                                CN_Key:@"CanNotAddSelfAsSubView"}];
    
    [self.dataArray addObject:@{TitleKey:@"后台数据NSNull 闪退",
                                CN_Key:@"在根目录下的 ／解决bug／NSNull 后台数据崩溃"}];
}

@end
