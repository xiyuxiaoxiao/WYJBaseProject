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
}

- (IBAction)qicukSort {
    [self pushSortControllerWithClassName:@"SortQuick"];
}

- (IBAction)bubbleSort {
    [self pushSortControllerWithClassName:@"SortBubble"];
}

- (IBAction)insertionSort {
    [self pushSortControllerWithClassName:@"SortInsert"];
}
//递归
- (IBAction)recursiveSort {
    [self pushSortControllerWithClassName:@"SortRecursive"];
}
- (void)pushSortControllerWithClassName:(NSString *)className {
    SourceViewController *vc = [[SourceViewController alloc] init];
    vc.filePath = SourcePathByClassName(className);
    [self.navigationController pushViewController:vc animated:YES];
}

@end
