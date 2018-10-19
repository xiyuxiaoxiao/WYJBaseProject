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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"左边" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"右边" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
}

- (void)leftAction {
    [self.xl_sldeMenu showLeftViewControllerAnimated:true];
}

- (void)rightAction {
    [self.xl_sldeMenu showRightViewControllerAnimated:true];
}

@end
