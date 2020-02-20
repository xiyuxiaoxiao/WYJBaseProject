//
//  DrawDashLineVC.m
//  WYJNotePad
//
//  Created by WYJ on 16/5/16.
//  Copyright © 2016年 ShouXinTech. All rights reserved.
//

#import "DrawDashLineVC.h"
#import "DashLineView.h"
@interface DrawDashLineVC ()

@end

@implementation DrawDashLineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect lineFrame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 2);
    DashLineView *dashView1 = [[DashLineView alloc] init];
    dashView1.frame = lineFrame;
    dashView1.lineColor = [UIColor redColor];
    dashView1.index = 0;
    [self.view addSubview:dashView1];
    
    DashLineView *dashView2 = [[DashLineView alloc] init];
    dashView2.frame = lineFrame;
    dashView2.lineColor = [UIColor cyanColor];
    dashView2.index = 1;
    [self.view addSubview:dashView2];
    
    DashLineView *dashView3 = [[DashLineView alloc] init];
    dashView3.frame = lineFrame;
    dashView3.lineColor = [UIColor yellowColor];
    dashView3.index = 2;
    [self.view addSubview:dashView3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
