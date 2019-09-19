//
//  ButtonByControlTestVC.m
//  BaseProject
//
//  Created by ZSXJ on 2019/9/18.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "ButtonByControlTestVC.h"
#import "WYJButton.h"
@interface ButtonByControlTestVC ()
@property (nonatomic, strong) WYJButton *button;
@end

@implementation ButtonByControlTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    WYJButton *button = [[WYJButton alloc] initWithFrame:CGRectMake(30, 100, 120, 40)];
    [button setTitle:@"没有选中" forState:(UIControlStateNormal)];
    [button setTitle:@"选中" forState:(UIControlStateSelected)];
    [button addTarget:self action:@selector(log:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    self.button = button;
    
    WYJButton *button2 = [[WYJButton alloc] initWithFrame:CGRectMake(30, 200, 120, 40)];
    [button2 setTitle:@"测试选中效果" forState:(UIControlStateNormal)];
    [button2 addTarget:self action:@selector(testSelec) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button2];
}

- (void)log: (WYJButton *)b {
    NSLog(@"揍你 %@",b);
}

- (void)testSelec {
    self.button.selected = !self.button.selected;
}


@end
