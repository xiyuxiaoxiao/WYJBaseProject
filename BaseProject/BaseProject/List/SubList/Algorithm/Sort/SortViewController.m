//
//  SortViewController.m
//  BaseProject
//
//  Created by ZSXJ on 2017/8/17.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "SortViewController.h"
@interface SortViewController ()

@end

@implementation SortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"查看源码" style:(UIBarButtonItemStylePlain) target:self action:@selector(arraySort)];
    self.navigationItem.rightBarButtonItem = item;
}


- (void)arraySort {
    [self pushSortControllerWithClassName:@"SortArray"];
}

- (void)pushSortControllerWithClassName:(NSString *)className {
    SourceViewController *vc = [[SourceViewController alloc] init];
    vc.filePath = SourcePathByClassName(className);
    [self.navigationController pushViewController:vc animated:YES];
}

@end
