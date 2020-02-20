//
//  PullEyesController.m
//  BaseProject
//
//  Created by ZSXJ on 2018/10/9.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "PullEyesController.h"
#import "WXPullView.h"

@interface PullEyesController ()
@property (strong, nonatomic) WXPullView *pullView;
@end

@implementation PullEyesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"查看源码" style:(UIBarButtonItemStylePlain) target:self action:@selector(codeShow)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.pullView = [[WXPullView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) / 2) - 25, -34, 50, 30)];
    [self.tableView addSubview:self.pullView];
    
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pullView animationWith:scrollView.contentOffset.y];
}

- (void)codeShow {
    SourceViewController *vc = [[SourceViewController alloc] init];
    vc.filePath = SourcePathByClassName(@"WXPullView");
    [self.navigationController pushViewController:vc animated:YES];
}

@end
