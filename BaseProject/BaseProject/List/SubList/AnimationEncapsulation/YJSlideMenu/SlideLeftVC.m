//
//  SlideLeftVC.m
//  BaseProject
//
//  Created by ZSXJ on 2018/10/16.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "SlideLeftVC.h"

@interface SlideLeftVC ()

@end

@implementation SlideLeftVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blueColor];
    view.frame =CGRectMake(0, 100, 20, 20);
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor blueColor];
    
    view2.frame =CGRectMake([UIScreen mainScreen].bounds.size.width-20, 100, 20, 20);
    [self.view addSubview:view];
    [self.view addSubview:view2];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
