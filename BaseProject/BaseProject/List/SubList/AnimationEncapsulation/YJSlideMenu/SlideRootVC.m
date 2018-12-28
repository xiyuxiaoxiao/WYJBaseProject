//
//  SlideRootVC.m
//  BaseProject
//
//  Created by ZSXJ on 2018/10/16.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "SlideRootVC.h"
#import "XLSlideMenu.h"
@interface SlideRootVC ()

@end

@implementation SlideRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"左边" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"右边" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItems = @[leftItem,backItem];
}
- (void)backAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)leftAction {
    [self.xl_sldeMenu showLeftViewControllerAnimated:true];
}

- (void)rightAction {
    [self.xl_sldeMenu showRightViewControllerAnimated:true];
}

@end
