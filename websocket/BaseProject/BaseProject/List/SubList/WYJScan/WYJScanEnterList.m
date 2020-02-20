
//
//  WYJScanEnterList.m
//  BaseProject
//
//  Created by ZSXJ on 2017/8/17.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "WYJScanEnterList.h"

@interface WYJScanEnterList ()

@end

@implementation WYJScanEnterList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initData {
    [self.dataArray addObject:@{TitleKey:@"系统-扫码",
                                CN_Key:@"ScanSysController"}];
}

@end
