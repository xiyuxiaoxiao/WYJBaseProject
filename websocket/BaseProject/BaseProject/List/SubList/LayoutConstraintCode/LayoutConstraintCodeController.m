//
//  LayoutConstraintCodeController.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/9.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "LayoutConstraintCodeController.h"
#import "LayoutConstraintCodeView.h"
@interface LayoutConstraintCodeController ()

@end

@implementation LayoutConstraintCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    LayoutConstraintCodeView *view = [[LayoutConstraintCodeView alloc] initWithFrame:CGRectMake(40, 100, 280, 80)];
    view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view];
    
    [view setContent];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"查看源码" style:(UIBarButtonItemStylePlain) target:self action:@selector(codeShow)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)codeShow {
    SourceViewController *vc = [[SourceViewController alloc] init];
    vc.filePath = SourcePathByClassName(@"LayoutConstraintCodeView");
    [self.navigationController pushViewController:vc animated:YES];
}

@end
