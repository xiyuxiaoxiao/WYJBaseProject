//
//  PieChartVC.m
//  BaseProject
//
//  Created by ZSXJ on 2018/4/20.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "PieChartVC.h"
#import "PicView.h"
#import "PicView2.h"

@interface PieChartVC ()
{
    PicView *pieView;
}
@end

@implementation PieChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addPicView];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(80, 300, 200, 200)];
    [self.view addSubview:view2];
    view2.backgroundColor = [UIColor greenColor];
    
    [self addPiceView2];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 100, 100)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor greenColor];
    
    
}

- (void)addPiceView2 {
    PicView2 *pieView = [[PicView2 alloc] initWithFrame:CGRectMake(80, 300, 200, 200)];
//    pieView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pieView];
    
    [pieView setDatas:[self getDatas] colors:@[[UIColor redColor],[UIColor purpleColor]]];
    [pieView stroke];
    
}

- (void)addPicView {
    pieView = [[PicView alloc] initWithFrame:CGRectMake(80, 100, 200, 200)];
    [self.view addSubview:pieView];
    
    [pieView setDatas:[self getDatas] colors:@[[UIColor redColor],[UIColor purpleColor]]];
    [pieView stroke];
    
    pieView.backgroundColor = [UIColor yellowColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [pieView setDatas:[self getDatas] colors:@[[UIColor redColor],[UIColor purpleColor]]];
    [pieView stroke];
}

- (NSArray *)getDatas{
    
//    return @[@(2),@(1),@(1)];
    return @[@(1),@(2),@(3),@(4)];
    
    int cout = arc4random() % 5;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < cout+1 ; i++) {
        
        [arr addObject:@(arc4random()%100)];
    }
    
    return arr;
}

@end
