//
//  BarChartVC.m
//  BaseProject
//
//  Created by ZSXJ on 2018/10/24.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "BarChartVC.h"
#import "BarChartView.h"

@interface BarChartVC ()

@end

@implementation BarChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(20, 50, 250, 200);
    BarChartView *view = [[BarChartView alloc] initWithFrame:frame];
    [self.view addSubview:view];
}


@end
